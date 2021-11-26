import RSA
from AES import *
from hashing import * 
from random_password_generator import *

'''
global variables
'''
selection = 1;

login_table = []

def new_user():

    print('-' * 8)
    username = input('\nEnter your username: ')
    print('-' * 8)

    password = input('\nEnter your password or enter blank to get a random password: (Ensure that password is strong)\n')

    if (password == '1'): #if random password
        password = generate_password()
        
    hash_password = password_hash_sha256(password)

    return username,hash_password


while (selection != '0'):
    print('-'*8)
    print('Menu\n'
          '1. Create a new User\n'
          '2. Add in a new Password\n'
          '3. View all users\n'
          '0. Exit')
    selection  = input('\nSelect an item in the menu: ')

    if (selection == '0'):
        print('Bye!')
    if (selection == '1'):
        print('Create User')
        username,hash_password = new_user()
        
        print('Create RSA Public and Private Key')
        public_key, pem = RSA.generate_rsa_key(hash_password)

        print('AES Key')
        key = get_random_bytes(16)
        key_ct = RSA.rsa_encrypt(public_key, key)
    
        login_table_entry = {
            "username": username,
            "hash_password": hash_password, 
            "private_key_encrypted": pem,
            "public_key": public_key,
            "AES_key_encrypted": key_ct
        }
        login_table.append(login_table_entry)
        
    if (selection == '3'):
        if (len(login_table) > 0):
            print('------ List of Users ------\n')
            for i in range(len(login_table)):
                print(str(i) + '. ' + login_table[i]['user_id'])

        print('\n------ End of List of Users ------\n')
