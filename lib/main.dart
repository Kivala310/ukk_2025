import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/login.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://fqumyoqdelmqqludcnoq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxdW15b3FkZWxtcXFsdWRjbm9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDkzMzAsImV4cCI6MjA1NDk4NTMzMH0.laCBG5YLLeKPBQVT4CfhnzrVpKvXhzS0EAOhahbFx1k',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
