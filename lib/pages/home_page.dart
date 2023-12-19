import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/new_note_page.dart';
import 'package:note_app/services/firebase_service.dart';
import 'package:note_app/widgets/note_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ds các note
  late List<DocumentSnapshot> notes;
  final firebaseService = FirebaseService();
  @override
  initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "NOTE",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          leadingWidth: 75,
          actions: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note List",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4),
              ),
              SizedBox(
                height: 10,
              ),
              RefreshIndicator(
                onRefresh: _refreshNotes,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firebaseService.getNotes(),
                  builder: (context, snapshot) {
                    //TH lỗi
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    //loading khi lấy dữ liệu
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //kh có note nào
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No notes yet!",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    }
                    //Có note
                    notes = snapshot.data!.docs;

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (_, index) => NoteItemWidget(
                          note: Note(
                            title: notes[index]['title'],
                            content: notes[index]['content'],
                          ),
                          noteID: notes[index].id,
                          time: notes[index]['createAt']),
                      itemCount: notes.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        //add note btn
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NewNotePage(),
              ),
            );
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ));
  }

  //Refresh note list
  Future<void> _refreshNotes() async {
    var updatedNotes = await firebaseService.getNotes();
    setState(() {
      notes = updatedNotes as List<DocumentSnapshot<Object?>>;
    });
  }
}
