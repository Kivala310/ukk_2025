import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/insert.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  List<Map<String, dynamic>> produk = [];

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> editProduk(Map<String, dynamic> produkData) async {
    final TextEditingController namaController =
    TextEditingController(text: produkData['NamaProduk']);
     final TextEditingController hargaController =
    TextEditingController(text: produkData['Harga'].toString());
     final TextEditingController stokController =
    TextEditingController(text: produkData['Stok'].toString());

    await showDialog(
     context: context,
     builder: (context) {
      return AlertDialog(
        title: const Text('Edit Produk'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stokController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
           child: const Text('Batal')
           ),
           ElevatedButton(
            onPressed: () async {
              try {
                final updatedData = {
                  'NamaProduk': namaController.text,
                  'Harga': int.parse(hargaController.text),
                  'Stok': int.parse(stokController.text),
                };
                await Supabase.instance.client
                .from('produk')
                .update(updatedData)
                .eq('ProdukID', produkData['ProdukID']);
                Navigator.pop(context);
                fetchProduk();
              } catch (e) {
                print('Error updating product: $e');
                
              }
            },
            child: const Text('Simpan'),
            ),
        ],
      );
    },
    );
  }





  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.green,
        body: TabBarView(
          children: [
            produk.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
              backgroundColor: Colors.green.shade200,
              body: ListView.builder(
                itemCount: produk.length,
                itemBuilder:(context, index) {
                  final prd = produk[index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        prd['NamaProduk'] ?? 'Tidak ada produk',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prd['Harga']?.toString() ?? 'Tidak ada harga',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 14),
                            ),
                            Text(
                              prd['Stok']?.toString() ?? 'Tidak ada harga',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 14),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         IconButton(
                          icon: const Icon(Icons.edit,
                          color: Colors.blue),
                          onPressed: () =>    (prd),
                         ),
                         IconButton(
                          icon: const Icon(Icons.delete,
                          color: Colors.red),
                          onPressed: (){
                          },
                         ),
                        ],
                      ),
                    ),
                  );
                },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed:() async {
                    final result = await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Insert()),
                      );
                      if (result == true){
                        fetchProduk();
                      }
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                  ),
            ),
          ],
          ),
      ),
    );
  }
}