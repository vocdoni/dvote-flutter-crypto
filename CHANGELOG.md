## 0.10.2
- Use compressed public keys by default
- Generate Etherum wallets from Uint8List hashed entity address
  
## 0.10.1

- Temporary backoff: Using pure Dart until an iOS issue is addressed, failing to bundle native code when packaged for app store distribution

## 0.10.0

**Breaking changes**
- The plugin is now renamed as `dvote_crypto`
- Is exposes a common interface for pure Dart and Native implementations

## 0.9.4

- Adding support for symmetric encryption using SecretBox (sodalite - NaCl)

## 0.9.3

- Bring armv7 support back for iOS

## 0.9.2

- Version bump

## 0.9.1

- Supporting signatures with `v` values below `0x1b-0x1c`

## 0.9.0

- **Breaking**: Public keys are now compressed by default
- Allowing to compute compressed and uncompressed public keys
- Signature verification now supports compressed and uncompressed public keys

## 0.8.0

- Using the new Rust repository (dvote-rs-ffi)
- Encapsulating all methods within components and classes (`Wallet`, `Hashing` and `Snarks`)
- Moving the native bindings into a separate file

## 0.7.0

- Adding support for Ethereum signature verification and public key recovery

## 0.6.0

- Using rust cryptographic primitives for Wallet methods

## 0.5.0

* Adding all dummy calls in a self contained function
* Improve the example

## 0.4.0

* Adding dummy calls to `digest_hex_claim` and `free_cstr` so that the linker also includes them on Release mode

## 0.3.0

* Using the little-endian Poseidon hashing format

## 0.2.2

* Adding support for iOS ARMv7

## 0.2.1

* Uploading again with the proper library binaries

## 0.2.0

* Adding support to generate ZK proofs

## 0.1.0

* First release as a native only plugin
