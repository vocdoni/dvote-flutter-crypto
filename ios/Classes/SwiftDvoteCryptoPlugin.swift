import Flutter
import UIKit

public class SwiftDvoteCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // NOTE: We are not using Flutter channels here

    // let channel = FlutterMethodChannel(name: "dvote_crypto", binaryMessenger: registrar.messenger())
    // let instance = SwiftDvoteCryptoPlugin()
    // registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Noop
    result(nil)
    // result("iOS " + UIDevice.current.systemVersion)
  }

  public func dummyMethodToEnforceBundling() {
    // Perform dummy calls to prevent tree shaking
    // This code will never be actually executed

    let a = digest_string_claim("this is a string");
    let b = digest_hex_claim("0x1234");
    free_cstr(a);
    free_cstr(b);
    generate_zk_proof("", "");

    generate_mnemonic(192);
    compute_private_key("some mnemonic", "");
    compute_public_key("0x0000000000000000000000000000000000000000000000000000000000000001");
    compute_public_key_uncompressed("0x0000000000000000000000000000000000000000000000000000000000000001");
    compute_address("0x0000000000000000000000000000000000000000000000000000000000000001");

    encrypt_symmetric("", "");
    decrypt_symmetric("", "");

    sign_message("hello", "0x0000000000000000000000000000000000000000000000000000000000000001");
    recover_signer("", "");
    is_valid("", "", "");
  }
}
