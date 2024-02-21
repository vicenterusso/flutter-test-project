import 'dart:math';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'main.g.dart';


// Define a collection
@Collection()
class Person {
  Id id = Isar.autoIncrement;
  late String name;
}

// Initialize Isar
final isar = Isar.openSync([PersonSchema], directory: '');

void main() async {
  // Insert a random Person at startup
  final random = Random();
  final personName = 'Person ${random.nextInt(100)}';
  await isar.writeTxn(() async {
    final person = Person()..name = personName;
    await isar.persons.put(person);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var persons = isar.persons.where().findAllSync();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Isar Test App')),
        body: ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(persons[index].name),
            );
          },
        ),
      ),
    );
  }
}
