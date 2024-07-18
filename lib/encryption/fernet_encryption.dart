import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences_wrapper/encryption/encryption.dart';
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

/// A class to handle Fernet encryption for a given value and key.
class FernetEncryption {
  /// The encryption key used for encrypting the value.
  final String encryptionKey;

  /// The access key used to identify the encrypted value in shared preferences.
  final String accessKey;

  /// The value to be encrypted.
  dynamic value;

  /// Constructs a [FernetEncryption] instance with the given [encryptionKey] and [accessKey].
  FernetEncryption({
    required this.encryptionKey,
    required this.accessKey,
  });

  /// Encrypts the [value] using the Fernet encryption algorithm.
  ///
  /// Returns a [Future] that completes with the encrypted value as a Base64-encoded string.
  get encrypt async {
    var encryptedVal = await fernetEncrypt(encryptionKey, value);
    return encryptedVal;
  }

  /// Encrypts the given [value] with the provided [secretKey] using the Fernet encryption algorithm.
  ///
  /// Returns a [Future] that completes with the encrypted value as a Base64-encoded string.
  Future<String> fernetEncrypt(String secretKey, String value) async {
    final key = Key.fromUtf8(secretKey);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    final encrypted = encrypter.encrypt(value);

    await SharedPreferencesWrapper.addMap(
        EncryptionConstants.encryptionMapKey, {accessKey: secretKey});

    return encrypted.base64;
  }
}

/// A class to handle Fernet decryption for a given encrypted value and key.
class FernetDecryption {
  /// The encryption key used for decrypting the value.
  final String encryptionKey;

  /// The access key used to identify the encrypted value in shared preferences.
  final String accessKey;

  /// The encrypted value to be decrypted.
  dynamic encryptedValue;

  /// Constructs a [FernetDecryption] instance with the given [encryptionKey] and [accessKey].
  FernetDecryption({
    required this.encryptionKey,
    required this.accessKey,
  });

  /// Decrypts the [encryptedValue] using the Fernet decryption algorithm.
  ///
  /// Returns a [Future] that completes with the decrypted value.
  get decrypt async {
    dynamic descryptedVal;

    bool isEncrypted = await SharedPreferencesWrapper.mapContainsKey(
        EncryptionConstants.encryptionMapKey, accessKey);
    if (isEncrypted) {
      descryptedVal =
          fernetDecrypt(encryptionKey, Encrypted.fromBase64(encryptedValue));
    }

    return descryptedVal;
  }

  /// Decrypts the given [encryptedValue] with the provided [secretKey] using the Fernet decryption algorithm.
  ///
  /// Returns the decrypted value as a string.
  String fernetDecrypt(String secretKey, Encrypted encryptedValue) {
    final key = Key.fromUtf8(secretKey);
    final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);

    final decrypted = encrypter.decrypt(encryptedValue);

    return decrypted;
  }
}