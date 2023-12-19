import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/new_note_page.dart';
import 'package:note_app/pages/note_detail.dart';
import 'package:note_app/services/firebase_service.dart';

class NoteItemWidget extends StatefulWidget {
  final String noteID;
  final Timestamp time;

  final Note note;

  const NoteItemWidget({
    super.key,
    required this.note,
    required this.noteID,
    required this.time,
  });

  @override
  State<NoteItemWidget> createState() => _NoteItemWidgetState();
}

class _NoteItemWidgetState extends State<NoteItemWidget> {
  final FirebaseService firebaseService = FirebaseService();

  //Hàm random color
  final List<Color> colors = [
    Colors.green,
    Colors.yellow[800]!,
    Colors.deepOrange[500]!
  ];

  Color randomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDeleteDialog(context);
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoteDetail(
            note: Note(title: widget.note.title, content: widget.note.content),
            time: widget.time,
          ),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: randomColor(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title note
              Text(
                widget.note.title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                maxLines: 1,
              ),
              SizedBox(
                height: 10,
              ),

              //Content note
              Expanded(
                flex: 2,
                child: Text(
                  widget.note.content,
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                ),
              ),

              //Timestamp note
              SizedBox(
                height: 20,
              ),

              // Inside the build method of NoteItemWidget
              Expanded(
                child: Text(
                  DateFormat('dd-MM-yyyy / HH:mm:ss')
                      .format(widget.time.toDate()),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(2))),
                  onPressed: () {
                    // ignore: unnecessary_null_comparison
                    navigateUpdateNote(context);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void navigateUpdateNote(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (widget.note != null) {
      //TH đã có note trước đó:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewNotePage(
            existedNote: widget.note,
            noteID: widget.noteID,
          ),
        ),
      );
    }
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete a note"),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            // Cancel
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            // Delete
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                firebaseService.deleteNote(widget.noteID);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
