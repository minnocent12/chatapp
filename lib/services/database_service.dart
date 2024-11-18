// chatapp/lib/services/database_service.dart
import 'package:chatapp/models/message_board_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveUserDetails(
      String uid, Map<String, dynamic> userDetails) async {
    await _firestore.collection('users').doc(uid).set(userDetails);
  }

  static Future<Map<String, dynamic>> getCurrentUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  static Future<void> updateUserProfile(
      Map<String, dynamic> updatedDetails) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(uid).update(updatedDetails);
  }

  // Fetch all message boards
  static Future<List<MessageBoardModel>> getMessageBoards() async {
    final snapshot = await _firestore.collection('messageBoards').get();
    return snapshot.docs
        .map((doc) => MessageBoardModel.fromMap(doc.data()))
        .toList();
  }

  // Fetch messages for a specific board (real-time)
  static Stream<List<MessageModel>> getMessages(String boardId) {
    return _firestore
        .collection('messageBoards')
        .doc(boardId)
        .collection('messages')
        .orderBy('datetime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Send a message
  static Future<void> sendMessage({
    required String boardId,
    required String text,
    required String username,
  }) async {
    final message = {
      'text': text,
      'username': username,
      'datetime': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('messageBoards')
        .doc(boardId)
        .collection('messages')
        .add(message);
  }

  // Create default message boards (if not exist)
  static Future<void> createDefaultMessageBoards() async {
    // List of predefined message boards
    List<MessageBoardModel> boards = [
      MessageBoardModel(
        id: 'games',
        name: 'Games',
        icon: 'lib/assets/images/games_icon.png',
      ),
      MessageBoardModel(
        id: 'business',
        name: 'Business',
        icon: 'lib/assets/images/business_icon.png',
      ),
      MessageBoardModel(
        id: 'study',
        name: 'Study',
        icon: 'lib/assets/images/study_icon.png',
      ),
      MessageBoardModel(
        id: 'public_health',
        name: 'Public Health',
        icon: 'lib/assets/images/public_health_icon.png',
      ),
      MessageBoardModel(
        id: 'picnic',
        name: 'Picnic',
        icon: 'lib/assets/images/picnic_icon.png',
      ),
    ];

    // Check if message boards already exist to avoid duplicates
    for (var board in boards) {
      final boardRef = _firestore.collection('messageBoards').doc(board.id);
      final docSnapshot = await boardRef.get();
      if (!docSnapshot.exists) {
        await boardRef.set(board.toMap()); // Only add if doesn't exist
      }
    }
  }
}
