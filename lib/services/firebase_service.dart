import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/note.dart';
//Class để gọi các phương thức CRUD với firebase

class FirebaseService {
  //Gọi doc tên là notes (Đã tạo  trong firebase) để lưu các note
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection("notes");

  //CREATE
  Future<void> addNote(Note note) async {
    //Tạo một đối tượng Firestore
    await notesCollection.add({
      'title': note.title,
      'content': note.content,
      'createAt': Timestamp.now()
    });
  }

  //READ == GET
  Stream<QuerySnapshot> getNotes() {
    return notesCollection.orderBy('createAt', descending: true).snapshots();
  }

  //UPDATE
  //Lấy ra note id  và đối tượng note mới sẽ cập nhật
  Future<void> updateNote(String? noteID, Note? newNote) async {
    await notesCollection.doc(noteID).update({
      'title': newNote?.title,
      'content': newNote?.content,
      'createAt': Timestamp.now()
    });
  }

  //DELETE
  //lấy ra note id
  Future<void> deleteNote(String noteID) async {
    await notesCollection.doc(noteID).delete();
  }
}
