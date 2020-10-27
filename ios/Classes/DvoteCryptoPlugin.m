#import "DvoteCryptoPlugin.h"
#if __has_include(<dvote_crypto/dvote_crypto-Swift.h>)
#import <dvote_crypto/dvote_crypto-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dvote_crypto-Swift.h"
#endif

@implementation DvoteCryptoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDvoteCryptoPlugin registerWithRegistrar:registrar];
}
@end
