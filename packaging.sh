#!/bin/bash

if [ ! -f "dist/index.js" ]; then
    echo "Missing dist/index.js, please run pnpm build"
    exit
fi

if [ ! -d "package/dist" ]; then
    mkdir -p package/dist
fi

VERSION=$(node -p "require('./package.json').version")

cp LICENSE package.json README.md package/
cp dist/index.js package/dist/

tar czvf directus-extension-inline-form-interface-${VERSION}.tgz package

