import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: FutureBuilder<List<Note>>(
            future: fetchNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final notes = snapshot.data!;
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.text),
                      trailing: Checkbox(
                        value: note.isCompleted,
                        onChanged: (value) {},
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Text('Failed to fetch notes');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}

class Note {
  final String text;
  final bool isCompleted;

  Note({required this.text, required this.isCompleted});
}

Future<List<Note>> fetchNotes() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((noteData) {
      final text = noteData['title'] as String;
      final isCompleted = noteData['completed'] as bool;
      return Note(text: text, isCompleted: isCompleted);
    }).toList();
  } else {
    throw Exception('Failed to fetch notes');
  }
}
