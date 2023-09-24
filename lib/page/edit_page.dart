// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sqflite_app/main.dart';
import 'package:tekartik_notepad_sqflite_app/model/model.dart';

class EditNotePage extends StatefulWidget {
  /// null when adding a note
  final DbNote? initialNote;

  const EditNotePage({Key? key, required this.initialNote}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _numeroTextController;
  TextEditingController? _nomTextController;
  TextEditingController? _prenomTextController;
  TextEditingController? _adresseTextController;

  int? get _noteId => widget.initialNote?.id.v;
  @override
  void initState() {
    super.initState();
    _numeroTextController =
        TextEditingController(text: widget.initialNote?.numero.v);
    _nomTextController = TextEditingController(text: widget.initialNote?.nom.v);
    _prenomTextController =
        TextEditingController(text: widget.initialNote?.prenom.v);
    _adresseTextController =
        TextEditingController(text: widget.initialNote?.adresse.v);
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await noteProvider.saveNote(DbNote()
        ..id.v = _noteId
        ..numero.v = _numeroTextController!.text
        ..nom.v = _nomTextController!.text
        ..prenom.v = _prenomTextController!.text
        ..adresse.v = _adresseTextController!.text
        ..date.v = DateTime.now().millisecondsSinceEpoch);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Pop twice when editing
      if (_noteId != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var dirty = false;
        if (_numeroTextController!.text != widget.initialNote?.numero.v) {
          dirty = true;
        } else if (_adresseTextController!.text !=
            widget.initialNote?.adresse.v) {
          dirty = true;
        }
        if (dirty) {
          return await (showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Discard change?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Content has changed.'),
                            SizedBox(
                              height: 12,
                            ),
                            Text('Tap \'CONTINUE\' to discard your changes.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('CONTINUE'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('CANCEL'),
                        ),
                      ],
                    );
                  })) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Note',
          ),
          actions: <Widget>[
            if (_noteId != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  if (await showDialog<bool>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete note?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Tap \'YES\' to confirm note deletion.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('NO'),
                                ),
                              ],
                            );
                          }) ??
                      false) {
                    await noteProvider.deleteNote(widget.initialNote!.id.v);
                    // Pop twice to go back to the list
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
              ),
            // action button
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                save();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                        controller: _nomTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Nom must not be empty',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Prenom',
                          border: OutlineInputBorder(),
                        ),
                        controller: _prenomTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Prenom must not be empty',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Adresse',
                          border: OutlineInputBorder(),
                        ),
                        controller: _adresseTextController,
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Adresse must not be empty',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Numero',
                          border: OutlineInputBorder(),
                        ),
                        controller: _numeroTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Numero must not be empty',
                      ),
                    ]))
          ]),
        ),
      ),
    );
  }
}
