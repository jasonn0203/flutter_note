import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';

class NoteDetail extends StatelessWidget {
  final Note note;
  final Timestamp time;
  const NoteDetail({
    super.key,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(0xffc1dbd9)),
              child: Icon(
                Icons.keyboard_arrow_left,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Text(
              note.title,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32),
            ),
            //Time
            SizedBox(
              height: 12,
            ),
            Text(DateFormat('dd-MM-yyyy / HH:mm:ss').format(time.toDate()),
                style: TextStyle(color: Colors.grey)),

            SizedBox(
              height: 24,
            ),
            //Content
            Text(
              note.content,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
