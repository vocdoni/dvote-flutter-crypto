#import <Flutter/Flutter.h>

@interface DvoteNativePlugin : NSObject<FlutterPlugin>
@end

// NOTE: Append the lines below to ios/Classes/DvoteNativePlugin.h

char *digest_hex_claim(const char *hex_claim_ptr);

char *digest_string_claim(const char *str_claim_ptr);

void free_cstr(char *string);
