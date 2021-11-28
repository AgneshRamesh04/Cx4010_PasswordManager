from enum import unique
from flask import Flask, jsonify
from flask import Flask, flash, request, redirect, url_for, make_response
from flask_sqlalchemy import SQLAlchemy
from numpy import fabs
import sqlalchemy
from sqlalchemy import exc
from RSA import *
from aes_implmentation import *
from random_password_generator import *
from utils import *
import os


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///projectDB3.sqlite3'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False 
db = SQLAlchemy(app) 

class Users(db.Model):
    id = db.Column(db.Integer, primary_key = True) 
    username = db.Column(db.String(60), unique = True)
    password = db.Column(db.String(500))
    public_key = db.Column(db.String(800)) 
    enc_aes_key = db.Column(db.String(3434))

class Passwords(db.Model):
    id = db.Column(db.Integer, primary_key = True) 
    website = db.Column(db.String(60))
    username = db.Column(db.String(60))
    password = db.Column(db.String(500))
    nonce = db.Column(db.String(500))
    description = db.Column(db.String(500))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

if not os.path.exists('projectDB3.sqlite3'):
    db.create_all()

#used in verifyCredentials function in user_control.dart
#checks if there is a user with entered password and username
#if have returns the details of the user
@app.route('/verify', methods = ['GET'])
def verify():
    enteredUsername = request.args.get('username')
    passwordCT = request.args.get('password')
    
    reply = {}
    
    try:
        user = Users.query.filter_by(username = enteredUsername, password = passwordCT).first()
        print(user)
        
        if user == None:
            reply["verification"] = False
        else:
            reply["username"] = user.username
            reply['public_key'] = user.public_key
            reply['id'] = user.id
            reply["verification"] = True
    
    except exc.SQLAlchemyError:
        reply["verification"] = "error"
    
    response = jsonify(reply)
    return generateResponse(response)

#used in getWebsites function in passwords_control.dart
#fetcall all the websites and corresponding username for the given userID
@app.route('/getWebsites/<UserId>', methods = ['GET'])
def getWebsites(UserId = None):

    try: 
        sql_statement = "Select website, username, description from passwords where user_id = " + str(UserId)
        result = db.session.execute(sql_statement)

        password_websites = result.fetchall()
        for i in range(len(password_websites)):
            password_websites[i] = list(password_websites[i])
        
        response = jsonify({"Websites" : password_websites})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Websites" : []})
    
    return generateResponse(response)

#used in getPassword function in passwords_control.dart
#fectches the record from passwords matching the website and corresponding username 
@app.route('/getPassword/<website>/<userId>', methods = ['GET']) #might add userId
def getPassword(website = None, userId = None):
    
    try:
        website_data = website[1:len(website)-1].split(',')
        print(website_data)
        sql_statement = "Select * from passwords where website = '" + website_data[0].strip() + "' and username = '" + website_data[1].strip() +"'"
        result = db.session.execute(sql_statement)

        password = list(result.fetchone())

        print(password)

        '''
            View Password: AES
                Pre-condition: password is encrpyted by RSA AND AES 
                (1) get CT 
                (2) get private key 
                (3) aes_key = rsa_decrypt(private_key, login_table[0]['AES_key_encrypted'])
                (4) plaintext = rsa_decrypt(private_key, byte_enteredPassword_ct) and decode
        '''

        # (1)
        # byte_enteredPassword_ct = bytes(password[3], 'latin1')

        #(2)
        user = Users.query.filter_by(id=userId).first()
        #private_key = read_private_key(user.username)
        print('private_key')

        private_key = read_private_key('server')
        print('server private_key')

        #(3) Decrypt directly since user.enc_aes_key = byte
        aes_key = rsa_decrypt(private_key, user.enc_aes_key)
        print('aes_key')

        print(len(aes_key))
        print(len(password[3]))

        input_data = {
            "key": aes_key,
            "nonce": password[4],
            "ciphertext": password[3]
        }

        #RSA cipher text: Needs to be decrpyted with private key
        rsa_cipher_text_bytes = aes_decrypt(input_data) #returns in bytes

        print(type(rsa_cipher_text_bytes))

        rsa_cipher_text_str = rsa_cipher_text_bytes.decode('latin1')

        server_signature, server_public_key = server_sign(rsa_cipher_text_bytes)

        print('Completed signing')

        print(len(password))

        print(type(server_signature)) #bytes
        print(type(server_public_key)) #bytes

        password.append((server_signature).decode()) #decode to send as a string as bytes are not supported
        password.append((server_public_key).decode())

        # password.append((server_signature).decode('UTF-8'))  # decode to send as a string as bytes are not supported
        # password.append((server_public_key).decode('UTF-8'))
        print("============================================")
        print(len(password))
        # # # (3) RSA Decryption
        # plaintext = rsa_decrypt(private_key, rsa_cipher_text_bytes)
        # str_plaintext = plaintext.decode()

        plaintext_list = password
        plaintext_list[3] = rsa_cipher_text_str

        print(plaintext_list)

        response = jsonify({"Password" : plaintext_list})

    except exc.SQLAlchemyError:
        response = jsonify({"Password" : []})

    return generateResponse(response)

#used in deletePassword function in passwords_control.dart
#delets the paswword with given passwordID from the passwords table
@app.route('/deletePassword/<passwordId>', methods = ['GET'])
def deletePassword(passwordId = None):
    
    try:
        sql_statement = "delete from passwords where id = " + passwordId
        result = db.session.execute(sql_statement)
        db.session.commit()
        
        response = jsonify({"Status" : "Deleted"})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return generateResponse(response)


