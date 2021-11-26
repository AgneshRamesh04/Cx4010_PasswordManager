from enum import unique
from Crypto.Random import get_random_bytes
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from numpy import fabs
import sqlalchemy

from sqlalchemy import exc

import RSA, AES, random_password_generator

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///securePasswordsDB.sqlite3'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False 
db = SQLAlchemy(app) 

class Users(db.Model):
    id = db.Column(db.Integer, primary_key = True) 
    username = db.Column(db.String(60), unique = True)
    password = db.Column(db.String(1500))
    private_key_encrypted = db.Column(db.String(1500))
    public_key = db.Column(db.String(1500))
    AES_key_encrypted = db.Column(db.String(1500))

class Passwords(db.Model):
    id = db.Column(db.Integer, primary_key = True) 
    website = db.Column(db.String(60))
    username = db.Column(db.String(60))
    password = db.Column(db.String(1500))
    decription = db.Column(db.String(500))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

#used in verifyCredentials function in user_control.dart
#checks if there is a user with entered password and username
#if have returns the details of the user
@app.route('/verify', methods = ['GET'])
def verify():
    enteredUsername = request.args.get('username')
    passwordCT = request.args.get('password')
    
    print(passwordCT)
    print(enteredUsername)

    reply = {}
    
    try:
        user = Users.query.filter_by(username = enteredUsername, password = passwordCT).first()
        print(user)
        
        if user == None:
            reply["verification"] = False
        else:
            reply['username'] = user.username
            reply['pem'] = user.private_key_encrypted.decode("utf-8") 
            reply['public_key'] = user.public_key.decode("utf-8") 
            reply['id'] = user.id
            reply["verification"] = True
    
    except exc.SQLAlchemyError:
        reply["verification"] = "error"
    
    #response = jsonify(reply)
    return reply

#used in getWebsites function in passwords_control.dart
#fetcall all the websites and corresponding username for the given userID
@app.route('/getWebsites/<UserId>', methods = ['GET'])
def getWebsites(UserId = None):

    try: 
        sql_statement = "Select website, username, decription from passwords where user_id = " + str(UserId)
        result = db.session.execute(sql_statement)

        password_websites = result.fetchall()
        for i in range(len(password_websites)):
            password_websites[i] = list(password_websites[i])
        
        response = jsonify({"Websites" : password_websites})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Websites" : []})
    
    return response

#used in getPassword function in passwords_control.dart
#fectches the record from passwords matching the website and corresponding username 
@app.route('/getPassword/<website>', methods = ['GET']) #might add userId
def getPassword(website = None):
    
    try:
        website_data = website[1:len(website)-1].split(',')
        
        sql_statement = "Select * from passwords where website = '" + website_data[0].strip() + "' and username = '" + website_data[1].strip() +"'"
        result = db.session.execute(sql_statement)

        password = list(result.fetchone())
        response = jsonify({"Password" : password})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Password" : []})

    return response

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

    return response

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
    
    try:
        pass_exist = Passwords.query.filter_by(username = enteredUsername, website = enteredWebsite, user_id = userId).first()
        
        if pass_exist != None:
            return jsonify({"Status" : "Password Exists"})

        password = Passwords(
            website = enteredWebsite,
            username = enteredUsername,
            password = enteredPassword,
            decription  = enteredDescription,
            user_id = userId
        )
        db.session.add(password)
        db.session.commit()
        
        response = jsonify({"Status" : "Added"})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return response

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
        sql_statement = "update passwords set password = '{}', decription =  '{}'  where user_id = {} and website = '{}' and username = '{}'"
        sql_statement = sql_statement.format(enteredPassword,enteredDescription,userId,website,username)
        
        db.session.execute(sql_statement)
        db.session.commit()
        
        response = jsonify({"Status" : "Edited"})
    
    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})

    return response

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
        
        print('Create RSA Public and Private Key')
        public_key, pem = RSA.generate_rsa_key(passwordCT)

        #print(pem)
        print(public_key)
        print('AES Key')
        key = get_random_bytes(16)
        key_ct = RSA.rsa_encrypt(public_key, key)
        #print(key_ct)

        user = Users(
            username = enteredUsername,
            password = passwordCT,
            private_key_encrypted = pem,
            public_key = public_key,
            AES_key_encrypted = key_ct
        )
        db.session.add(user)
        db.session.commit()
        
        response = jsonify({"Status" : "Registered"})

    except exc.SQLAlchemyError:
        response = jsonify({"Status" : "Error"})
    
    return response

if __name__ == "__main__":
    app.run(debug=True)

