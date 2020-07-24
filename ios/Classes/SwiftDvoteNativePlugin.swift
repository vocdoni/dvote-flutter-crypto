import Flutter
import UIKit

public class SwiftDvoteNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // We are not using Flutter channels here
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Noop
    result(nil)
  }

  public func dummyMethodToEnforceBundling() {
    // Perform dummy calls to prevent tree shaking
    // This code will never be actually executed

    var a = digest_string_claim("this is a string");
    var b = digest_hex_claim("0x1234");
    free_cstr(a);
    free_cstr(b);
    generate_zk_proof("", "");
  }
}
