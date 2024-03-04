
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/models/notification_badge.dart';
import 'package:flutter/foundation.dart';

class FirestoreService extends ChangeNotifier {

  List<NotificationBadge> notificationBadges = [];

  final CollectionReference _todosCollection = FirebaseFirestore.instance.collection('notificationBadges');

  Stream<List<NotificationBadge>> getNotificationBadgesStream() {
    return _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationBadge(
          userId: doc.id,
          chat: data.containsKey('Chat') ? data['Chat'] : 0 ,
          citas: data.containsKey('Citas') ? data['Citas'] : 0 ,
          recetas: data.containsKey('recetas') ? data['recetas'] : 0,
          notificaciones: data.containsKey('notificaciones') ? data['notificaciones'] : 0 ,
          general: data.containsKey('General') ? data['General'] : 0 
        );
      }).toList();
    });
  }
}