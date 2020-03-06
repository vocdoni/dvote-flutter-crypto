#import "DvoteNativePlugin.h"
#if __has_include(<dvote_native/dvote_native-Swift.h>)
#import <dvote_native/dvote_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dvote_native-Swift.h"
#endif

@implementation DvoteNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDvoteNativePlugin registerWithRegistrar:registrar];
}
@end
