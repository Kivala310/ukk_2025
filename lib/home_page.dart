import 'package:flutter/material.dart';
import 'package:ukk_2025/akun.dart';
import 'package:ukk_2025/detail_penjualan.dart';
import 'package:ukk_2025/login.dart';
import 'package:ukk_2025/pelanggan.dart';
import 'package:ukk_2025/penjualan.dart';
import 'package:ukk_2025/produk.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Produk(),
    Penjualan(),
    DetailPenjualan(),
    Pelanggan(),
    Akun(),
  ];

  //untuk pergantian tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warung Warungan'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(201, 230, 240, 1),
      ),
      body: _pages[_selectedIndex], // menampilkan halaman di index

      //drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromRGBO(120, 179, 206, 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(''),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin', style: TextStyle(color: Colors.white,fontSize: 20),
                    ),
                    // Text(
                    //   'admin@gmail.com',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Produk'),
              onTap: () =>_onItemTapped(0),
            ),
             ListTile(
              leading: Icon(Icons.point_of_sale),
              title: Text('Penjualan'),
              onTap: () =>_onItemTapped(1),
            ),
             ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Detail Penjualan'),
              onTap: () =>_onItemTapped(2),
            ),
             ListTile(
              leading: Icon(Icons.people),
              title: Text('Pelanggan'),
              onTap: () =>_onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Akun'),
              onTap: () =>_onItemTapped(4),
            ),
            const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text('Logout'),
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              )
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(201, 230, 240, 1),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromRGBO(120, 179, 206, 1),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Penjualan',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Detail Penjualan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Pelanggan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
