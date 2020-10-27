#import <Flutter/Flutter.h>

@interface DvoteCryptoPlugin : NSObject<FlutterPlugin>
@end

// NOTE: Append the lines below to ios/Classes/DvoteNativePlugin.h

char *compute_address(const char *hex_private_key_ptr);

char *compute_private_key(const char *mnemonic_ptr, const char *hd_path_ptr);

char *compute_public_key(const char *hex_private_key_ptr);

char *compute_public_key_uncompressed(const char *hex_private_key_ptr);

char *decrypt_symmetric(const char *base64_cipher_bytes_ptr, const char *passphrase_ptr);

char *digest_hex_claim(const char *hex_claim_ptr);

char *digest_string_claim(const char *str_claim_ptr);

char *encrypt_symmetric(const char *message_ptr, const char *passphrase_ptr);

void free_cstr(char *string);

char *generate_mnemonic(int32_t size);

char *generate_zk_proof(const char *proving_key_path, const char *inputs);

bool is_valid(const char *hex_signature_ptr,
              const char *message_ptr,
              const char *hex_public_key_ptr);

char *recover_signer(const char *hex_signature_ptr, const char *message_ptr);

char *sign_message(const char *message_ptr, const char *hex_private_key_ptr);
