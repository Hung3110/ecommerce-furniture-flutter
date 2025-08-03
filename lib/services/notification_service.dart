import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Xử lý logic khi nhận được thông báo ở chế độ nền
  // Ví dụ: lưu thông tin vào storage, cập nhật dữ liệu,...
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // 1. Yêu cầu quyền nhận thông báo
    await _fcm.requestPermission();

    // 2. Lấy FCM token
    final fcmToken = await _fcm.getToken();
    print("FCM Token: $fcmToken");

    // 3. Khởi tạo thông báo cục bộ
    await _initLocalNotifications();

    // 4. Lắng nghe thông báo khi ứng dụng đang mở (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Hiển thị thông báo cục bộ khi app đang mở
        _showLocalNotification(message);
      }
    });

    // 5. Xử lý khi người dùng nhấn vào thông báo (app từ trạng thái background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Điều hướng đến màn hình cụ thể
      // navigatorKey.currentState!.pushNamed('/notification_screen', arguments: message.data);
    });

    // 6. Xử lý khi người dùng nhấn vào thông báo (app từ trạng thái terminated)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // Điều hướng đến màn hình cụ thể
      }
    });

    // 7. Đăng ký hàm xử lý thông báo nền
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _initLocalNotifications() async {
    // Cài đặt cho Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');

    // Cài đặt cho iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(initializationSettings);
  }

  void _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Tạo channel cho Android (quan trọng để thông báo hiển thị)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Hiển thị thông báo
    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
      );
    }
  }
}