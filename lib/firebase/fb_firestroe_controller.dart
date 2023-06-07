import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp18_firebase/firebase/fb_helper.dart';
import 'package:vp18_firebase/models/note.dart';
import 'package:vp18_firebase/models/process_response.dart';

class FbFireStoreController with FbHelper {
  FbFireStoreController._();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static FbFireStoreController? _instance;

  factory FbFireStoreController() {
    return _instance ??= FbFireStoreController._();
  }

  /// * Operations : CRUD
  ///    1) Create => C
  ///    2) Read   => R
  ///    3) Update => U
  ///    4) Delete => D

  /// * FireStore :
  ///    1) NoSQL DataBase :
  ///       - Has No Tables & Rows.
  ///       - Table Replace By Collection.
  ///       - Row Replace By Document.

  Future<ProcessResponse> create(Note note) async {
    return _fireStore
        .collection("Notes")
        .add(note.toMap())
        .then((value) => getResponse("Operation Completed.."))
        .catchError((error) => getResponse("Operation failed!", false));
  }

  Stream<QuerySnapshot<Note>> read() async* {
    yield* _fireStore
        .collection("Notes")
        .withConverter<Note>(
          fromFirestore: (snapshot, options) => Note.fromJson(snapshot.data()!),
          toFirestore: (Note note, options) => note.toMap(),
        )
        .snapshots();
  }

  Future<ProcessResponse> update(Note note) async {
    return _fireStore
        .collection("Notes")
        .doc(note.id)
        .update(note.toMap())
        .then((value) => getResponse("Operation Completed.. "))
        .catchError((error) => getResponse("Operation failed!"));
  }

  Future<ProcessResponse> delete(String id) async {
    return _fireStore
        .collection("Notes")
        .doc(id)
        .delete()
        .then((value) => getResponse("Operation Completed.. "))
        .catchError((error) => getResponse("Operation failed!"));
  }
}
