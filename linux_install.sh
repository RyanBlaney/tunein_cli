#!/bin/bash

# Build the project using dune
dune build

# Navigate to the directory where the built executable is located
cd _build/default/bin || { echo "Build directory not found"; exit 1; }

# Find the executable with the .exe extension and rename it
for file in *.exe; do
  # Strip the .exe extension
  mv "$file" "${file%.exe}"
done

# Copy the executable to ~/.local/bin with the desired name
mkdir -p ~/.local/bin
cp tunein_cli ~/.local/bin/tunein_cli

# Ensure the copied file is executable
chmod +x ~/.local/bin/tunein_cli

echo "Build and deploy complete. Executable copied to ~/.local/bin/tunein_cli"

