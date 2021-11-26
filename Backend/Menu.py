from RSA import *
from aes_implmentation import *
from hashing import *
from random_password_generator import *

'''
global variables
'''
selection = 1;

login_table = []
password_table = []


def new_user():
    print('-' * 8)
    username = input('\nEnter your username: ')
    print('-' * 8)

    # checking is done on client side to prevent leaking
    password = input(
        '\nEnter your password or enter blank to get a random password: (Ensure that password is strong)\n')

    # randomly generated passwords on server side
    if (password == ''):  # if random password
        password = generate_password()

    hash_password = password_hash_sha256(password)

    return username, hash_password

'''
@app.route('/addPassword/<enteredWebsite>/<enteredUsername>/'
        '<enteredPassword>/<enteredDescription>/<userId>', methods = ['GET'])

#used in addPassword function in passwords_control.dart
#checks if the user already has a password for the given website and username
#if not add the given details to the passwords table
'''
def new_password(user_id):
    '''
    Client Side: Client sends over, website, username
    '''
    website = input('Website: ')
    username = input('Username: ')
    password = input('Enter your password or enter blank to get a random password: \n')

    # randomly generated passwords on server side
    if (password == ''):  # if random password
        password = generate_password()

    # encrypt password with RSA before sending to server
    ct = rsa_encrypt(login_table[0]['public_key'], bytes(password, 'ascii'))

    print('cipher_Text')
    print(ct)

    '''
    Server Side
    '''
    # decryption
    # obtain private rsa key
    private_key = decrypt_private_key(login_table[0]['private_key_encrypted'], login_table[0]['hash_password'])

    # obtain aes key
    aes_key = rsa_decrypt(private_key, login_table[0]['AES_key_encrypted'])
    print('plaintext aes key : ', aes_key)

    # obtain password
    password_plain = rsa_decrypt(private_key, ct)
    print('Is the decoded RSA password the same? : ', password_plain == bytes(password, 'ascii'))

    # encrypt password
    result = aes_encrypt(aes_key, password_plain)

    password_table_entry = {
        "user_id": user_id,
        "website": website,
        "username": username,
        "nonce": result['nonce'],
        "ciphertext": result['ciphertext']
    }

    password_table.append(password_table_entry)

    print(password_table)

    # obtain aes key
    # who is the user?
    aes_key = rsa_decrypt(private_key, login_table[0]['AES_key_encrypted'])
    print('plaintext aes key : ', aes_key)

    input_data = {
        "key": aes_key,
        "nonce": password_table[0]['nonce'],
        "ciphertext": password_table[0]['ciphertext']
    }

    view_password = aes_decrypt(input_data)

    print(view_password)


'''
@app.route('/getPassword/<website>', methods = ['GET']) #might add userId

used in getPassword function in passwords_control.dart
fectches the record from passwords matching the website and corresponding username

'''
def decrpyt_password(selection):
    # selection: the specific portion

    # obtain aes key
    aes_key = rsa_decrypt(private_key, login_table[0]['AES_key_encrypted'])

    input_data = {
        "key": aes_key,
        "nonce": password_table[selection]['nonce'],
        "ciphertext": password_table[selection]['ciphertext']
    }

    view_password = aes_decrypt(input_data)

    print(view_password)


def view_users():
    print(login_table)
    if (len(login_table) > 0):
        for i in range(len(login_table)):
            print(str(i) + '. ' + login_table[i]['username'])



def view_passwords():
    print(password_table)


while (selection != '0'):
    print('-' * 8)
    print('Menu\n'
          '1. Create a new User\n'
          '2. Add in a new Password\n'
          '3. View all users\n'
          '4. View Passwords\n'
          '0. Exit')
    selection = input('\nSelect an item in the menu: ')

    if (selection == '0'):
        print('Exiting Application!')
    if (selection == '1'):
        '''
        Client Side Sends: 
            1. Master Username
            2. Master Password 
            3. RSA public and private key
        '''
        print('Create User')
        username, hash_password = new_user()

        print('Create RSA Public and Private Key')
        public_key, pem = generate_rsa_key(hash_password)

        '''
        Server side
        '''

        print('AES Key')
        key = get_random_bytes(16)
        print('key: ', key)
        key_ct = rsa_encrypt(public_key, key)
        private_key = decrypt_private_key(pem, hash_password)

        plaintext = rsa_decrypt(private_key, key_ct)
        print('plaintext: ', plaintext)
        print(plaintext == key)

        login_table_entry = {
            "id": 1,
            "username": username,
            "hash_password": hash_password,
            "private_key_encrypted": pem,
            "public_key": public_key,
            "AES_key_encrypted": key_ct
        }
        login_table.append(login_table_entry)

    if (selection == '2'):
        new_password('01')

    if (selection == '3'):
        view_users()

    if (selection == '4'):
        view_passwords()

    if (selection == '5'):
        view_passwords()
        pw_selection = input('Select the password you would like to view')
        decrpyt_password(int(pw_selection))

