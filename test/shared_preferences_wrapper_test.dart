import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_wrapper/concrete_namespaced_wrapper.dart';
import 'package:shared_preferences_wrapper/encryption/aes_encryption.dart';
import 'package:shared_preferences_wrapper/encryption/salsa20_encryption.dart';
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

import 'setup_shared_preferences.dart';

void main() {
  setUp(() {
    setupSharedPreferences(); // Initialize mock SharedPreferences.
  });

  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Pump frames to allow the widget to build.
    await tester.pumpAndSettle();

    //await tester.runAsync(() => MyApp().encrypt());

    await tester.runAsync(() => MyApp().addStringToWrapper('string'));
    final stringResult =
        await tester.runAsync(() => MyApp().getStringFromSF('string'));
    expect(stringResult, 'Yung');

    await tester.runAsync(() => MyApp().addIntToWrapper('int'));
    final intResult = await tester.runAsync(() => MyApp().getIntFromSF('int'));
    expect(intResult, 1);

    await tester.runAsync(() => MyApp().addDoubleToWrapper('double'));
    final doubleResult =
        await tester.runAsync(() => MyApp().getDoubleFromSF('double'));
    expect(doubleResult, 2.0);

    await tester.runAsync(() => MyApp().addBoolWrapper('bool'));
    final boolResult =
        await tester.runAsync(() => MyApp().getBoolFromSF('bool1'));
    expect(boolResult, false);

    Map<String, dynamic> allPrefs = {
      'string': 'Yung',
      'int': 1,
      'double': 2.0,
      'bool': true
    };
    final getAll = await tester.runAsync(() => MyApp().getAll());
    expect(getAll, allPrefs);

    await tester.runAsync(() => MyApp().remove('bool'));
    final exists = await tester.runAsync(() => MyApp().keyExists('bool'));
    expect(exists, false);

    await tester.runAsync(() => MyApp().clearPreferences());
    final isEmpty = await tester.runAsync(() => MyApp().empty());
    expect(isEmpty, true);

    await tester.runAsync(() => MyApp().addStringList('list'));
    final getStringList =
        await tester.runAsync(() => MyApp().getStringList('list'));
    expect(getStringList, ['item1', 'item2', 'item3']);

    await tester.runAsync(() => MyApp().addMap('map'));
    final mapResult = await tester.runAsync(() => MyApp().getMap('map'));
    expect(mapResult, {
      'name': 'Yung',
      'age': 30,
      'isStudent': true,
    });

    final mapKey = await tester.runAsync(() => MyApp().getMapKey('map', 'age'));
    expect(mapKey, 30);

    await tester.runAsync(() => MyApp().updateMapKey('map', 'age', 40));
    final updatedMapKey =
        await tester.runAsync(() => MyApp().getMapKey('map', 'age'));
    expect(updatedMapKey, 40);

    await tester.runAsync(() => MyApp().updateMap('map', {'surname': 'Cet'}));
    final containsKey =
        await tester.runAsync(() => MyApp().mapContainsKey('map', 'surname'));
    expect(containsKey, true);

    await tester.runAsync(() => MyApp().removeMapKey('map', 'surname'));
    final removedKey =
        await tester.runAsync(() => MyApp().mapContainsKey('map', 'surname'));
    expect(removedKey, false);

    await tester.runAsync(() => MyApp().addGroup());
    final groupResults = await tester.runAsync(() => MyApp().getGroup());
    expect(groupResults, {'username': 'JohnDoe'});

    await tester.runAsync(() => MyApp().set('str', 'yung'));
    final str = await tester.runAsync(() => MyApp().get('str'));
    expect(str, 'yung');

    await tester.runAsync(() => MyApp().set('intVal', 1));
    final intVal = await tester.runAsync(() => MyApp().get('intVal'));
    expect(intVal, 1);

    await tester.runAsync(() => MyApp().set('boolVal', true));
    final boolVal = await tester.runAsync(() => MyApp().get('boolVal'));
    expect(boolVal, true);

    await tester.runAsync(() => MyApp().set('doubleVal', 1.0));
    final doubleVal = await tester.runAsync(() => MyApp().get('doubleVal'));
    expect(doubleVal, 1.0);

    await tester.runAsync(() => MyApp().set('listStringVal', ['1', '2', '3']));
    final listStringVal =
        await tester.runAsync(() => MyApp().get('listStringVal'));
    expect(listStringVal, ['1', '2', '3']);

    await tester.runAsync(
        () => MyApp().set('mapVal', {'name': 'Yung', 'lname': 'Cet'}));
    final mapVal = await tester.runAsync(() => MyApp().get('mapVal'));
    expect(mapVal, {'name': 'Yung', 'lname': 'Cet'});

    final defaultVal =
        await tester.runAsync(() => MyApp().get('mapVal1', defaultValue: ''));
    expect(defaultVal, '');

    await tester.runAsync(() => MyApp().builder());
    final builder = await tester.runAsync(() => MyApp().get('builder_bool'));
    expect(builder, true);

    final prefs = await tester.runAsync(() => MyApp().namespace('account'));
    final account =
        await tester.runAsync(() => MyApp().getNamespace(prefs!, 'name'));
    expect(account, 'John Doe');

    await tester.runAsync(() => MyApp().deleteNamespace(prefs!));
    final checkNamespace =
        await tester.runAsync(() => MyApp().getNamespace(prefs!, 'name'));
    expect(checkNamespace, null);

    final aespin = await tester.runAsync(() => MyApp().aesEncryption());
    expect(aespin, '123456');

    final salsapin = await tester.runAsync(() => MyApp().salsa20Encryption());
    expect(salsapin, '123456');
  });
}

