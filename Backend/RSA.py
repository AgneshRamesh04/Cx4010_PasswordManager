from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from AES import *

'''
RSA private and public key geenration 
taken from: 
https://gist.github.com/ostinelli/aeebf4643b7a531c248a353cee8b9461

references:
https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm

'''

# save file helper
def save_file(filename, content):
    f = open(filename, "wb")
    f.write(content)
    f.close()


def generate_private_key(password):
    # generate private key & write to disk
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096,
        backend=default_backend()
    )


    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(str.encode(password))
    )
    #save_file("private.pem", pem)

    return private_key


def generate_public_key(private_key):
    # generate public key
    public_key = private_key.public_key()
    pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    return pem


def read_private_key(password):
    with open("private.pem", "rb") as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=str.encode(password), # password should be secret
        )
    return private_key


def read_public_key():
    with open("public.pem", "rb") as key_file:
        public_key = serialization.load_pem_public_key(
            key_file.read()
        )

    return public_key



def generate_rsa_key(password):
    # generate private key & write to disk
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096,
        backend=default_backend()
    )

    public_key = generate_public_key(private_key) #made a change here so the key can be stored in the database
    #private_key.public_key()

    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(str.encode(password))
    )
    # save_file("private.pem", pem)

    return public_key, pem


def decrypt_private_key(pem, password):
    private_key = serialization.load_pem_private_key(
        pem,
        password=str.encode(password),  # password should be secret
    )
    return private_key


def rsa_encrypt(public_pem, message):
    public_key = serialization.load_pem_public_key(
        public_pem,
    )
    ciphertext = public_key.encrypt(
        message,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return ciphertext


def rsa_decrypt(private_key, ciphertext):
    plaintext = private_key.decrypt(
        ciphertext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return plaintext

# password = 'Apple'

# '''
# TEST CASES :
# '''
# key = get_random_bytes(16)
# print(type(key))

# # private_key = generate_private_key(password) #return pem
# # public_key = generate_public_key(private_key)

# public_key, pem = generate_rsa_key(password)

# #decryption
# private_key = decrypt_private_key(pem, password)

# ct = rsa_encrypt(public_key, key)

# plaintext = rsa_decrypt(private_key, ct) #obtain private key from pem

# print(plaintext == key)
