import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/insert_pelanggan.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  State<Pelanggan> createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> filteredPelanggan = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    _searchController.addListener(_filterPelanggan);
  }

  Future<void> fetchPelanggan() async {
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response ?? []);
        filteredPelanggan = List<Map<String, dynamic>>.from(pelanggan);
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> editPelanggan(Map<String, dynamic> pelangganData) async {
    final TextEditingController namaController =
        TextEditingController(text: pelangganData['NamaPelanggan']);
    final TextEditingController alamatController =
        TextEditingController(text: pelangganData['Alamat']);
    final TextEditingController nomorteleponController =
        TextEditingController(text: pelangganData['NomorTelepon']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Pelanggan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration:
                      const InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                TextField(
                  controller: nomorteleponController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedData = {
                    'NamaPelanggan': namaController.text,
                    'Alamat': alamatController.text,
                    'NomorTelepon': nomorteleponController.text,
                  };
                  await Supabase.instance.client
                      .from('pelanggan')
                      .update(updatedData)
                      .eq('PelangganID', pelangganData['PelangganID']);
                  Navigator.pop(context);
                  fetchPelanggan();
                } catch (e) {
                  print('Error updating customer: $e');
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deletePelanggan(int PelangganID) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', PelangganID);
      fetchPelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pelanggan berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting customer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus pelanggan!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterPelanggan() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredPelanggan = pelanggan
          .where((plg) => plg['NamaPelanggan'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(120, 179, 206, 1),
        body: TabBarView(
          children: [
            pelanggan.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scaffold(
                    backgroundColor: Color.fromRGBO(120, 179, 206, 1),
                    body: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari pelanggan...',
                              filled: true,
                              fillColor: Color.fromRGBO(201, 230, 240, 1),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredPelanggan.length,
                            itemBuilder: (context, index) {
                              final plg = filteredPelanggan[index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(
                                    plg['NamaPelanggan'] ??
                                        'Tidak ada pelanggan',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plg['Alamat']?.toString() ??
                                            'Tidak ada Alamat',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        plg['NomorTelepon']?.toString() ??
                                            'Tidak ada Nomor Telepon',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => editPelanggan(plg),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        'Konfirmasi Hapus'),
                                                    content: const Text(
                                                        'Apakah anda yakin ingin menghapus pelanggan ini?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child:
                                                            const Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deletePelanggan(plg[
                                                              'PelangganID']);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Hapus',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InsertPelanggan()),
                        );
                        if (result == true) {
                          fetchPelanggan();
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