#used in addPassword function in passwords_control.dart
#checks if the user already has a password for the given website and username
#if not add the given details to the passwords table
@app.route('/addPassword', methods = ['GET'])
def addPassword():
    
    enteredWebsite = request.args.get('website')
    enteredUsername = request.args.get('username')
    enteredPassword = request.args.get('password')
    enteredDescription = request.args.get('desp')
    userId = request.args.get('userId')

    signature = str(request.args['sign'])
    public_key = str(request.args['publickey'])
    
    try:
        pass_exist = Passwords.query.filter_by(username = enteredUsername, website = enteredWebsite, user_id = userId).first()

        if pass_exist != None:
            return jsonify({"Status" : "Password Exists"})

        '''
        Add Password: Encrypt incoming password with AES
        Pre-condition: Password Encrypted by RSA 
        
        (1) Obtain private RSA key of user 
        (2) Obtain AES key by decrypting with private RSA key 
        (2) Encrypt with aes_encrypt(key, b'twitter') 
        '''
        #(1)
        user = Users.query.filter_by(id = userId).first()

        # public_pem = str.encode(user.secret)
        # public_key = serialization.load_pem_public_key(public_pem)
        # print('public_key')
        # private_key = read_private_key(user.username)
        # print('private_key')

        private_key = read_private_key('server')
        print('server private_key')

        # enteredPassword_ct = rsa_encrypt(public_key, bytes(enteredPassword, 'ascii'))
        # str_enteredPassword_ct = enteredPassword_ct.decode('latin1')
        # print('public_key')

        # isUserVerified = verify_user(enteredPassword, signature, public_key)
        # print(isUserVerified)

        print(public_key)

        # ed_signing(enteredPassword, signature, public_key)
        str_enteredPassword_ct = enteredPassword

        # (2)
        # get aes key: need to add AES column to data
        aes_key = rsa_decrypt(private_key, user.enc_aes_key)

        print('aes_key')

        # (3)
        # encrypt passsword with aes key
        byte_enteredPassword_ct = bytes(str_enteredPassword_ct, 'latin1')
        result = aes_encrypt(aes_key, byte_enteredPassword_ct)

        password = Passwords(
            website = enteredWebsite,
            username = enteredUsername,
            password = result['ciphertext'],
            nonce = result['nonce'],
            description  = enteredDescription,
            user_id = userId

        )
        db.session.add(password)
        db.session.commit()
        
        response = jsonify({"Status" : "Added"})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return generateResponse(response)


#used in editPassword function in passwords_control.dart
#updates the password for the given website and username
@app.route('/editPassword', methods = ['GET'])
def editPassword():
    
    website = request.args.get('website')
    username = request.args.get('username')
    enteredPassword = request.args.get('password')
    enteredDescription = request.args.get('desp')
    userId = request.args.get('userId')

    try:
        sql_statement = "update passwords set password = '{}', description =  '{}', nonce = '{}'  where user_id = {} and website = '{}' and username = '{}'"

        user = Users.query.filter_by(id=userId).first()

        # public_pem = str.encode(user.secret)
        # public_key = serialization.load_pem_public_key(public_pem)
        #
        # private_key = read_private_key(user.username)
        #
        # enteredPassword_ct = rsa_encrypt(public_key, bytes(enteredPassword, 'ascii'))
        #
        # str_enteredPassword_ct = enteredPassword_ct.decode('latin1')

        str_enteredPassword_ct = enteredPassword

        #coming from client

        # (2)
        # get aes key: need to add AES column to data
        private_key = read_private_key('server')
        print('server private_key')

        aes_key = rsa_decrypt(private_key, user.enc_aes_key)
        print(aes_key)
        # (3)
        # encrypt passsword with aes key
        byte_enteredPassword_ct = bytes(str_enteredPassword_ct, 'latin1')
        result = aes_encrypt(aes_key, byte_enteredPassword_ct)

        print(result)

        sql_statement = sql_statement.format(result['ciphertext'],enteredDescription, result['nonce'],userId,website,username)
        
        db.session.execute(sql_statement)
        db.session.commit()
        
        response = jsonify({"Status" : "Edited"})
    
    
    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return generateResponse(response)


#used in addUser function in user_control.dart
#checks if the given username already exists in the users table
#if not adds a new record with the given username and password
#must include key generations here
@app.route('/addUser', methods = ['GET'])
def addUser():
    enteredUsername = request.args.get('username')
    passwordCT= request.args.get('password')
    

    try:
        user_exist = Users.query.filter_by(username = enteredUsername).first()

        if user_exist != None:
            return jsonify({"Status" : "Username Exists"})

        public_pem, encrypted_aes_key = new_user_keys(enteredUsername)

        user = Users(
            username = enteredUsername,
            password = passwordCT,
            public_key = public_pem,
            enc_aes_key = encrypted_aes_key
        )

        db.session.add(user)
        db.session.commit()

        response = jsonify({"Status" : "Registered"})

    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return generateResponse(response)


@app.route('/encryptionTest/<passwordCTT>/<username>', methods = ['GET'])
def encryptionTest(passwordCTT = None, username = None):
    # passwordCT = request.args.get('password')
    # username = request.args.get('username')

    passw = [x.strip() for x in passwordCTT[1:len(passwordCTT)-1].split(',')]
    print(passw)

    stringlist=[x.decode('utf-8') for x in passw]
    print(stringlist)

    

    private_key = read_private_key(username)

    plainText = rsa_decrypt(private_key, passwordCTT)
    print(plainText)


def generateResponse(res):
    response = make_response(res)
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Headers", "*")
    response.headers.add("Access-Control-Allow-Methods", "*")
    return response

if __name__ == "__main__":
    # app.run(debug=True, ssl_context='adhoc')
    app.run(debug=True)
    # app.run(debug=True, host='127.0.0.1', port=5000)

