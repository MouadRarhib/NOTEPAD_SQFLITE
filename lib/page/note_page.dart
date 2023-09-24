// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tekartik_notepad_sqflite_app/main.dart';
import 'package:tekartik_notepad_sqflite_app/model/model.dart';
import 'package:tekartik_notepad_sqflite_app/page/edit_page.dart';
import 'package:tekartik_notepad_sqflite_app/page/map.dart';

class NotePage extends StatefulWidget {
  final int? noteId;

  const NotePage({Key? key, required this.noteId}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DbNote?>(
      stream: noteProvider.onNote(widget.noteId),
      builder: (context, snapshot) {
        var note = snapshot.data;

        void edit() {
          if (note != null) {
            Navigator.of(context)
                .push<void>(MaterialPageRoute(builder: (context) {
              return EditNotePage(
                initialNote: note,
              );
            }));
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Note'),
            actions: <Widget>[
              if (note != null)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    edit();
                  },
                ),
            ],
          ),
          body: (note == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () {
                    edit();
                  },
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          note.nom.v!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(title: Text(note.prenom.v ?? '')),
                      ListTile(title: Text(note.adresse.v ?? '')),
                      ListTile(title: Text(note.numero.v ?? '')),
                      Container(
                        height: 500,
                        width: 400,
                        child: MapCart(), // Intégrer la carte ici
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
