from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from aes_implmentation import *
from random_password_generator import *
from RSA import *

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
    save_file(("{}_private.pem".format(user)), private_pem)

    public_key = private_key.public_key()

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    # save_file("public.pem", public_pem)

    str_public_pem = public_pem.decode()

    key = get_random_bytes(16)
    key_ct = rsa_encrypt(public_key, key)


    return str_public_pem, key_ct


# new_user_keys('Apple', 'Serene')
#
# private_key = read_private_key('Apple', 'Serene')
# print(private_key)