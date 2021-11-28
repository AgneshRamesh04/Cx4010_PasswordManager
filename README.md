o	The main README.md file at the root of your repository should describe your project for laymen.
o	It should contain brief sections for motivation, research, design, development, use of the code.
o	Suggestion : Focus more on the application and usage of your code rather than the core theory.

# Password Manager
## Introduction 
This Password manager is a one stop solution to storing all your passwords securely and efficiently and all you need to do is remember one master password. To ensure that your password is stored securely we make use of state-of-the-art symmetric encryption (AES-128), asymmetric encryption RSA (Rivest-Shamir-Adleman) and digital signature methods(Ed25519).

Why would a I use a password manager? I can just store my passwords on my phone? 
On average every person on earth has approximate 100 passwords. When we have this many passwords to memorize, often times we make use of the same passwords on multiple platforms which is very bad practice and very insecure. When one of the services a user uses is compromised, this means that all platforms with the same passwords are equally as compromised. So, you should make use of a password manager to save you passwords securely without the hassle of memorising all of them. This Password Manager helps to generate a strong password that is different every time to ensure maximum security. 

### PBKDF2
Password-Based Key Derivation Function 2 (PBKDF2) makes it harder for someone to guess your Master Password through a brute-force attack.

### AES
AES is also known as Advanced Encryption Standard. It safeguards your data by creating a cipher that will conceal your data. This cipher will never be reused, and AES generates multiple variations of this cipher through nonces. 
•	AES-128: would take about 2.61*10^12 years to crack
### RSA 
RSA is a public-key encryption algorithm which makes use of asymmetric encryption to encrypt data. One key, the Public Key, is used for encryption and the other, the Private Key, is for decryption. As implied in the name, the Private Key is intended to be private so that only the authenticated recipient can decrypt the message. 
•	RSA-2048 bit encryption key: around 300 trillion years to crack
## ed25519 (Edwards-curve Digital Signature Algorithm )
Ed25519 is also a public-key encryption algorithm used for signature verification in this application. This means that we are using it to authenticate the source of the data. It is an elliptic-curve signatures, carefully engineered at several levels of design and implementation to achieve very high speeds without compromising security. Therefore, highly efficient while being very secure. 
•	ED25519: RSA with ~3000-bit keys > around 300 trillion years to crack

Why would a locally hosted password storage server require encryption? 
Once a user connects to an insecure connection (e.g. public wifi/ unknown wifi sources), any communication between the user and a server can be exposed. Therefore, it is essential that we encrypt all messages outbound from our devices and protect all message from a server that is holding onto our sensitive information as well. 
## Motivation and Research
For hashing algorithms in our research, we have learned about many hashing methods, like Argon2id, BLAKE3 and PBKDF2. While the chosen implementation that we ideally would like would be Argon2id as it is both secure against side channel and brute force attacks, however we were limited by our client (Flutter) and could not find a library which implemented this hashing algorithm. Therefore, we opted for PBKDF2 which was selected because of the slow hashing, preferable over SHA-256 which is faster and more prone to brute force attacks 

There are many options that we can choose from for all the encryption methos that we used. For example, in Symmetric Encryption, we have stream ciphers like ChaCha and Salsa20 and for block ciphers we have Blowfish and DES to name a few. In this instance, we have opted to not use stream ciphers due to the possibility of a Bit-flipping attack. We have decided on using AES because AES is objectively better and more secure than the NIST's now-outdated Data Encryption Standard (DES) primarily because of one key feature: key size. AES has longer keys, and longer keys are more secure.

For Asymmetric Encryption, the main consideration was between RSA and Elliptical Curve Cryptography methods. In this project, we have made use of albeit for different purposes. ECC was used for digital signatures while RSA was used for the most frequent encrypting of the password in the frontend as it is easier to implement and understand.

Initially, we wanted implement digital signatures with the use of a Probabilistic Signature Scheme (RSA - PSS). We did so because we observed that since RSA keys have already been generated and new keys do not need to be used it would be a convenient method. However, upon further research we concluded that it was not advisable to reuse the same keys in a different scenario therefore we sought for another solution where we ended up using Ed25519 Signature Algorithm as it is highly secure and extremely fast.

## Design and Development
In our application, we have made design choices to ensure that the user does not reveal unnecessary passwords. In our password manager, the user is only able to see the website and username initially. It is only when the user selects on a particular {website,username} pair, that we return the password. 

In development, we ran into many issues in terms of library availability. As flutter is still a new front end development platform. The cryptography libraries are not as highly maintained as compared to python where there are vast libraries of applications. Therefore, as reflected above, some choices on the algorithms selected were based on the libraries available to us which was double edge sword as it meant that we had to learn a lot more about other algorithms but also hinder our development and choices. 
