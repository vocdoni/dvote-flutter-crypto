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
    // dummy calls to prevent tree shaking
    is_valid_signature("", "", "");
  }
}
