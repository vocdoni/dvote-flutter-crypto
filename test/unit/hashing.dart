import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dvote_crypto/dvote_crypto.dart';

void hashing() {
  strHsahing();
  hexHashing();
  size32Hashes();
  matchStringHex();
  hashHexWith0x();
}

void strHsahing() {
  final strClaim =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  final b64Hash = Hashing.digestStringClaim(strClaim);

  expect(b64Hash, "iV5141xlrW8I217IitUHtoDC/gd/LMsgcF0zpDfUaiM=");
}

void hexHashing() {
  String hexClaim =
      "0x045a126cbbd3c66b6d542d40d91085e3f2b5db3bbc8cda0d59615deb08784e4f833e0bb082194790143c3d01cedb4a9663cb8c7bdaaad839cb794dd309213fcf30";
  String b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "nGOYvS4aqqUVAT9YjWcUzA89DlHPWaooNpBTStOaHRA=");

  hexClaim =
      "0x049969c7741ade2e9f89f81d12080651038838e8089682158f3d892e57609b64e2137463c816e4d52f6688d490c35a0b8e524ac6d9722eed2616dbcaf676fc2578";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "j7jJlnBN73ORKWbNbVCHG9WkoqSr+IEKDwjcsb6N4xw=");

  hexClaim =
      "0x049622878da186a8a31f4dc03454dbbc62365060458db174618218b51d5014fa56c8ea772234341ae326ce278091c39e30c02fa1f04792035d79311fe3283f1380";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "6CUGhnmKQchF6Ter05laVgQYcEWm0p2qlLzX24rk3Ck=");

  hexClaim =
      "0x04e355263aa6cbc99d2fdd0898f5ed8630115ad54e9073c41a8aa0df6d75842d8b8309d0d26a95565996b17da48f8ddff704ebcd1d8a982dc5ba8be7458c677b17";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "k0UwNtWW4UQifisXuoDiO/QGRZNNTY7giWK1Nx/hoSo=");

  hexClaim =
      "0x04020d62c94296539224b885c6cdf79d0c2dd437471425be26bf62ab522949f83f3eed34528b0b9a7fbe96e50ca85471c894e1aa819bbf12ff78ad07ce8b4117b2";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "5EhP0859lic41RIpIrnotv/BCR7v5nVcXsXkTXlbuhI=");

  hexClaim =
      "0x046bd65449f336b888fc36c64708940da0d1c864a0ac46236f60b455841a4d15c9b815ed725093b3266aaca2f15210d14a1eadf34efeda3bd44a803fbf1590cfba";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "oseI7fM8wWIYslDUOXJne7AOiK+IpFL3q8MTqiZHWw8=");

  hexClaim =
      "0x0412cf2bd4a9613ad988f7f008a5297b8e8c98df8759a2ef9d3dfae63b3870cfbb78d35789745f82710da61a61a9c06c6f6166bf1d5ce73f9416e6b67713001aa2";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "9Y3JcjUHZLGmENRQpnML/+TG2EbHWjU46h+LtT9sQi8=");

  hexClaim =
      "0x04a2e6914db4a81ea9ec72e71b41cf88d4bc19ea54f29ae2beb3db8e4acf6531b5c163e58427831832b10fce899a030d12e82a398d4eeefe451c7e261fba973be4";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "Llx5F6lP/hbU6ZTT10Q5PF+7o1VdylvrolT8vSHJMAA=");

  hexClaim =
      "0x041508189a6f1737f50dd2c603c1ded8a83f97073d33cbb317e7409c1487b8351aa2b89455cda61ce8ed3ba3c130372870b187239b900da8948a53ca3e02db9aaf";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "MyRpb4ZDTwtJNflc8ZbZdmKOf+fuZjUEZkgZMCmlKxw=");

  hexClaim =
      "0x04f11597483032666b20ec51b27e1337577f63a5e1d5962575b555bf899380ae15482f031a297094b0c60980f3c4f1f7ad2346de5357ad82a6a3d4eef2bd1956c6";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "ytwkzcBixiBMsblxEEPpiDFV6MCBG/IY+XUc6/+xIQ8=");

  hexClaim =
      "0x044c01f3d0ef3d60652aa7c6489b2f10edcae1b04a10460ab2d5e4bd752eb0686cac7aa6057fd4c65606e8a4c33c0b519b1764229395cde2c8537ee01136ef0776";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "VS5c2JQT3x++ltSQHqnCFIBHttdjU2Lk2RuCGkUhnQ8=");
}

