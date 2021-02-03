import "./unit/encryption.dart";
import "./unit/hashing.dart";
import "./unit/signature.dart";
import "./unit/wallet.dart";

void main() {
  // Testing native mobile architectures on desktop environments
  // is not directly supported yet.

  // However, it is still possible to cross-compile to
  // Mac, Linux or Windows, load their respective library and
  // test from there.

  encryption();
  hashing();
  signature();
  wallet();
}
