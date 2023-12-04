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

  String text = '';

  void handleChangeListener() {
    print("Listener triggered!");
  }

  // Function to observe changes
  Function(String, dynamic) handleObserverChanges =
      (String key, dynamic newValue) {
    print("Observer triggered with data: key=$key value=$newValue");
  };

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // set an encryption key, this has to be 16/24/32 character long
      // CURRENTLY ONLY STRING DATA TYPES ARE SUPPORTED
      SharedPreferencesWrapperEncryption.setEncryptionKey('my16CharacterKey');

      // Registering Listeners with callback function for when a shared preference changes
      SharedPreferencesWrapper.addListener('key', handleChangeListener);

      // to trigger registered listeners callback
      Future.delayed(const Duration(seconds: 10), () {
        SharedPreferencesWrapper.addString('key', 'updated value');
        SharedPreferencesWrapper.addInt('int', 200);
      });

      // // storing values
      // // note: refer to the documentation for storing other data types
      await SharedPreferencesWrapper.addString('key', 'value');
      await SharedPreferencesWrapper.addInt('int', 100);

      // retrieve values
      final stringResult = await SharedPreferencesWrapper.getString('key');
      setState(() {
        text += '\nString value stored: $stringResult';
      });

      // // storing lists
      SharedPreferencesWrapper.addStringList('listkey', myStringList);
      // retrieving a list
      List<String> value =
          await SharedPreferencesWrapper.getStringList('listkey');

      setState(() {
        text += '\nList value stored: $value';
      });

      // // storing maps
      SharedPreferencesWrapper.addMap('mapkey', myMap);
      // retrieving a map
      Map<String, dynamic>? map =
          await SharedPreferencesWrapper.getMap('mapkey');

      setState(() {
        text += '\nStored Map values: $map';
      });

      // // note: refer to the documentation for storing other data types

      // // Adding multiple preferences at once
      Map<String, dynamic> dataToAdd = {
        'key1': 'value1',
        'key2': 42,
        'key3': true,
        'key4': ['item1', 'item2'],
        'key5': {'nestedKey': 'nestedValue'},
        // Add more key-value pairs as needed
      };
      await SharedPreferencesWrapper.addBatch(dataToAdd);
      // // access the batch data normally as you would,
      // //take note of the data type stored to call the correct corresponding method
      bool boolValue = await SharedPreferencesWrapper.getBool('key3');
      int intValue = await SharedPreferencesWrapper.getInt('key2');

      setState(() {
        text += '\n\nBatch Data: bool = $boolValue, int: = $intValue\n\n';
      });

      // // Updating existing preferences in batch
      Map<String, dynamic> dataToUpdate = {
        'key3': false,
        'key2': 100,
        // Update other keys as needed
      };
      await SharedPreferencesWrapper.updateBatch(dataToUpdate);

      bool boolValue1 = await SharedPreferencesWrapper.getBool('key3');
      int intValue1 = await SharedPreferencesWrapper.getInt('key2');
      setState(() {
        text += 'Updated Batch Data: bool = $boolValue1, int: = $intValue1\n\n';
      });

      // // Add preferences to a specific group
      await SharedPreferencesWrapper.addToGroup(
          'UserSettings', 'username', 'JohnDoe');
      await SharedPreferencesWrapper.addToGroup(
          'UserSettings', 'email', 'john@example.com');

      await SharedPreferencesWrapper.addToGroup(
          'AppSettings', 'darkMode', true);
      await SharedPreferencesWrapper.addToGroup(
          'AppSettings', 'language', 'English');

      // // Retrieve preferences from a specific group
      Map<String, dynamic>? userSettings =
          await SharedPreferencesWrapper.getGroup('UserSettings');
      Map<String, dynamic>? appSettings =
          await SharedPreferencesWrapper.getGroup('AppSettings');
      print('userSettings: $userSettings');
      print('appSettings: $appSettings');

      // Add an observer
      SharedPreferencesWrapper.addObserver('observer', handleObserverChanges);
      await SharedPreferencesWrapper.addString('observer', 'value1');

      // Remove an observer (when no longer needed)
      SharedPreferencesWrapper.removeObserver(
          'observer', handleObserverChanges);
      await SharedPreferencesWrapper.addString('observer', 'value2');

      await SharedPreferencesWrapper.setValue('usr', true);
      final val = await SharedPreferencesWrapper.getValue('usr');
      print('val: $val');
    });
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
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}