class MyApp extends StatelessWidget {
  // values
  final String stringValue = 'Yung';
  final String encryptionKey = 'my16CharacterKey';
  final String pinKey = 'pin';
  final String pin = '123456';
  final int intValue = 1;
  final double doubleValue = 2.0;
  final bool boolValue = true;
  final List<String> myStringList = ['item1', 'item2', 'item3'];
  final myMap = {
    'name': 'Yung',
    'age': 30,
    'isStudent': true,
  };

  MyApp({super.key});

  // Future<void> encrypt() async {
  //   SharedPreferencesWrapperEncryption.setEncryptionKey(encryptionKey);
  // }

  Future<void> addStringToWrapper(String myKey) async {
    await SharedPreferencesWrapper.addString(myKey, stringValue);
  }

  Future<void> addIntToWrapper(String myKey) async {
    await SharedPreferencesWrapper.addInt(myKey, intValue);
  }

  Future<void> addDoubleToWrapper(String myKey) async {
    await SharedPreferencesWrapper.addDouble(myKey, doubleValue);
  }

  Future<void> addBoolWrapper(String myKey) async {
    await SharedPreferencesWrapper.addBool(myKey, boolValue);
  }

  Future<void> addStringList(String myKey) async {
    await SharedPreferencesWrapper.addStringList(myKey, myStringList);
  }

  Future<void> addMap(String myKey) async {
    await SharedPreferencesWrapper.addMap(myKey, myMap);
  }

  Future<String?> getStringFromSF(String myKey) async {
    String? value =
        await SharedPreferencesWrapper.getString(myKey, defaultValue: '');
    return value;
  }

  Future<int?> getIntFromSF(String myKey) async {
    int? value = await SharedPreferencesWrapper.getInt(myKey);
    return value;
  }

  Future<double?> getDoubleFromSF(String myKey) async {
    double? value = await SharedPreferencesWrapper.getDouble(myKey);
    return value;
  }

  Future<bool?> getBoolFromSF(String myKey) async {
    bool? value =
        await SharedPreferencesWrapper.getBool(myKey, defaultValue: false);
    return value;
  }

  Future<List<String>?> getStringList(String myKey) async {
    List<String> value = await SharedPreferencesWrapper.getStringList(myKey);
    return value;
  }

  Future<Map<String, dynamic>?> getMap(String myKey) async {
    Map<String, dynamic>? value = await SharedPreferencesWrapper.getMap(myKey);
    return value;
  }

