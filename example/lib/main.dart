import 'package:flutter/material.dart';
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences Wrapper Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:
          const MyHomePage(title: 'Shared Preferences Wrapper Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stringValue = 'Yung';
  int intValue = 1;
  double doubleValue = 2.0;
  bool boolValue = true;
  List<String> myStringList = ['item1', 'item2', 'item3'];
  final myMap = {
    'name': 'Yung',
    'age': 30,
    'isStudent': true,
  };

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // store values
      await SharedPreferencesWrapper.addString('key', 'value');

      // retrieve values
      final stringResult = await SharedPreferencesWrapper.getString('key');
      print(stringResult);

      // storing lists
      await SharedPreferencesWrapper.addStringList('listkey', myStringList);
      // retrieving a list
      List<String> value =
          await SharedPreferencesWrapper.getStringList('listkey');

      // storing maps
      await SharedPreferencesWrapper.addMap('mapkey', myMap);
      // retrieving a map
      Map<String, dynamic>? map =
          await SharedPreferencesWrapper.getMap('mapkey');
    
      // check out the function below for storing and retrieving other data types and for more functions
    });
  }

  Future<void> addStringToWrapper(String myKey) async {
    await SharedPreferencesWrapper.addString(myKey, stringValue);
    final stringResult = await getStringFromSF('string');
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
    String? value = await SharedPreferencesWrapper.getString(myKey);
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
    bool? value = await SharedPreferencesWrapper.getBool(myKey);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '',
            ),
          ],
        ),
      ),
    );
  }
}
