from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from aes_implmentation import *
from random_password_generator import *
from RSA import *
import os


'''
AddUser: 
    str(RSA private key)
    str(RSA public key)
    RSA_encrypted(AES_key)
'''
def new_user_keys(user):
    # generate private key & write to disk
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096,
        backend=default_backend()
    )

    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )
    save_file_to_client(("{}_private.pem".format(user)), private_pem)

    public_key = private_key.public_key()

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    save_file("public.pem", public_pem)

    str_public_pem = public_pem.decode()
    str_private_pem = private_pem.decode()

    key = get_random_bytes(16)
    server_public_key = read_public_key('server')

    #Each User's AES is encrypted by the server's public key
    key_ct = rsa_encrypt(server_public_key, key)


    return str_public_pem, key_ct


def server_key():
    # generate private key & write to disk
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096,
        backend=default_backend()
    )

    # private_pem = private_key.private_bytes(
    #     encoding=serialization.Encoding.PEM,
    #     format=serialization.PrivateFormat.PKCS8,
    #     encryption_algorithm=serialization.NoEncryption()
    # )

    password = generate_password()
    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(str.encode(password))
    )
    save_file(("server_encrypted_private.pem"), pem)
    
    text_file = open("passphrase.txt", "w")
    n = text_file.write(password)
    text_file.close()

    public_key = private_key.public_key()

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    save_file("server_public.pem", public_pem)

if not os.path.exists('server_encrypted_private.pem') or not os.path.exists('server_public.pem'):
    server_key()