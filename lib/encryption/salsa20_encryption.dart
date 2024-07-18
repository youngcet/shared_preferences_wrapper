import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences_wrapper/encryption/encryption.dart';
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

/// Class responsible for Salsa20 encryption of data.
class Salsa20Encryption {
  final String encryptionKey;

  String accessKey = '';
  dynamic value;

  /// Constructor for [Salsa20Encryption] class.
  ///
  /// [encryptionKey] is the key used for encryption. It must be 32 characters long.
  /// [accessKey] is the key used to store and retrieve the encrypted value.
  Salsa20Encryption({
    required this.encryptionKey,
  });

  /// Asynchronously encrypts the value.
  ///
  /// Uses the Salsa20 algorithm for encryption.
  Future<String> get encrypt async {
    return await salsa20Encrypt(encryptionKey, value);
  }

  /// Encrypts [value] using Salsa20 encryption with the provided [secretKey].
  ///
  /// [secretKey] is the key used for encryption.
  /// [value] is the data to be encrypted.
  /// Returns the encrypted value as a Base64 string.
  Future<String> salsa20Encrypt(String secretKey, String value) async {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));
    final encrypted = encrypter.encrypt(value, iv: iv);

    await SharedPreferencesWrapper.addMap(
        EncryptionConstants.encryptionMapKey, {accessKey: secretKey});

    return encrypted.base64;
  }
}

/// Class responsible for Salsa20 decryption of data.
class Salsa20Decryption {
  final String encryptionKey;

  String accessKey = '';
  dynamic encryptedValue;

  /// Constructor for [Salsa20Decryption] class.
  ///
  /// [encryptionKey] is the key used for decryption. It must match the key used for encryption.
  /// [accessKey] is the key used to retrieve the encrypted value.
  Salsa20Decryption({
    required this.encryptionKey,
  });

  /// Asynchronously decrypts the [encryptedValue].
  ///
  /// Checks if the key exists in SharedPreferences and then decrypts the value.
  Future<dynamic> get decrypt async {
    bool isEncrypted = await SharedPreferencesWrapper.mapContainsKey(
        EncryptionConstants.encryptionMapKey, accessKey);
    if (isEncrypted) {
      return salsa20Decrypt(
          encryptionKey, Encrypted.fromBase64(encryptedValue));
    }
    return null;
  }

  /// Decrypts [encryptedValue] using Salsa20 decryption with the provided [secretKey].
  ///
  /// [secretKey] is the key used for decryption.
  /// [encryptedValue] is the data to be decrypted.
  /// Returns the decrypted value as a string.
  String salsa20Decrypt(String secretKey, Encrypted encryptedValue) {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));

    return encrypter.decrypt(encryptedValue, iv: iv);
  }
}
