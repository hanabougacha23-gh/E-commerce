import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Demander la permission (surtout pour iOS et Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // 2. Récupérer le token (Utile pour envoyer une notification à CE téléphone précis)
      String? token = await _fcm.getToken();
      print("Firebase Messaging Token: $token");

      // 3. Configurer les notifications locales pour quand l'app est ouverte (foreground)
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _localNotifications.initialize(initializationSettings);

      // 4. Écouter les messages quand l'app est ouverte
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });
    }
  }

  // Permet d'afficher une notification immédiatement
  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'order_status_channel',
      'Order Status',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, notificationDetails);
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'order_status_channel',
      'Order Status',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    _localNotifications.show(
      0,
      message.notification?.title ?? 'Order Update',
      message.notification?.body ?? 'Your order status has changed.',
      notificationDetails,
    );
  }
}
