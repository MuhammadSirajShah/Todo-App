import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/toto_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addTodo(String title,DateTime? dueDate) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .add({
      "title" : title,
      "isDone" : false,
      "isFavorite": false,
      "createdAt" : Timestamp.now(),
      //FieldValue.serverTimestamp(),
      "dueDate" : dueDate == null ? null : Timestamp.fromDate(dueDate),
    });
  }

  Future<void> deleteTodo(String docId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(docId)
        .delete();
  }


  Future<void> toggleTodo(String docId, bool currentValue,)async{
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .doc(docId)
        .update({
      "isDone" : !currentValue,
    });
  }

  Future<void> editTodo(String docId, String title) async{
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .doc(docId)
        .update({
      "title" : title,
    });
  }


  Stream<QuerySnapshot> getTodos() {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> restoreTodo(TodoModel todo) async{
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .add(todo.toJson());
  }

  Future<void> toggleFavorite(String docId, bool currentValue) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("todos")
        .doc(docId)
        .update({"isFavorite" : !currentValue});
  }
}