void size32Hashes() {
  String hexClaim =
      "0x04c94699a259ec27e1cf67fe46653f0dc2f38e6d32abb33b45fc9ffe793171a44b4ff5c9517c1be22f8a47915debcf1e512717fe33986f287e79d2f3099725f179";
  String b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "uJM6qiWAIIej9CGonWlR0cU64wqtdlh+csikpC6wSgA=");
  int len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x0424a71e7c24b38aaeeebbc334113045885bfae154071426e21c021ebc47a5a85a3a691a76d8253ce6e03bf4e8fe154c89b2d967765bb060e61360305d1b8df7c5";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "9wxP7eLFnTk5VDsj9rXL63r7QPKTTjCkNhjZri1nEQA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x04ff51151c6bd759d723af2d0571df5e794c28b204242f4b540b0d3449eab192cafd44b241c96b39fa7dd7ead2d2265a598a23cba0f54cb79b9829d355d74304a2";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "iS7BUPgGpY/WAdWyZb0s1wE21tMz5ZWBc8LJ6jgqSwA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x043f10ff1b295bf4d2f24c40c93cce04210ae812dd5ad1a06d5dafd9a2e18fa1247bdf36bef6a9e45e97d246cfb8a0ab25c406cf6fe7569b17e83fd6d33563003a";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "CCxtK0qT7cTxCS7e4uONSHcPQdbQzBqrC3GQvFz4KwA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x0409d240a33ca9c486c090135f06c5d801aceec6eaed94b8bef1c9763b6c39708819207786fe92b22c6661957e83923e24a5ba754755b181f82fdaed2ed3914453";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "3/AaoqHPrz20tfLmhLz4ay5nrlKN5WiuvlDZkfZyfgA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x04220da30ddd87fed1b65ef75706507f397138d8cac8917e118157124b7e1cf45b8a38ac8c8b65a6ed662d62b09d100e53abacbc27500bb9d0365f3d6d60a981fa";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "YiEgjvg1VeCMrlWJkAuOQIgDX1fWtkHk9OBJy225UgA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);

  hexClaim =
      "0x04acdbbdba45841ddcc1c3cb2e8b696eae69ba9d57686bff0cd58e4033a08d9dc6c272a3577508cdb18bdb1c6fcc818538664bb6dc4cc32ee668198c7be044800c";
  b64Hash = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash, "UPqwKZBMhq21uwgLWJUFMgCBMPzhseiziVaqN4EQvwA=");
  len = base64Decode(b64Hash).length;
  expect(len, 32);
}

void matchStringHex() {
  String strClaim = "Hello";
  String hexClaim = "48656c6c6f"; // Hello
  String b64Hash1 = Hashing.digestStringClaim(strClaim);
  String b64Hash2 = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash1, b64Hash2);

  strClaim = "Hello UTF8 ©âëíòÚ ✨";
  hexClaim =
      "48656c6c6f205554463820c2a9c3a2c3abc3adc3b2c39a20e29ca8"; // Hello UTF8 ©âëíòÚ ✨
  b64Hash1 = Hashing.digestStringClaim(strClaim);
  b64Hash2 = Hashing.digestHexClaim(hexClaim);
  expect(b64Hash1, b64Hash2);
}

void hashHexWith0x() {
  String b64Hash1 = Hashing.digestHexClaim(
    "48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f",
  );
  String b64Hash2 = Hashing.digestHexClaim(
    "0x48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f",
  );
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim(
    "12345678901234567890123456789012345678901234567890123456789012345678901234567890",
  );
  b64Hash2 = Hashing.digestHexClaim(
    "0x12345678901234567890123456789012345678901234567890123456789012345678901234567890",
  );
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim(
    "01234567890123456789012345678901234567890123456789012345678901234567890123456789",
  );
  b64Hash2 = Hashing.digestHexClaim(
    "0x01234567890123456789012345678901234567890123456789012345678901234567890123456789",
  );
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim(
      "0000000000000000000000000000000000000000000000000000000000000000");
  b64Hash2 = Hashing.digestHexClaim(
      "0x0000000000000000000000000000000000000000000000000000000000000000");
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim(
      "8888888888888888888888888888888888888888888888888888888888888888");
  b64Hash2 = Hashing.digestHexClaim(
      "0x8888888888888888888888888888888888888888888888888888888888888888");
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim(
      "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
  b64Hash2 = Hashing.digestHexClaim(
      "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
  expect(b64Hash1, b64Hash2);

  b64Hash1 = Hashing.digestHexClaim("1234567890123456789012345678901234567890");
  b64Hash2 =
      Hashing.digestHexClaim("0x1234567890123456789012345678901234567890");
  expect(b64Hash1, b64Hash2);
}
