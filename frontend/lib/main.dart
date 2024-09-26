import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/screens/error_screen.dart';
import 'package:petfight/screens/info_screen.dart';
import 'package:petfight/screens/shop_screen.dart';
import 'package:provider/provider.dart';
import 'package:petfight/models/user.dart';
import 'package:petfight/screens/friends_screen.dart';
import 'package:petfight/screens/home_screen.dart';
import 'package:petfight/screens/tasks_screen.dart';
import 'package:petfight/widgets/custom_background.dart';
import 'package:petfight/widgets/custom_app_bar.dart';
import 'package:petfight/widgets/custom_bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;

import 'package:telegram_web_app/telegram_web_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    try {
      if (TelegramWebApp.instance.isSupported) {
        await TelegramWebApp.instance.ready();
        Future.delayed(const Duration(milliseconds: 500), TelegramWebApp.instance.expand);
      }
    } catch (e) {
      print("Error happened in App while loading Telegram $e");
      await Future.delayed(const Duration(milliseconds: 200));
      main();
      return;
    }

    var response = await http.post(
      Uri.parse(Endpoints.auth),
      body: jsonEncode({
        'init_data': TelegramWebApp.instance.initData.raw
      }),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      Map<String, dynamic> dataJson = jsonDecode(response.body);
      
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => User.fromJson(dataJson),
            ),
            ChangeNotifierProvider(create: (_) => NavigationProvider()),
            ChangeNotifierProvider(create: (_) => InfoProvider()),
          ],
          child: const MyApp(),
        ),
      );
    } else {
      print('Failed login');
      runApp(
        MaterialApp(
          title: 'PetFight App',
          home: const ErrorScreen(message: "Failed login"), // Показываем экран с ошибкой
        ),
      );
    }
  } catch (error) {
    print('Error: $error');
    runApp(
      const MaterialApp(
        title: 'PetFight App',
        home: ErrorScreen(message: "Failed login"), // Показываем экран с ошибкой
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetFight App',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainWindow(screen: HomeScreen()),
        '/shop': (context) => const MainWindow(screen: ShopScreen()),
        '/task': (context) => const MainWindow(screen: TaskScreen()),
        '/friends': (context) => const MainWindow(screen: FriendsScreen()),
      },
    );
  }
}

class MainWindow extends StatelessWidget {
  final Widget screen;

  const MainWindow({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    InfoProvider loadingProvider = Provider.of<InfoProvider>(context);
    if (loadingProvider.isView) { return const InfoScreen();}
    else{
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          CustomBackground(screen: screen),
          
        ]
      ),
      
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }}
}
