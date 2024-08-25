import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  // Modified Send a message to include userEmail
  Future<void> sendMessage(
      String userId, String message, String userEmail) async {
    try {
      await chatCollection.add({
        'userId': userId,
        'userEmail': userEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Get real-time chat messages
  Stream<QuerySnapshot> get chatStream {
    return chatCollection.orderBy('timestamp', descending: true).snapshots();
  }

  // Get messages for a specific user (for private chats)
  Stream<QuerySnapshot> messagesForUser(String userId) {
    return chatCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
