#convert *.cer (der format) to pem
openssl x509 -in aps_production.cer -inform DER -out test.pem -outform PEM

#convert p12 private key to pem (requires the input of a minimum 4 char password)
openssl pkcs12 -nocerts -out private_dev_key.pem -in private_dev_key.p12

# if you want remove password from the private key
openssl rsa -out private_key_noenc.pem -in private_key.pem

#take the certificate and the key (with or without password) and create a PKCS#12 format file
openssl pkcs12 -export -in test.pem -inkey private_key_noenc.pem -certfile AirforU.certSigningRequest  -name "airforu_pro" -out airforu_pro.p12