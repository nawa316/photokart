#!/bin/bash

# Clone or update Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git
else
  cd flutter && git pull && cd ..
fi

# Flutter setup
flutter/bin/flutter doctor
flutter/bin/flutter clean
flutter/bin/flutter config --enable-web

# Generate .env
echo "SUPABASE_URL=$SUPABASE_URL" > .env
echo "SUPABASE_KEY=$SUPABASE_KEY" >> .env
