import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  // AES encryption
  encrypt.Encrypted aesEncrypt(String plainText, String key) {
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(_padKey(key))),
    );
    return encrypter.encrypt(plainText, iv: iv);
  }

  String aesDecrypt(encrypt.Encrypted encrypted, String key) {
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key.fromUtf8(_padKey(key))),
    );
    return encrypter.decrypt(encrypted, iv: iv);
  }

  // RSA encryption
  AsymmetricKeyPair<PublicKey, PrivateKey> generateRSAKeyPair() {
    final keyGen = KeyGenerator('RSA/None/OAEP');
    final keyParams = RSAKeyGeneratorParameters(
      BigInt.from(65537),
      2048,
      64,
    );
    keyGen.init(ParametersWithRandom(
      keyParams,
      FortunaRandom()..seed(KeyParameter(Uint8List(32))),
    ));
    
    return keyGen.generateKeyPair();
  }

  String rsaEncrypt(String plainText, RSAPublicKey publicKey) {
    final cipher = OAEPEncoding(RSAEngine())
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );
    
    final plainBytes = utf8.encode(plainText);
    final encryptedBytes = cipher.process(Uint8List.fromList(plainBytes));
    
    return base64.encode(encryptedBytes);
  }

  String rsaDecrypt(String encryptedText, RSAPrivateKey privateKey) {
    final cipher = OAEPEncoding(RSAEngine())
      ..init(
        false,
        PrivateKeyParameter<RSAPrivateKey>(privateKey),
      );
    
    final encryptedBytes = base64.decode(encryptedText);
    final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
    
    return utf8.decode(decryptedBytes);
  }

  // Hashing
  String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = SHA256Digest().process(bytes);
    return _bytesToHex(digest);
  }

  String hmacSha256(String message, String key) {
    final hmac = HMac(SHA256Digest(), 64)
      ..init(KeyParameter(utf8.encode(_padKey(key))));
    
    final bytes = hmac.process(utf8.encode(message));
    return _bytesToHex(bytes);
  }

  // Password hashing with salt
  String hashPassword(String password, {String? salt}) {
    final generatedSalt = salt ?? _generateSalt();
    final saltedPassword = '$password$generatedSalt';
    final hashed = sha256Hash(saltedPassword);
    return '$hashed:$generatedSalt';
  }

  bool verifyPassword(String password, String hashedPassword) {
    final parts = hashedPassword.split(':');
    if (parts.length != 2) return false;
    
    final [storedHash, salt] = parts;
    final computedHash = hashPassword(password, salt: salt).split(':')[0];
    
    return storedHash == computedHash;
  }

  // Key derivation
  String deriveKey(String password, String salt, {int iterations = 10000}) {
    final generator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(
        utf8.encode(salt),
        iterations,
        32,
      ));
    
    final key = generator.process(utf8.encode(password));
    return _bytesToHex(key);
  }

  // Secure random
  String generateSecureRandom({int length = 32}) {
    final random = FortunaRandom();
    random.seed(KeyParameter(Uint8List(32)));
    
    final bytes = List<int>.generate(length, (_) => random.nextUint8());
    return _bytesToHex(bytes);
  }

  String generateUUID() {
    final random = FortunaRandom();
    random.seed(KeyParameter(Uint8List(32)));
    
    final bytes = List<int>.generate(16, (_) => random.nextUint8());
    
    // Format as UUID v4
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Variant 1
    
    final hex = _bytesToHex(bytes);
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  // Helper methods
  String _padKey(String key) {
    const requiredLength = 32;
    if (key.length >= requiredLength) {
      return key.substring(0, requiredLength);
    }
    
    return key.padRight(requiredLength, '0');
  }

  String _bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  String _generateSalt({int length = 16}) {
    final random = FortunaRandom();
    random.seed(KeyParameter(Uint8List(32)));
    
    final bytes = List<int>.generate(length, (_) => random.nextUint8());
    return _bytesToHex(bytes);
  }

  // Data signing
  String signData(String data, RSAPrivateKey privateKey) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    
    final dataBytes = utf8.encode(data);
    final signature = signer.generateSignature(Uint8List.fromList(dataBytes));
    
    return base64.encode((signature as RSASignature).bytes);
  }

  bool verifySignature(
    String data,
    String signature,
    RSAPublicKey publicKey,
  ) {
    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');
    verifier.init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
    
    final dataBytes = utf8.encode(data);
    final sigBytes = base64.decode(signature);
    
    return verifier.verifySignature(
      Uint8List.fromList(dataBytes),
      RSASignature(sigBytes),
    );
  }
}