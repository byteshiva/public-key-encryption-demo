#!/bin/bash

# Check if directories exist
if [ ! -d "sender_bob" ]; then
    mkdir sender_bob
fi

if [ ! -d "receiver_alice" ]; then
    mkdir receiver_alice
fi

# Generate Bob's private key and extract Bob's public key
openssl genpkey -algorithm RSA -out sender_bob/bob_private.pem
openssl rsa -pubout -in sender_bob/bob_private.pem -out sender_bob/bob_public.pem

# Generate Alice's private key and extract Alice's public key
openssl genpkey -algorithm RSA -out receiver_alice/alice_private.pem
openssl rsa -pubout -in receiver_alice/alice_private.pem -out receiver_alice/alice_public.pem

# Message to be encrypted
message_for_bob="Hi Bob, this is a confidential message for you."

# Switch to Bob's directory
cd sender_bob

# Encrypt using Bob's public key
openssl pkeyutl -encrypt -pubin -inkey bob_public.pem -in <(echo -n "$message_for_bob") -out encrypted_message_for_bob.bin

# Decrypt using Bob's private key
decrypted_message_for_bob=$(openssl pkeyutl -decrypt -inkey bob_private.pem -in encrypted_message_for_bob.bin)

echo "Decrypted Message for Bob: $decrypted_message_for_bob"

# Move back to the parent directory
cd ..

# Switch to Alice's directory
cd receiver_alice

# Message to be encrypted for Alice
message_for_alice="Hello Alice, this is a sensitive message just for you."

# Encrypt using Alice's public key
openssl pkeyutl -encrypt -pubin -inkey alice_public.pem -in <(echo -n "$message_for_alice") -out encrypted_message_for_alice.bin

# Decrypt using Alice's private key
decrypted_message_for_alice=$(openssl pkeyutl -decrypt -inkey alice_private.pem -in encrypted_message_for_alice.bin)

echo "Decrypted Message for Alice: $decrypted_message_for_alice"
