#!/bin/sh

VERSION=1.0.0
MODE=$1
HELP=$(cat <<END
ISM encryption manager v$VERSION

Usage: sh encryption_manager.sh [Mode]

Modes:
    -d  Decrypt data
    -e  Encrypt data
END
)

TARGET_DIR=./data
ARCHIVE=data.tar.gz
ENCRYPTED_FILE=data.enc
KEY_CHECKSUM=3c53f15d6e2363f2b51c3d510b17eef2cbebb8427cd17fc9cc495f4125d0b6e4

KEY_AS_ENV=$(grep ISM_ENCRYPTION_KEY .env | tr -d '\r')
export "${KEY_AS_ENV?}"

if [ ! "$(env | grep ISM_ENCRYPTION_KEY | cut -d '=' -f 2 | sha256sum | awk '{ print $1 }')" = "$KEY_CHECKSUM" ]; then echo "ISM_ENCRYPTION_KEY is not valid, it can be provided with .env file" && exit 1; fi

case $MODE in
    "-d")
        tar cvzf "$ARCHIVE.bak" "$TARGET_DIR" > /dev/null && echo "Created $TARGET_DIR backup at $ARCHIVE.bak"
        openssl enc -aes-256-cbc -d -pbkdf2 -in "$ENCRYPTED_FILE" -out "$ARCHIVE" -pass "pass:$ISM_ENCRYPTION_KEY" && echo "Decrypted $ENCRYPTED_FILE to $ARCHIVE"
        tar xvzf "$ARCHIVE" > /dev/null
        ;;
    "-e")
        tar cvzf "$ARCHIVE" "$TARGET_DIR"  > /dev/null && echo "Created $ARCHIVE from $TARGET_DIR"
        openssl enc -aes-256-cbc -pbkdf2 -in "$ARCHIVE" -out "$ENCRYPTED_FILE" -pass "pass:$ISM_ENCRYPTION_KEY"  && echo "Encrypted $ARCHIVE to $ENCRYPTED_FILE"
        ;;
    *)
        echo "$HELP"
        ;;
esac

