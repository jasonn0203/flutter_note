import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/services/firebase_service.dart';

class NewNotePage extends StatefulWidget {
  final Note? existedNote;
  final String? noteID;

  const NewNotePage({super.key, this.existedNote, this.noteID});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existedNote != null) {
      _titleController.text = widget.existedNote!.title;
      _contentController.text = widget.existedNote!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          child: Row(
            children: [Icon(Icons.keyboard_double_arrow_left), Text("Back")],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your title here"),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your note here",
                  ),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: 9999,
                  autofocus: true,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      //update đối tượng note đã có
                      if (widget.existedNote != null) {
                        Note updateNote = Note(
                            title: _titleController.text,
                            content: _contentController.text);
                        firebaseService.updateNote(widget.noteID, updateNote);
                      } else {
                        //tạo đối tượng note
                        Note newNote = Note(
                            title: _titleController.text,
                            content: _contentController.text);
                        firebaseService.addNote(newNote);
                      }
                      //Về homepage
                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
