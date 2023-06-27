#!/bin/bash

# Define directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CONFIG_DIR="$SCRIPT_DIR/../config_files"

# Check if CONFIG_DIR exists
if [[ ! -d $CONFIG_DIR ]]; then
    echo "Directory $CONFIG_DIR does not exist"
    exit 1
fi

# Generate certificates
openssl genrsa -out "$CONFIG_DIR/ca-key.pem" 2048 >/dev/null 2>&1

openssl req -x509 -new -nodes -key "$CONFIG_DIR/ca-key.pem" -sha256 -days 1825 \
     -out "$CONFIG_DIR/ca-cert.pem" -config "$CONFIG_DIR/ca.cnf" >/dev/null 2>&1

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$CONFIG_DIR/server-key.pem" -out "$CONFIG_DIR/server-cert.pem" \
    -config "$CONFIG_DIR/server.cnf" >/dev/null 2>&1

openssl req -new -sha256 -key "$CONFIG_DIR/server-key.pem" \
    -out "$CONFIG_DIR/server-cert.csr" -config "$CONFIG_DIR/server.cnf" >/dev/null 2>&1

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$CONFIG_DIR/client-key.pem" -out "$CONFIG_DIR/client-cert.pem" \
    -config "$CONFIG_DIR/client.cnf" >/dev/null 2>&1