  Future<dynamic> getMapKey(String myKey, String mapKey) async {
    dynamic value = await SharedPreferencesWrapper.getMapKey(myKey, mapKey);
    return value;
  }

  Future<void> updateMapKey(String myKey, String mapKey, dynamic value) async {
    await SharedPreferencesWrapper.updateMapKey(myKey, mapKey, value);
  }

  Future<void> updateMap(String myKey, Map<String, dynamic> newMap) async {
    await SharedPreferencesWrapper.updateMap(myKey, newMap);
  }

  Future<void> removeMapKey(String myKey, String mapKey) async {
    await SharedPreferencesWrapper.removeMapKey(myKey, mapKey);
  }

  Future<bool> mapContainsKey(String myKey, String mapKey) async {
    final value = await SharedPreferencesWrapper.mapContainsKey(myKey, mapKey);
    return value;
  }

  Future<void> remove(String keyToRemove) async {
    await SharedPreferencesWrapper.removeAtKey(keyToRemove);
  }

  Future<void> clearPreferences() async {
    await SharedPreferencesWrapper.clearAll();
  }

  Future<Map<String, dynamic>> getAll() async {
    Map<String, dynamic> allPreferences =
        await SharedPreferencesWrapper.getAllSharedPreferences();
    return allPreferences;
  }

  Future<bool> keyExists(String myKey) async {
    bool? exists = await SharedPreferencesWrapper.keyExists(myKey);
    return exists;
  }

  Future<bool> empty() async {
    bool? isEmpty = await SharedPreferencesWrapper.isSharedPreferencesEmpty();
    return isEmpty;
  }

  Future<void> addGroup() async {
    await SharedPreferencesWrapper.addToGroup(
        'UserSettings', 'username', 'JohnDoe');
  }

  Future<Map<String, dynamic>?> getGroup() async {
    final map = await SharedPreferencesWrapper.getGroup('UserSettings');
    return map;
  }

  Future<void> set(String key, dynamic value) async {
    await SharedPreferencesWrapper.setValue(key, value);
  }

  Future<dynamic> get(String key, {dynamic defaultValue}) async {
    dynamic val = await SharedPreferencesWrapper.getValue(key,
        defaultValue: defaultValue);
    return val;
  }

  Future<void> builder() async {
    await SharedPreferencesWrapper.getBuilder().then((builder) => {
          builder
              .addBool('builder_bool', true)
              .addDouble('builder_double', 10.0)
              .addString('builder_str', 'str value')
              .addInt('builder_int', 100)
              .addMap('builder_map', {
            'name': 'Yung',
            'lname': 'Cet'
          }).addStringList('builder_list', ['item 1', 'item 2'])
        });
  }

  Future<ConcreteNamespacedPrefs> namespace(String namespace) async {
    final userPrefs = SharedPreferencesWrapper.createNamespace('user');
    await userPrefs.setValue('name', 'John Doe');
    return userPrefs;
  }

  Future<String?> getNamespace(
      ConcreteNamespacedPrefs prefs, String key) async {
    String? userName = await prefs.getValue('name');

    return userName;
  }

  Future<void> deleteNamespace(ConcreteNamespacedPrefs prefs) async {
    await prefs.clearNamespace();
  }

  Future<String?> aesEncryption() async {
    await SharedPreferencesWrapper.addString(pinKey, pin,
        aesEncryption: AESEncryption(encryptionKey: encryptionKey));

    String? mypin = await SharedPreferencesWrapper.getString(pinKey,
        aesDecryption: AESDecryption(encryptionKey: encryptionKey));

    return mypin;
  }

  Future<String?> salsa20Encryption() async {
    await SharedPreferencesWrapper.addString(pinKey, pin,
        salsa20Encryption: Salsa20Encryption(encryptionKey: encryptionKey));

    String? mypin = await SharedPreferencesWrapper.getString(pinKey,
        salsa20Decryption: Salsa20Decryption(encryptionKey: encryptionKey));

    return mypin;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: Scaffold(
        body: Center(
          child: Text('Hello, world!'),
        ),
      ),
    );
  }
}
