import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/canvas_screen.dart';
import 'utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const BotFlowApp());
}

class BotFlowApp extends StatelessWidget {
  const BotFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bot Flow Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        brightness: Brightness.dark,
        fontFamily: 'SF Pro Display',
      ),
      home: const CanvasScreen(),
    );
  }
}
