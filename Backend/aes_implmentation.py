import json
from base64 import b64encode
from base64 import b64decode
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Random import get_random_bytes

# data = b"password"

'''
Same cipher: 

Cipher depends on the keys being generated
Nonce is determined by cipher which is fixed

https://pycryptodome.readthedocs.io/en/latest/src/cipher/classic.html#cbc-mode

'''
#simulated database
passwords_cipher = []
key = get_random_bytes(16)

def aes_encrypt(key, data):
    cipher = AES.new(key, AES.MODE_CTR)
    ct_bytes = cipher.encrypt(data)
    nonce = b64encode(cipher.nonce).decode('utf-8')
    ct = b64encode(ct_bytes).decode('utf-8')
    # result = json.dumps({'key':str(key),'nonce':nonce, 'ciphertext':ct})

    #only neccessary to obtain the key, nonce and cipher text for decryption
    result = {
        "nonce": nonce,
        "ciphertext": ct
    }

    return result

def aes_decrypt(json_input):
    try:
        #b64 = json.loads(json_input)
        nonce = b64decode(json_input['nonce'])
        ct = b64decode(json_input['ciphertext'])
        cipher = AES.new(json_input['key'], AES.MODE_CTR, nonce=nonce)
        pt = cipher.decrypt(ct)
        print("The message was: ", pt, type(pt))

        return pt
    except:
        print("Incorrect decryption")

def existing_aes_encrypt():
    pass


# password = aes_encrypt(key, b'facebook')
# print(password)
# # print(type(password['key']))
# print(type(password['nonce']))
# print(type(password['ciphertext']))
#
# passwords_cipher.append(password)
# print(passwords_cipher)
# aes_decrypt(passwords_cipher[0])
