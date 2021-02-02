import 'package:flutter_test/flutter_test.dart';
import 'package:dvote_crypto/dvote_crypto.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';

void wallet() {
  hdWalletSync();
  hdWalletAsync();
}

void hdWalletSync() {
  test("compress and expand public keys", () async {
    for (int i = 0; i < 10; i++) {
      final wallet = EthereumWallet.random();
      final uncompressed = HEX
          .decode(wallet.publicKey(uncompressed: true).replaceFirst("0x", ""));
      final compressed = compressPublicKey(uncompressed);
      expect(
          compressed,
          HEX.decode(
              wallet.publicKey(uncompressed: false).replaceFirst("0x", "")));
      expect(decompressPublicKey(compressed), uncompressed);
    }
    final List<Map<String, String>> items = [
      {
        'compressed':
            '0x02ab1a7f0cb763c4a8b30a2b8e3d0324e8db5cf2d25e906cae400ae7265083e7e2',
        'expanded':
            '0x04ab1a7f0cb763c4a8b30a2b8e3d0324e8db5cf2d25e906cae400ae7265083e7e20a7e6a0e1bf47f7d5280952b80b5fe9d380189243219518b7c62e57f68ed1c66'
      },
      {
        'compressed':
            '0x02531645fa5df607f2016070c12dd559d4a72a1acf61f2d499eb470a9aa42ebd17',
        'expanded':
            '0x04531645fa5df607f2016070c12dd559d4a72a1acf61f2d499eb470a9aa42ebd1765cae6e30245c4e742a158bc038dd93d90bb61298a4108219a41c74d24a90fc4'
      },
      {
        'compressed':
            '0x024014610da034308afe245ff6a120e5e4c8f6f7a07a69b966e46d1e1ccf320d6b',
        'expanded':
            '0x044014610da034308afe245ff6a120e5e4c8f6f7a07a69b966e46d1e1ccf320d6b6985c44c37468b587e1632aa12efab216992ffb2e577dbe50593c6cae07b02b2'
      },
      {
        'compressed':
            '0x0260c8ffa4cf0d52a2069a4d47f59b8fe0b8dd469bed2cf98196c53b1f5327d071',
        'expanded':
            '0x0460c8ffa4cf0d52a2069a4d47f59b8fe0b8dd469bed2cf98196c53b1f5327d071cb9495b461863a583fcda564e245e7504d8f304dbb10f62870cdd6ef8befc7fe'
      },
      {
        'compressed':
            '0x02dd06d88f8777da2a250920456df44c7eca71f7b3d9f18c0101d06a3e6d09a382',
        'expanded':
            '0x04dd06d88f8777da2a250920456df44c7eca71f7b3d9f18c0101d06a3e6d09a382b9e8c3fe821df14d6dddd77a49ed47d9b55f680323eb2e3b5a319cf14caddafe'
      },
      {
        'compressed':
            '0x02ca8f91c36ac0a4a08f77849079584d5a3d35c6baafc92762c1e1cd8967b87967',
        'expanded':
            '0x04ca8f91c36ac0a4a08f77849079584d5a3d35c6baafc92762c1e1cd8967b879674bd320cc2e6a4693f6297b8e5b2f00a1bdf5d4b4f392834f8dfe0dacc74f326a'
      },
      {
        'compressed':
            '0x0363ebf3ac245f883bc392a6df47fef9058f6408dd67d2a5d51c307bb66f35945a',
        'expanded':
            '0x0463ebf3ac245f883bc392a6df47fef9058f6408dd67d2a5d51c307bb66f35945a046f785eb9bf177eeff87ca57a559620fc995fd2f613326dab9dcb02618d768d'
      }
    ];
    items.forEach((item) {
      expect(
          compressPublicKey(
              HEX.decode(item['expanded'].replaceFirst("0x", ""))),
          (HEX.decode(item['compressed'].replaceFirst("0x", ""))));
    });
    items.forEach((item) {
      expect(
          decompressPublicKey(
              HEX.decode(item['compressed'].replaceFirst("0x", ""))),
          (HEX.decode(item['expanded'].replaceFirst("0x", ""))));
    });
  });

  test('Generate random mnemonics', () {
    final mnemonicRegExp = new RegExp(r"^[a-z]+( [a-z]+)+$");

    final wallet1 = EthereumWallet.random();
    expect(mnemonicRegExp.hasMatch(wallet1.mnemonic), true);
    expect(wallet1.mnemonic.split(" ").length, 18);

    final wallet2 = EthereumWallet.random();
    expect(mnemonicRegExp.hasMatch(wallet2.mnemonic), true);
    expect(wallet1.mnemonic != wallet2.mnemonic, true);
    expect(wallet2.mnemonic.split(" ").length, 18);

    final wallet3 = EthereumWallet.random(size: 160);
    expect(mnemonicRegExp.hasMatch(wallet3.mnemonic), true);
    expect(wallet1.mnemonic != wallet3.mnemonic, true);
    expect(wallet2.mnemonic != wallet3.mnemonic, true);
    expect(wallet3.mnemonic.split(" ").length, 15);

    final wallet4 = EthereumWallet.random(size: 128);
    expect(mnemonicRegExp.hasMatch(wallet4.mnemonic), true);
    expect(wallet1.mnemonic != wallet4.mnemonic, true);
    expect(wallet2.mnemonic != wallet4.mnemonic, true);
    expect(wallet3.mnemonic != wallet4.mnemonic, true);
    expect(wallet4.mnemonic.split(" ").length, 12);
  });

  test("Create a wallet for a given mnemonic", () {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'coral imitate swim axis note super success public poem frown verify then');
    expect(wallet.privateKey,
        '0x975a999c921f77c1812833d903799cdb7780b07809eb67070ac2598f45e9fb3f');
    expect(wallet.publicKey(uncompressed: false),
        '0x036fbd249af1bf365abd8d0cfc390c87ff32a997746c53dceab3794e2913d4cb26');
    expect(wallet.publicKey(uncompressed: true),
        '0x046fbd249af1bf365abd8d0cfc390c87ff32a997746c53dceab3794e2913d4cb26e055c8177faab65b404ea24754d8f56ef5df909a39d99ee0e7ca291a11556b37');
    expect(wallet.address, '0x6AAa00b7c22021F96B09BB52cb9135F0cB865c5D');

    wallet = EthereumWallet.fromMnemonic(
        'almost slush girl resource piece meadow cable fancy jar barely mother exhibit');
    expect(wallet.privateKey,
        '0x32fa4a65b9cb770235a8f0af497536035a459a98179c2c667972be279fbd1a1a');
    expect(wallet.publicKey(uncompressed: false),
        '0x0325eb0aac23fe343e7ac5c8a792898a4f1d55b3150f3609cde6b7ada2dff029a8');
    expect(wallet.publicKey(uncompressed: true),
        '0x0425eb0aac23fe343e7ac5c8a792898a4f1d55b3150f3609cde6b7ada2dff029a89430669dd7f39ffe72eb9b8335fef52fd70863d123ba0015e90cbf68b58385eb');
    expect(wallet.address, '0xf0492A8Dc9c84E6c5b66e10D0eC1A46A96FF74D3');

    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant');
    expect(wallet.privateKey,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');
    expect(wallet.publicKey(uncompressed: false),
        '0x02ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035');
    expect(wallet.publicKey(uncompressed: true),
        '0x04ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035fa54045f6361fa0c6b5914a33e0d6f2f435818f0268ec8196062d1521ea8451a');
    expect(wallet.address, '0x9612bD0deB9129536267d154D672a7f1281eb468');

    wallet = EthereumWallet.fromMnemonic(
        'life noble news naive know verb leaf parade brisk chuckle midnight play');
    expect(wallet.privateKey,
        '0x3c21df88530a25979494c4c7789334ba5dd1c8c73d23c4077a7f223c2274830f');
    expect(wallet.publicKey(uncompressed: false),
        '0x021d792012043464ac528d15e3309d4e55b41205380dfe14a01e2be95a30d0ac80');
    expect(wallet.publicKey(uncompressed: true),
        '0x041d792012043464ac528d15e3309d4e55b41205380dfe14a01e2be95a30d0ac80a313dbc6881d5f034c38d091cb27a0301b42faca820274e6a84d2268f8c4f556');
    expect(wallet.address, '0x34E3b8a0299dc7Dc53de09ce8361b41A7D888EC4');
  });

  test("Compute the private key for a given mnemonic and derivation path", () {
    // index 0
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/0");
    expect(wallet.privateKey,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');
    expect(wallet.publicKey(uncompressed: false),
        '0x02ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035');
    expect(wallet.publicKey(uncompressed: true),
        '0x04ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035fa54045f6361fa0c6b5914a33e0d6f2f435818f0268ec8196062d1521ea8451a');
    expect(wallet.address, '0x9612bD0deB9129536267d154D672a7f1281eb468');

    // index 1
    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/1");
    expect(wallet.privateKey,
        '0x2b8642b869998d77243669463b68058299260349eba6c893d892d4b74eae95d4');
    expect(wallet.publicKey(uncompressed: false),
        '0x03d8b869ceb2d90c2ab0b0eecd2f4215f42cb40a82e7de854ca14e85a1a84e00a4');
    expect(wallet.publicKey(uncompressed: true),
        '0x04d8b869ceb2d90c2ab0b0eecd2f4215f42cb40a82e7de854ca14e85a1a84e00a45e1c37334666acb08b62b19f42c18524d9d5952fb43054363350820f5190f17d');
    expect(wallet.address, '0x67b5615fDC5c65Afce9B97bD217804f1dB04bC1b');

    // index 2
    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/2");
    expect(wallet.privateKey,
        '0x562870cd36727fdca458ada4c2a34e0170b7b4cc4d3dc3b60cba3582bf8c3167');
    expect(wallet.publicKey(uncompressed: false),
        '0x03887f399e99ce751f82f73a9a88ab015db74b40f707534f54a807fa6e10982cbf');
    expect(wallet.publicKey(uncompressed: true),
        '0x04887f399e99ce751f82f73a9a88ab015db74b40f707534f54a807fa6e10982cbfaffe93414466b347b83cd43bc0d1a147443576446b49d0e3d6db24f37fe02567');
    expect(wallet.address, '0x0887fb27273A36b2A641841Bf9b47470d5C0E420');
  });

  test("Should derive different private keys for different entities", () {
    final mnemonic =
        "civil very heart sock decade library moment permit retreat unhappy clown infant";

    // No entity
    final entityAddress1 = null;
    final wallet1 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress1);

    // Entity with a zero address (should give exactly the same private key)
    final entityAddress2 =
        "0x0000000000000000000000000000000000000000000000000000000000000000";
    final wallet2 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress2);

    expect(wallet2.privateKey,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');

    expect(wallet1.privateKey, wallet2.privateKey);

    // Entity 3
    final entityAddress3 =
        "0x1111111111111111111111111111111111111111111111111111111111111111";
    final wallet3 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress3);

    expect(wallet3.privateKey,
        '0x0a2600d12242fdaae6a797036f21c7b26b387fc686682589fe35d15415db4159');

    expect(wallet1.privateKey == wallet3.privateKey, false);

    // Entity 4
    final entityAddress4 =
        "0x0123456789012345678901234567890123456789012345678901234567890123";
    final wallet4 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress4);

    expect(wallet4.privateKey,
        '0x1a1454a7ba52cffe903f87313b575fa2596c095e965a71ff6625e3006343516b');

    expect(wallet1.privateKey == wallet4.privateKey, false);
    expect(wallet3.privateKey == wallet4.privateKey, false);

    // Entity 5
    final entityAddress5 =
        "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
    final wallet5 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress5);

    expect(wallet5.privateKey,
        '0xe4c8ee3fccac1344084979ed81cf295c85d691286886cb6710db3fbafb35afb7');

    expect(wallet1.privateKey == wallet5.privateKey, false);
    expect(wallet3.privateKey == wallet5.privateKey, false);
    expect(wallet4.privateKey == wallet5.privateKey, false);

    // private keys from entities 2 (0x000...) and 5 (0xfff...) should be opposite on bytes 12-32
    final a = wallet2.privateKey.substring(2 + 24);
    final b = wallet5.privateKey.substring(2 + 24);
    final aBytes = HEX.decode(a);
    final bBytes = HEX.decode(b);

    for (int i = 0; i < aBytes.length; i++) {
      expect(aBytes[i] != bBytes[i], true);
      expect(aBytes[i] & bBytes[i], 0);
      expect(aBytes[i] + bBytes[i], 255);
    }
  });
}

