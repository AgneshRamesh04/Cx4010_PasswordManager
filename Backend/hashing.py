import hashlib
import random_password_generator
from random_password_generator import generate_password

'''
reference: https://sectigo.com/resource-library/what-is-sha-encryption
'''

string = "Python is the best"

def password_hash_sha256(pw):
    # sha256 offers 256-bit key and is one of the strongest hash function available.
    hash_func2 = hashlib.sha256()
    encoded_string = string.encode()
    hash_func2.update(encoded_string)
    message2 = hash_func2.hexdigest()
    return  message2


def password_hash_sha512(pw):
    # sha512 is a 512 bit (64 byte) hash function
    hash_func3 = hashlib.sha512()
    encoded_string = string.encode()
    hash_func3.update(encoded_string)
    message3 = hash_func3.hexdigest()
    print("sha512:", message3)
    return message3


# password = generate_password()
# hased_pw = password_hash_sha256(password)
# 
# print('generated random password: ', password)
# print("sha256:", hased_pw)

#testing 
# while(True):
#     print('Enter your password:')
#     password = input()
#     password_hash_sha256(password)







