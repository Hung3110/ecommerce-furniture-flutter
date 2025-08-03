import 'package:furniture_app_project/provider/filter_provider.dart';
import 'package:furniture_app_project/screens/home.dart';
import 'package:furniture_app_project/screens/review_product.dart';
import 'package:furniture_app_project/screens/welcome.dart';
import 'provider/banner_provider.dart';
import 'provider/category_provider.dart';
import 'provider/country_city_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'provider/user_provider.dart';
import 'services/DatabaseHandler.dart';
import 'services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

//  Hàm xử lý khi nhận thông báo ở chế độ background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // <-- 2. Thêm khối lệnh này để kích hoạt App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );

    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );
    print('Firebase initialized successfully');
    //  Đăng ký background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //  Khởi tạo NotificationService
    await NotificationService().initNotifications();


  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  DatabaseHandler handler = DatabaseHandler();
  await handler.initializeDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<BannerProvider>(
          create: (context) => BannerProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<CountryCityProvider>(
          create: (context) => CountryCityProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<FilterProvider>(
          create: (context) => FilterProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Furniture App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xfff2f9fe),
          textTheme:
          GoogleFonts.dmSansTextTheme().apply(displayColor: Colors.black),
          primaryColor: const Color(0xff410000),
          iconTheme: const IconThemeData(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const Welcom(),
      ),
    );
  }
}
