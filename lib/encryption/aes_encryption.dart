import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences_wrapper/encryption/encryption.dart';
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

/// Class responsible for AES encryption of data.
class AESEncryption {
  final String encryptionKey;
  final AESMode? mode;
  final String? padding;

  dynamic value;
  String accessKey = '';

  /// Constructor for [AESEncryption] class.
  ///
  /// [encryptionKey] is the key used for encryption. It must be 16, 24, or 32 characters long.
  /// [accessKey] is the key used to store and retrieve the encrypted value.
  /// [mode] is the AES mode (e.g., AESMode.sic). If not provided, AESMode.sic is used by default.
  /// [padding] is the padding scheme to be used. If not provided, the default padding is used.
  AESEncryption({
    required this.encryptionKey,
    this.mode,
    this.padding,
  });

  /// List of valid AES key lengths.
  List<int> get validAesKeyLength {
    return [16, 24, 32];
  }

  /// Asynchronously encrypts the value.
  ///
  /// Throws an exception if the [encryptionKey] length is not valid.
  Future<String> get encrypt async {
    if (!validAesKeyLength.contains(encryptionKey.length)) {
      throw Exception(
          "[SharedPreferencesWrapperEncryption AES] key length should be 16/24/32 characters.");
    } else {
      return await aesEncrypt(encryptionKey, value);
    }
  }

  /// Encrypts [value] using AES encryption with the provided [secretKey].
  ///
  /// [secretKey] is the key used for encryption.
  /// [value] is the data to be encrypted.
  /// Returns the encrypted value as a Base64 string.
  Future<String> aesEncrypt(String secretKey, String value) async {
    final key = Key.fromUtf8(secretKey);
    final iv = IV.fromLength(16);
    final encrypter =
        Encrypter(AES(key, mode: mode ?? AESMode.sic, padding: padding));
    final encrypted = encrypter.encrypt(value, iv: iv);

    await SharedPreferencesWrapper.addMap(
        EncryptionConstants.encryptionMapKey, {accessKey: secretKey});

    return encrypted.base64;
  }
}

/// Class responsible for AES decryption of data.
class AESDecryption {
  final String encryptionKey;
  final AESMode? mode;
  final String? padding;

  String accessKey = '';
  dynamic encryptedValue;

  /// Constructor for [AESDecryption] class.
  ///
  /// [encryptionKey] is the key used for decryption. It must match the key used for encryption.
  /// [accessKey] is the key used to retrieve the encrypted value.
  /// [mode] is the AES mode (e.g., AESMode.sic). If not provided, AESMode.sic is used by default.
  /// [padding] is the padding scheme to be used. If not provided, the default padding is used.
  AESDecryption({
    required this.encryptionKey,
    this.mode,
    this.padding,
  });

  /// Asynchronously decrypts the [encryptedValue].
  ///
  /// Checks if the key exists in the SharedPreferences and then decrypts the value.
  Future<dynamic> get decrypt async {
    bool isEncrypted = await SharedPreferencesWrapper.mapContainsKey(
        EncryptionConstants.encryptionMapKey, accessKey);
    if (isEncrypted) {
      return aesDecrypt(encryptionKey, Encrypted.fromBase64(encryptedValue));
    }
    return null;
  }

  /// Decrypts [encryptedValue] using AES decryption with the provided [secretKey].
  ///
  /// [secretKey] is the key used for decryption.
  /// [encryptedValue] is the data to be decrypted.
  /// Returns the decrypted value as a string.
  String aesDecrypt(String secretKey, Encrypted encryptedValue) {
    final key = Key.fromUtf8(secretKey);
    final iv = IV.fromLength(16);
    final encrypter =
        Encrypter(AES(key, mode: mode ?? AESMode.sic, padding: padding));

    return encrypter.decrypt(encryptedValue, iv: iv);
  }
}
