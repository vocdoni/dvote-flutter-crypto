#import <Flutter/Flutter.h>

@interface DvoteNativePlugin : NSObject<FlutterPlugin>
@end

// NOTE: Append the lines below to ios/Classes/DvoteNativePlugin.h

void free_cstr(char *s);

bool is_valid_signature(const char *signature_ptr, const char *msg_ptr, const char *public_key_ptr);

char *recover_signature(const char *signature_ptr, const char *msg_ptr);

char *sign_message(const char *msg_ptr, const char *hex_priv_key_ptr);
