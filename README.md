# DVote Flutter Crypto

This project is a Flutter Plugin that provides access to native cryptographic implementations written in Rust. It also provides a fallback pure-Dart implementation.

It provides out-of-the box support for cross-compiling native Rust code for all available iOS and Android architectures and call it from plain Dart using [Foreign Function Interface](https://en.wikipedia.org/wiki/Foreign_function_interface).

## Overview

The library provides:
- ZK Snarks proof generation using [ZA](https://github.com/adria0/za/tree/master/binding/flutter/native)
- Crypto wallet generation, key derivation and signing
- Poseidon hash for hexadecimal and plain strings (native only)
- Symmetric encryption using NaCl
- Asymmetric encryption using NaCl (Dart only)

The following platforms and architectures are supported:
- Android
  - arm v7
  - arm64
  - x86
  - x86_64
- iOS
  - arm64
  - x86_64

Cross compilation for MacOS, Linux and Windows should not be difficult but is not available yet. 

For a census of 1 million claims, ZK proof generation times are in the range of:
- 2 to 4 seconds on a desktop computer
- 3 seconds on a 2020 iPhone SE
- 7 seconds (Android ARM 64) to 52 seconds (older Android ARM v7)

### Considerations

- Every census size needs the generation of a specific setup + proving key
  - The setup and the ceremony are out of the scope of this project
- A census of 1M claims takes 20Mb of space
  - Such data should be hosted elsewhere other than the repo itself
  - Standard proving keys can be placed on a CDN/IPFS and be fetched+cached when the app launches

## Usage

Add [dvote_crypto](https://pub.dev/packages/dvote_crypto) to your `pubspec.yaml` file

```yaml
dependencies:
  dvote_crypto: ^0.10.1
```

### HD Wallets
Generating mnemonics and computing private/public keys

```dart
final wallet = EthereumWallet.random(hdPath: "m/44'/60'/0'/0/5");
final mnemonic = wallet.mnemonic;
final privKey = wallet.privateKey;
final pubKey = wallet.publicKey;
final addr = wallet.address;
```

### Signing
Computing signatures using ECDSA cryptography

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

// Signing plain text
final hexSignature = signString(messageToSign, privateKey);
final recoveredPubKey = recoverSignerPubKey(hexSignature, messageToSign);
final valid = isValidSignature(hexSignature, messageToSign, publicKey);
assert(valid);

// Signing reproduceable JSON data
final hexSignature2 = signJsonPayload({"hello": 1234}, privateKey);
final recoveredPubKey = recoverJsonSignerPubKey(hexSignature2, {"hello": 1234});
final valid2 = isValidJsonSignature(hexSignature2, {"hello": 1234}, publicKey);
assert(valid2);
```

Also available as async non-UI blocking functions:

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

// Signing plain text
final hexSignature = await signStringAsync(messageToSign, privateKey);
final recoveredPubKey = await recoverSignerPubKeyAsync(hexSignature, messageToSign);
final valid = await isValidSignatureAsync(hexSignature, messageToSign, publicKey);
assert(valid);

// Signing reproduceable JSON data
final hexSignature2 = await signJsonPayloadAsync({"hello": 1234}, privateKey);
final recoveredPubKey = await recoverJsonSignerPubKeyAsync(hexSignature2, {"hello": 1234});
final valid2 = await isValidJsonSignatureAsync(hexSignature2, {"hello": 1234}, publicKey);
assert(valid2);
```

### Symmetric Encryption
NaCl SecretBox string and byte encryption

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

String encrypted = Symmetric.encryptString("hello", "super-secret");
String decrypted = Symmetric.decryptString(encrypted, "super-secret");
assert(decrypted == "hello");

encrypted = await Symmetric.encryptStringAsync("hello", "super-secret");
decrypted = await Symmetric.decryptStringAsync(encrypted, "super-secret");
assert(decrypted == "hello");

// Available
static Uint8List encryptRaw(Uint8List buffer, String passphrase);
static Future<Uint8List> encryptRawAsync(Uint8List buffer, String passphrase);
static String encryptBytes(Uint8List buffer, String passphrase);
static Future<String> encryptBytesAsync(Uint8List buffer, String passphrase);
static String encryptString(String message, String passphrase);
static Future<String> encryptStringAsync(String message, String passphrase);
static Uint8List decryptRaw(Uint8List encryptedBuffer, String passphrase);
static Future<Uint8List> decryptRawAsync(Uint8List encryptedBuffer, String passphrase);
static Uint8List decryptBytes(String encryptedBase64, String passphrase);
static Future<Uint8List> decryptBytesAsync(String encryptedBase64, String passphrase);
```

### Asymmetric Encryption
NaCl SealedBox string and byte encryption

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

String encrypted = Asymmetric.encryptString("hello", hexPublicKey);
String decrypted = Asymmetric.decryptString(encrypted, hexPrivateKey);
assert(decrypted == "hello");

encrypted = await Asymmetric.encryptStringAsync("hello", hexPublicKey);
decrypted = await Asymmetric.decryptStringAsync(encrypted, hexPrivateKey);
assert(decrypted == "hello");

// Available
static Uint8List encryptRaw(Uint8List payload, String hexPublicKey);
static Future<Uint8List> encryptRawAsync(Uint8List payload, String hexPublicKey);
static String encryptBytes(Uint8List payload, String hexPublicKey);
static Future<String> encryptBytesAsync(Uint8List payload, String hexPublicKey);
static String encryptString(String message, String hexPublicKey);
static Future<String> encryptStringAsync(String message, String hexPublicKey);
static Uint8List decryptRaw(Uint8List encryptedBuffer, String hexPrivateKey);
static Future<Uint8List> decryptRawAsync(Uint8List encryptedBuffer, String hexPrivateKey);
static Uint8List decryptBytes(String encryptedBase64, String hexPrivateKey);
static Future<Uint8List> decryptBytesAsync(String encryptedBase64, String hexPrivateKey);
static String decryptString(String encryptedBase64, String hexPrivateKey);
static Future<String> decryptStringAsync(String encryptedBase64, String hexPrivateKey);
```

### Hashing
Poseidon hash is only available when using the native Rust library

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

final hash1 = Hashing.digestHexClaim("0x1234...");
final hash2 = Hashing.digestStringClaim("Hello world");
```

### Zero Knowledge Snarks
Generating ZK proofs is only available when using the native Rust library

```dart
import 'package:dvote_crypto/dvote_crypto.dart';

final circuitInputs = {...};
final proof1 = Snarks.generateZkProof(circuitInputs, "/path/to/proving.key");
final proof2 = await Snarks.generateZkProofAsync(circuitInputs, "/path/to/proving.key");
```

## Development

### Import the native code

The Rust source code is located at [https://github.com/vocdoni/dvote-rs-ffi](https://github.com/vocdoni/dvote-rs-ffi) and mounted on the `rust` folder by git.

```
$ git submodule init
$ git submodule update
```

### Compile the library

- Make sure that the Android NDK is installed
  - You might also need LLVM from the SDK manager
- Ensure that the env variable `$ANDROID_NDK_HOME` points to the NDK base folder
  - It may look like `/Users/name/Library/Android/sdk/ndk-bundle` on MacOS
  - And look like `/home/name/dev/android/ndk-bundle` on Linux
- On the `rust` folder:
  - Run `make` to see the available actions
  - Run `make init` to install the Rust targets
  - Run `make all` to build the libraries and the `.h` file
- Update the name of your library in `Cargo.toml`
  - You'll need to update the symlinks to target the new file names. See iOS and Android below.

Generated artifacts:
- Android libraries
  - `rust/target/aarch64-linux-android/release/libdvote.so`
  - `rust/target/armv7-linux-androideabi/release/libdvote.so`
  - `rust/target/i686-linux-android/release/libdvote.so`
  - `rust/target/x86_64-linux-android/release/libdvote.so`
- iOS library
  - `rust/target/universal/release/libdvote.a`
- Bindings header
  - `rust/target/bindings.h`

### Reference the shared objects

#### iOS

Ensure that `ios/dvote_native.podspec` includes the following directives:

```diff
...
   s.source           = { :path => '.' }
+  s.public_header_files = 'Classes**/*.h'
   s.source_files = 'Classes/**/*'
+  s.static_framework = true
+  s.vendored_libraries = "**/*.a"
   s.dependency 'Flutter'
   s.platform = :ios, '9.0'
...
```

On `flutter/ios`, place a symbolic link to the `libdvote.a` file

```sh
$ cd flutter/ios
$ ln -s ../rust/target/universal/release/libdvote.a .
```

Append the generated function signatures from `rust/target/bindings.h` into `flutter/ios/Classes/DVotePlugin.h`

```sh 
$ cd flutter/ios
$ cat ../rust/target/bindings.h >> Classes/DVotePlugin.h
```

In our case, it will append `char *rust_greeting(const char *to);` and `void rust_cstr_free(char *s);`

NOTE: By default, XCode will skip bundling the `libdvote.a` library if it detects that it is not being used. To force its inclusion, add a dummy method in `SwiftDVotePlugin.swift` that uses at least one of the native functions:

```kotlin
...
  public func dummyMethodToEnforceBundling() {
    rust_greeting("");
  }
}
```

If you won't be using Flutter channels, the rest of methods can be left empty.

#### Android

Similarly as we did on iOS with `libdvote.a`, create symlinks pointing to the binary libraries on `rust/target`.

You should have the following structure on `flutter/android` for each architecture:

```
src
└── main
    └── jniLibs
        ├── arm64-v8a
        │   └── libdvote.so@ -> ../../../../../rust/target/aarch64-linux-android/release/libdvote.so
        ├── armeabi-v7a
        │   └── libdvote.so@ -> ../../../../../rust/target/armv7-linux-androideabi/release/libdvote.so
        ├── x86
        │   └── libdvote.so@ -> ../../../../../rust/target/i686-linux-android/release/libdvote.so
        └── x86_64
            └── libdvote.so@ -> ../../../../../rust/target/x86_64-linux-android/release/libdvote.so
```

As before, if you are not using Flutter channels, the methods within `android/src/main/kotlin/com/dvote/dvote_native/DvoteNativePlugin.kt` can be left empty.

### Declare the bindings in Dart

In `/lib/dvote_native.dart`, initialize the function bindings from Dart and implement any additional logic that you need.

Load the library: 
```dart
final DynamicLibrary nativeExampleLib = Platform.isAndroid
    ? DynamicLibrary.open("libdvote.so")
    : DynamicLibrary.process();
```

Find the symbols we want to use, with the appropriate Dart signatures:
```dart
final Pointer<Utf8> Function(Pointer<Utf8>) rustGreeting = nativeExampleLib
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>("rust_greeting")
    .asFunction();

final void Function(Pointer<Utf8>) freeGreeting = nativeExampleLib
    .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("rust_cstr_free")
    .asFunction();
```

Call them:
```dart
// Prepare the parameters
final name = "John Smith";
final Pointer<Utf8> namePtr = Utf8.toUtf8(name);
print("- Calling rust_greeting with argument:  $namePtr");

// Call rust_greeting
final Pointer<Utf8> resultPtr = rustGreeting(namePtr);
print("- Result pointer:  $resultPtr");

final String greetingStr = Utf8.fromUtf8(resultPtr);
print("- Response string:  $greetingStr");
```

When we are done using `greetingStr`, tell Rust to free it, since the Rust implementation kept it alive for us to use it.
```dart
freeGreeting(resultPtr);
```

## Publishing to pub.dev

- Run `make init` to start developing
- Run `make publish` to update the symbolic links and upload to pub.dev

## More information
- https://dart.dev/guides/libraries/c-interop
- https://flutter.dev/docs/development/platform-integration/c-interop
- https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart
- https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-06-rust-on-ios.html
- https://mozilla.github.io/firefox-browser-architecture/experiments/2017-09-21-rust-on-android.html

## TO DO

- [ ] Document examples of Poseidon hash, generate Merkle Proofs and ZK proofs