void hdWalletAsync() {
  test('Generate random mnemonics [async]', () async {
    final mnemonicRegExp = RegExp(r"^[a-z]+(:? [a-z]+)+$");

    final wallet1 = await EthereumWallet.randomAsync();
    expect(mnemonicRegExp.hasMatch(wallet1.mnemonic), true);
    expect(wallet1.mnemonic.split(" ").length, 18);

    final wallet2 = await EthereumWallet.randomAsync();
    expect(mnemonicRegExp.hasMatch(wallet2.mnemonic), true);
    expect(wallet1.mnemonic != wallet2.mnemonic, true);
    expect(wallet2.mnemonic.split(" ").length, 18);

    final wallet3 = await EthereumWallet.randomAsync(size: 160);
    expect(mnemonicRegExp.hasMatch(wallet3.mnemonic), true);
    expect(wallet1.mnemonic != wallet3.mnemonic, true);
    expect(wallet2.mnemonic != wallet3.mnemonic, true);
    expect(wallet3.mnemonic.split(" ").length, 15);

    final wallet4 = await EthereumWallet.randomAsync(size: 128);
    expect(mnemonicRegExp.hasMatch(wallet4.mnemonic), true);
    expect(wallet1.mnemonic != wallet4.mnemonic, true);
    expect(wallet2.mnemonic != wallet4.mnemonic, true);
    expect(wallet3.mnemonic != wallet4.mnemonic, true);
    expect(wallet4.mnemonic.split(" ").length, 12);
  });

  test("Create a wallet for a given mnemonic [async]", () async {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'coral imitate swim axis note super success public poem frown verify then');
    expect(await wallet.privateKeyAsync,
        '0x975a999c921f77c1812833d903799cdb7780b07809eb67070ac2598f45e9fb3f');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x036fbd249af1bf365abd8d0cfc390c87ff32a997746c53dceab3794e2913d4cb26');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x046fbd249af1bf365abd8d0cfc390c87ff32a997746c53dceab3794e2913d4cb26e055c8177faab65b404ea24754d8f56ef5df909a39d99ee0e7ca291a11556b37');
    expect(await wallet.addressAsync,
        '0x6AAa00b7c22021F96B09BB52cb9135F0cB865c5D');

    wallet = EthereumWallet.fromMnemonic(
        'almost slush girl resource piece meadow cable fancy jar barely mother exhibit');
    expect(await wallet.privateKeyAsync,
        '0x32fa4a65b9cb770235a8f0af497536035a459a98179c2c667972be279fbd1a1a');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x0325eb0aac23fe343e7ac5c8a792898a4f1d55b3150f3609cde6b7ada2dff029a8');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x0425eb0aac23fe343e7ac5c8a792898a4f1d55b3150f3609cde6b7ada2dff029a89430669dd7f39ffe72eb9b8335fef52fd70863d123ba0015e90cbf68b58385eb');
    expect(await wallet.addressAsync,
        '0xf0492A8Dc9c84E6c5b66e10D0eC1A46A96FF74D3');

    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant');
    expect(await wallet.privateKeyAsync,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x02ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x04ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035fa54045f6361fa0c6b5914a33e0d6f2f435818f0268ec8196062d1521ea8451a');
    expect(await wallet.addressAsync,
        '0x9612bD0deB9129536267d154D672a7f1281eb468');

    wallet = EthereumWallet.fromMnemonic(
        'life noble news naive know verb leaf parade brisk chuckle midnight play');
    expect(await wallet.privateKeyAsync,
        '0x3c21df88530a25979494c4c7789334ba5dd1c8c73d23c4077a7f223c2274830f');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x021d792012043464ac528d15e3309d4e55b41205380dfe14a01e2be95a30d0ac80');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x041d792012043464ac528d15e3309d4e55b41205380dfe14a01e2be95a30d0ac80a313dbc6881d5f034c38d091cb27a0301b42faca820274e6a84d2268f8c4f556');
    expect(await wallet.addressAsync,
        '0x34E3b8a0299dc7Dc53de09ce8361b41A7D888EC4');
  });

  test(
      "Compute the private key for a given mnemonic and derivation path [async]",
      () async {
    // index 0
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/0");
    expect(await wallet.privateKeyAsync,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x02ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x04ae5f2ecb63c4b9c71e1b396c8206720c02bddceb01da7c9f590aa028f110c035fa54045f6361fa0c6b5914a33e0d6f2f435818f0268ec8196062d1521ea8451a');
    expect(await wallet.addressAsync,
        '0x9612bD0deB9129536267d154D672a7f1281eb468');

    // index 1
    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/1");
    expect(await wallet.privateKeyAsync,
        '0x2b8642b869998d77243669463b68058299260349eba6c893d892d4b74eae95d4');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x03d8b869ceb2d90c2ab0b0eecd2f4215f42cb40a82e7de854ca14e85a1a84e00a4');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x04d8b869ceb2d90c2ab0b0eecd2f4215f42cb40a82e7de854ca14e85a1a84e00a45e1c37334666acb08b62b19f42c18524d9d5952fb43054363350820f5190f17d');
    expect(await wallet.addressAsync,
        '0x67b5615fDC5c65Afce9B97bD217804f1dB04bC1b');

    // index 2
    wallet = EthereumWallet.fromMnemonic(
        'civil very heart sock decade library moment permit retreat unhappy clown infant',
        hdPath: "m/44'/60'/0'/0/2");
    expect(await wallet.privateKeyAsync,
        '0x562870cd36727fdca458ada4c2a34e0170b7b4cc4d3dc3b60cba3582bf8c3167');
    expect(await wallet.publicKeyAsync(uncompressed: false),
        '0x03887f399e99ce751f82f73a9a88ab015db74b40f707534f54a807fa6e10982cbf');
    expect(await wallet.publicKeyAsync(uncompressed: true),
        '0x04887f399e99ce751f82f73a9a88ab015db74b40f707534f54a807fa6e10982cbfaffe93414466b347b83cd43bc0d1a147443576446b49d0e3d6db24f37fe02567');
    expect(await wallet.addressAsync,
        '0x0887fb27273A36b2A641841Bf9b47470d5C0E420');
  });

  test("Should derive different private keys for different entities [async]",
      () async {
    final mnemonic =
        "civil very heart sock decade library moment permit retreat unhappy clown infant";

    // No entity
    final entityAddress1 = null;
    final wallet1 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress1);

    // Entity with a zero address (should give exactly the same private key)
    final entityAddress2 =
        "0x0000000000000000000000000000000000000000000000000000000000000000";
    final wallet2 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress2);

    expect(await wallet2.privateKeyAsync,
        '0x1b3711c03353ecbbf7b686127e30d6a37a296ed797793498ef24c04504ca5048');

    expect(await wallet1.privateKeyAsync, await wallet2.privateKeyAsync);

    // Entity 3
    final entityAddress3 =
        "0x1111111111111111111111111111111111111111111111111111111111111111";
    final wallet3 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress3);

    expect(await wallet3.privateKeyAsync,
        '0x0a2600d12242fdaae6a797036f21c7b26b387fc686682589fe35d15415db4159');

    expect(
        await wallet1.privateKeyAsync == await wallet3.privateKeyAsync, false);

    // Entity 4
    final entityAddress4 =
        "0x0123456789012345678901234567890123456789012345678901234567890123";
    final wallet4 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress4);

    expect(await wallet4.privateKeyAsync,
        '0x1a1454a7ba52cffe903f87313b575fa2596c095e965a71ff6625e3006343516b');

    expect(
        await wallet1.privateKeyAsync == await wallet4.privateKeyAsync, false);
    expect(
        await wallet3.privateKeyAsync == await wallet4.privateKeyAsync, false);

    // Entity 5
    final entityAddress5 =
        "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
    final wallet5 = EthereumWallet.fromMnemonic(mnemonic,
        entityAddressHash: entityAddress5);

    expect(await wallet5.privateKeyAsync,
        '0xe4c8ee3fccac1344084979ed81cf295c85d691286886cb6710db3fbafb35afb7');

    expect(
        await wallet1.privateKeyAsync == await wallet5.privateKeyAsync, false);
    expect(
        await wallet3.privateKeyAsync == await wallet5.privateKeyAsync, false);
    expect(
        await wallet4.privateKeyAsync == await wallet5.privateKeyAsync, false);

    // private keys from entities 2 (0x000...) and 5 (0xfff...) should be opposite
    final a = (await wallet2.privateKeyAsync).substring(2); // skip 0x
    final b = (await wallet5.privateKeyAsync).substring(2);
    final aBytes = HEX.decode(a);
    final bBytes = HEX.decode(b);

    for (int i = 0; i < aBytes.length; i++) {
      expect(aBytes[i] != bBytes[i], true);
      expect(aBytes[i] & bBytes[i], 0);
      expect(aBytes[i] + bBytes[i], 255);
    }
  });
}
