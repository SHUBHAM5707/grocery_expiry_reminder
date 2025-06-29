import 'package:flutter/material.dart';
import 'package:grocery_expiry_reminder/model/grocery_item.dart';
import 'package:grocery_expiry_reminder/screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GroceryItemAdapter());
  await Hive.openBox<GroceryItem>('groceryBox');

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _isDarkMode = value);
    prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Expiry Reminder',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

