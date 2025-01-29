import 'shared_preferences_wrapper.dart';

/// A cache manager class that uses [SharedPreferencesWrapper] to store data
/// with expiration times.
///
/// [SharedPreferencesWrapperCacheManager] allows caching of string data in 
/// shared preferences for a specified duration. It also provides methods to 
/// retrieve and clear cached data based on its expiration time.
///
/// ### Example Usage:
/// ```dart
/// // Cache data with an expiration duration of 1 hour
/// await SharedPreferencesWrapperCacheManager.cacheData('sessionToken', '123abc', Duration(hours: 1));
///
/// // Retrieve cached data
/// String? cachedToken = await SharedPreferencesWrapperCacheManager.getCachedData('sessionToken');
///
/// // Clear cache
/// await SharedPreferencesWrapperCacheManager.clearCachedData('sessionToken');
/// ```
///
/// This class ensures that data is automatically removed from the cache
/// when it has expired.
class SharedPreferencesWrapperCacheManager{
  // Key for storing cached data in shared preferences
  static const String _keyData = 'spw_exp';

  // Key for storing the expiration time in shared preferences
  static const String _expirationTime = 'expirationTime';

  /// get key for storing cached data in shared preferences
  static String getKey(){
    return _keyData;
  }

  // get key for storing the expiration time in shared preferences
  static String getExpirationTime(){
    return _expirationTime;
  }

  /// Caches the [data] associated with the given [key] for the specified 
  /// [expirationDuration].
  ///
  /// Once the data expires, it will be automatically removed from the 
  /// cache.
  /// 
  ///   Example usage:
  /// ```dart
  /// await SharedPreferencesWrapperCacheManager.cacheData('sessionToken', '123abc', Duration(hours: 1));
  /// ```
  ///
  /// - Parameters:
  ///   - [key]: The unique key to store the data under.
  ///   - [data]: The string data to be cached.
  ///   - [expirationDuration]: The duration after which the data will expire.
  ///
  static Future<void> cacheData(String key, dynamic data, Duration expirationDuration) async {
    DateTime expirationTime = DateTime.now().add(expirationDuration);
    await SharedPreferencesWrapper.addMap('$_keyData.$key', {key: data, _expirationTime: expirationTime.toIso8601String()});
  }

  /// Retrieves the cached data associated with the given [key], if it exists
  /// and has not expired.
  ///
  /// If the cached data has expired, it will be removed from the cache, and 
  /// `null` will be returned. If no data is found, `null` will also be returned.
  /// 
  ///  Example usage:
  /// ```dart
  /// await SharedPreferencesWrapperCacheManager.getCachedData('sessionToken');
  /// ```
  ///
  /// - Parameters:
  ///   - [key]: The unique key used to retrieve the cached data.
  ///
  /// - Returns: A [Future] that resolves to the cached data, or `null` if no 
  /// data is found or the data has expired.
  static Future<dynamic> getCachedData(String key) async {
    String? data = await SharedPreferencesWrapper.getMapKey('$_keyData.$key', key);
    String? expirationTimeStr = await SharedPreferencesWrapper.getMapKey('$_keyData.$key', _expirationTime);
    if (data == null || expirationTimeStr == null) {
      return null;
    }
    
    DateTime expirationTime = DateTime.parse(expirationTimeStr);
    if (expirationTime.isAfter(DateTime.now())) {
      return data;
    } else {
      await SharedPreferencesWrapper.removeMapKey('$_keyData.$key', key);
      await SharedPreferencesWrapper.removeMapKey('$_keyData.$key', _expirationTime);
      return null;
    }
  }

  /// Clears the cached data associated with the given [key].
  ///
  /// - Parameters:
  ///   - [key]: The unique key of the data to be cleared from the cache.
  ///
  /// Example usage:
  /// ```dart
  /// await SharedPreferencesWrapperCacheManager.clearCache('sessionToken'); 
  /// ```
  static Future<void> clearCache(String key) async {
    await SharedPreferencesWrapper.removeMapKey('$_keyData.$key', key);
    await SharedPreferencesWrapper.removeMapKey('$_keyData.$key', _expirationTime);
  }
}