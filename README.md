# DVote Flutter Native

This project is a Flutter Plugin that provides access to native code written in Rust. 

It provides out-of-the box support for cross-compiling native Rust code for all available iOS and Android architectures and call it from plain Dart using [Foreign Function Interface](https://en.wikipedia.org/wiki/Foreign_function_interface).

## Overview

DVote Flutter Native provides:
- ZK Snarks prove generation using [ZA](https://github.com/adria0/za/tree/master/binding/flutter/native)
- Poseidon hashes for Hex strings and plain strings

The following platforms and architectures are supported:
- Android
  - ARMv7
  - ARM 64
  - x86
- iOS
  - ARM 64
  - x86_64

Cross compilation for MacOS, Linux and Windows should not be difficult but is not available yet. 

For a census of 1 million claims, ZK proof generation times are in the range of:
- 2 to 4 seconds on a desktop computer
- 7 seconds (Android ARM 64) to 52 seconds (older Android ARM v7)

### Considerations

- Every census size needs the generation of a specific setup + proving key
  - The setup and the ceremony are out of the scope of this project
- A census of 1M claims takes 20Mb of space
  - Such data should be hosted elsewhere other than the repo itself
  - Standard proving keys can be placed on a CDN/IPFS and be fetched+cached when the app launches

## Getting started

### Import the native code

The Rust source code is located at [https://gitlab.com/vocdoni/dvote-rs](https://gitlab.com/vocdoni/dvote-rs) and mounted on the `rust` folder by git.

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
  - `target/aarch64-linux-android/release/libdvote.so`
  - `target/armv7-linux-androideabi/release/libdvote.so`
  - `target/i686-linux-android/release/libdvote.so`
- iOS library
  - `target/universal/release/libdvote.a`
- Bindings header
  - `target/bindings.h`

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
   s.platform = :ios, '8.0'
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
        └── x86
            └── libdvote.so@ -> ../../../../../rust/target/i686-linux-android/release/libdvote.so
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
