from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives import serialization
from aes_implmentation import *
from random_password_generator import *
from variables import clientPath

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
from cryptography.hazmat.primitives.asymmetric import ed25519


import base64


'''
RSA private and public key geenration 
taken from: 
https://gist.github.com/ostinelli/aeebf4643b7a531c248a353cee8b9461

references:
https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm

'''

def save_file_to_client(filename, content):
    f = open(clientPath + "/assets/keys/" + filename, "wb")
    f.write(content)
    f.close()

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
    save_file("private.pem", pem)

    return pem


def generate_public_key(private_key):
    # generate public key
    public_key = private_key.public_key()
    pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    save_file("public.pem", pem)

    return pem


def read_private_key(username):
    with open('passphrase.txt', "rb") as passphrase_file:
        phrase = passphrase_file.read()

    print(phrase)
    location = "{}_encrypted_private.pem".format(username)
    with open(location, "rb") as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(),
            password=phrase, # password should be secret
        )
    return private_key

def read_public_key(username):
    location = "{}_public.pem".format(username)
    with open(location, "rb") as key_file:
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

    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(str.encode(password))
    )
    save_file("private.pem", pem)

    public_key = private_key.public_key()

    pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    save_file("public.pem", pem)

    return public_key, pem


def decrypt_private_key(pem, password):
    private_key = serialization.load_pem_private_key(
        pem,
        password=str.encode(password),  # password should be secret
    )
    return private_key


def rsa_encrypt(public_key, message):
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

def generate_rsa_key_pem(password):
    # generate private key & write to disk
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=4096,
        backend=default_backend()
    )

    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(str.encode(password))
    )
    save_file("private.pem", private_pem)

    public_key = private_key.public_key()

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    save_file("public.pem", public_pem)

    str_public_pem = public_pem.decode()
    str_private_pem = private_pem.decode()

    return str_public_pem, str_private_pem


def ed_signing(message, signature, public_str):
    try:
        # or the public string can be read from the back end
        print('message')
        print(message)
        print('signature')
        print(signature)
        print('public_str')
        print(public_str)

        message =  bytes(message, 'utf-8')
        signature = bytes(signature, 'utf-8')


        print(type(message))
        print(type(signature))
        print(type(public_str))

        #read in user public string from database user.secret1
        public_bytes = base64.b64decode(public_str)

        loaded_public_key = ed25519.Ed25519PublicKey.from_public_bytes(public_bytes)

        # print(type(loaded_public_key)) #should be some kind of key value
        # # Raises InvalidSignature if verification fails
        # loaded_public_key.verify(signature, message)

        # Raises InvalidSignature if verification fails
        loaded_public_key.verify(signature, message)

        print('Verified!!!')

    except:
        print('failed !!!')

def server_sign(messageb):
    '''
    Boiler:
    private_key = Ed25519PrivateKey.generate()
    signature = private_key.sign(b"my authenticated message")
    public_key = private_key.public_key()
    # Raises InvalidSignature if verification fails
    public_key.verify(signature, b"my authenticated message")
    '''

    print('message', messageb)

    private_key = Ed25519PrivateKey.generate()
    public_key = private_key.public_key()

    public_bytes = public_key.public_bytes(
        encoding=serialization.Encoding.Raw,
        format=serialization.PublicFormat.Raw
    )

    loaded_public_key = ed25519.Ed25519PublicKey.from_public_bytes(public_bytes)

    signature = private_key.sign(messageb)

    print(loaded_public_key.verify(signature, messageb))
    print(public_key.verify(signature, messageb))

    print('public key', public_key)
    print('public bytes', public_bytes)
    print('encoded bytes', base64.b64encode(public_bytes))


    return base64.b64encode(signature), base64.b64encode(public_bytes)


private_key = ed25519.Ed25519PrivateKey.generate()
#get private bytes
private_bytes = private_key.private_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PrivateFormat.Raw,
    encryption_algorithm=serialization.NoEncryption()
)

#get public bytes
public_key = private_key.public_key()
public_bytes = public_key.public_bytes(
    encoding=serialization.Encoding.Raw,
    format=serialization.PublicFormat.Raw
)

print((public_bytes)) #b"\xb2\x87\xae\xbe\xdd\xb3\x86\x809\xf1X\xbe\xb6\x83m\xe4\xe4\xd040'i\xd5\x14E +\x1d=\x17\xb7\xb0"
print(base64.b64encode(public_bytes)) #bytes string b'soeuvt2zhoA58Vi+toNt5OTQNDAnadUURSArHT0Xt7A='

save_file("ed_public.txt", base64.b64encode(public_bytes))





# #
# # with open('passphrase.txt', 'w', encoding='utf-8') as f:
# #     f.write(passphrase)

# #user enter password apple
# passphrase = 'Apple'
# public_pem, private_pem = generate_rsa_key_pem(passphrase)



# #decode
# public_pem = str.encode(public_pem)
# private_pem = str.encode(private_pem)
# public_key = serialization.load_pem_public_key(public_pem)
# private_key = serialization.load_pem_private_key(private_pem,password=str.encode(passphrase))

# #adding in a new password
# #RSA

# ct = rsa_encrypt(public_key, bytes(passphrase, 'ascii'))  #ct is in bytes
# str_ct = ct.decode('latin1')
# byte_ct = bytes(str_ct, 'latin1')

# print(ct)

# #AES
# key = get_random_bytes(16)
# key_ct = rsa_encrypt(public_key, key)

# password = aes_encrypt(key, ct)
# # print(password)
# # # print(type(password['key']))
# # print(type(password['nonce']))
# # print(type(password['ciphertext']))
# #
# # passwords_cipher.append(password)
# # print(passwords_cipher)
# # aes_decrypt(passwords_cipher[0])

# plaintext = rsa_decrypt(private_key, byte_ct) #obtain private key from pem
# print(plaintext.decode())
# print(plaintext.decode() == passphrase)