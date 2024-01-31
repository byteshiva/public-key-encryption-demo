#!/bin/bash

# Directory names
ALICE_DIR="receiver_alice"
BOB_DIR="sender_bob"

# Check if keys exist for Alice, and generate if not
if [ ! -f "$ALICE_DIR/alice_private.pem" ]; then
    if [ ! -d "$ALICE_DIR" ]; then
        mkdir "$ALICE_DIR"
    fi
    openssl genpkey -algorithm RSA -out "$ALICE_DIR/alice_private.pem"
    openssl rsa -pubout -in "$ALICE_DIR/alice_private.pem" -out "$ALICE_DIR/alice_public.pem"
fi

# Check if keys exist for Bob, and generate if not
if [ ! -f "$BOB_DIR/bob_private.pem" ]; then
    if [ ! -d "$BOB_DIR" ]; then
        mkdir "$BOB_DIR"
    fi
    openssl genpkey -algorithm RSA -out "$BOB_DIR/bob_private.pem"
    openssl rsa -pubout -in "$BOB_DIR/bob_private.pem" -out "$BOB_DIR/bob_public.pem"
fi

# Message to be encrypted for Alice
message_for_alice="Hi Alice, this is a confidential message for you."

# Show the original message
echo "Original Message for Alice: $message_for_alice"

# Switch to Alice's directory
cd "$ALICE_DIR"

# Encrypt using Alice's public key
echo "Encrypting message for Alice..."
openssl pkeyutl -encrypt -pubin -inkey alice_public.pem -in <(echo -n "$message_for_alice") -out encrypted_message_for_alice.bin

# Decrypt using Alice's private key
echo "Decrypting message for Alice..."
decrypted_message_for_alice=$(openssl pkeyutl -decrypt -inkey alice_private.pem -in encrypted_message_for_alice.bin)

echo "Decrypted Message for Alice: $decrypted_message_for_alice"

# Move back to the parent directory
cd ..

# Switch to Bob's directory
cd "$BOB_DIR"

# Message to be encrypted for Bob
message_for_bob="Hello Bob, this is a sensitive message just for you."

# Show the original message
echo "Original Message for Bob: $message_for_bob"

# Encrypt using Bob's public key
echo "Encrypting message for Bob..."
openssl pkeyutl -encrypt -pubin -inkey bob_public.pem -in <(echo -n "$message_for_bob") -out encrypted_message_for_bob.bin

# Decrypt using Bob's private key
echo "Decrypting message for Bob..."
decrypted_message_for_bob=$(openssl pkeyutl -decrypt -inkey bob_private.pem -in encrypted_message_for_bob.bin)

echo "Decrypted Message for Bob: $decrypted_message_for_bob"
