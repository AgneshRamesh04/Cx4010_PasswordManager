#from encryption import EncryptDeCrypt
import json
import secrets
import string


'''
Cryptographically secure random numbers
'''
def generate_password():
    # secure password
    password = ''.join((secrets.choice(string.ascii_letters + string.digits + string.punctuation) for i in range(18)))
    return password
