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

void main() async {
  runApp(MyApp());

  // Initialize Isar
  final isar = await Isar.open([PersonSchema], directory: '');

  // Insert a random Person at startup
  final random = Random();
  final personName = 'Person ${random.nextInt(100)}';
  await isar.writeTxn(() async {
    final person = Person()..name = personName;
    await isar.persons.put(person);
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Reference to Isar instance
  final Future<Isar> _isarFuture = Isar.open([PersonSchema], directory: '');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Isar Test App')),
        body: FutureBuilder<Isar>(
          future: _isarFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final isar = snapshot.data!;
              return FutureBuilder<List<Person>>(
                future: isar.persons.where().findAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    final persons = snapshot.data!;
                    return ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(persons[index].name),
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
