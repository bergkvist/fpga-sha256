# fpga-sha256
SHA256 Hashing algorithm implemented in SystemVerilog

NOTE: For now, only a single 512-message block is accepted to sha256, and has to include relevant padding. That means the maximum supported message length currently is 55 bytes.

## Testing
```sh
# Run tests once
nix-shell --run "make test"

# Automatically rerun tests when input files change
nix-shell --run "make watch"
```