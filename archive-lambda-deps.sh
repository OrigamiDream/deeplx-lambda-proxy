#!/bin/bash

echo "Preparing Lambda deps"
pip install --platform manylinux2014_x86_64 \
            --target=service \
            --implementation cp \
            --python-version 3.10 \
            --only-binary=:all: \
            -t "python" \
            -r "requirements.txt"

echo "Archiving Lambda deps and handlers"
zip -r "deps.zip" "python"
zip -r "lambda.zip" "service"
