import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/akun.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan.dart';
import 'package:ukk_2025/penjualan.dart';
import 'package:ukk_2025/produk.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://fqumyoqdelmqqludcnoq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxdW15b3FkZWxtcXFsdWRjbm9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDkzMzAsImV4cCI6MjA1NDk4NTMzMH0.laCBG5YLLeKPBQVT4CfhnzrVpKvXhzS0EAOhahbFx1k');
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Warung Warungan'),
          centerTitle: true,
          backgroundColor: Colors.green,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.store), text: 'Produk'),
              Tab(icon: Icon(Icons.point_of_sale), text: 'Penjualan'),
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Produk(),
            Penjualan(),
            Pelanggan(),
            Akun(),
          ],
        ),
      ),
    );
  }
}

