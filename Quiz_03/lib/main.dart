import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/submission_list_screen.dart';

// IMPORTANT: Replace with your actual Supabase credentials
const String supabaseUrl = 'https://guirvckirqrdbdaecoyv.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd1aXJ2Y2tpcnFyZGJkYWVjb3l2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgyODI2NTUsImV4cCI6MjA5Mzg1ODY1NX0.Hd4qTe-guW9lxC1WbehmC7UMyMHbiHQCSbD_JuKgMus';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  runApp(const Quiz3App());
}

class Quiz3App extends StatelessWidget {
  const Quiz3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz 3 Submission Form',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
          surface: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
          surface: const Color(0xFF1E293B),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const SubmissionListScreen(),
    );
  }
}
