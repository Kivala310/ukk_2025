// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class DetailPenjualan extends StatefulWidget {
//   const DetailPenjualan({super.key});

//   @override
//   State<DetailPenjualan> createState() => _DetailPenjualanState();
// }

// class _DetailPenjualanState extends State<DetailPenjualan> {
//   List<Map<String, dynamic>> DetailPenjualan = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchDetailPenjualan();
//   }

//   Future<void> fetchDetailPenjualan() async {
//     try {
//       final response = await Supabase.instance.client.from('detailpenjualan').select();
//       setState(() {
//         DetailPenjualan = List<Map<String, dynamic>>.from(response ??[]);
//       });
//     } catch (e) {
//       print('Error fetching detail penjualan: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Penjualan'),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: DetailPenjualan.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         :ListView.builder(
//           itemCount: DetailPenjualan.length,
//           itemBuilder: (context, index) {
//             final transaksi = DetailPenjualan[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8.0),
//               child: ListTile(
//                 title: Text('Penjualan ID: ${transaksi['PenjualanID']}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Produk ID: ${transaksi['ProdukID']}'),
//                     Text('Jumlah Produk: ${transaksi['JumlahProduk']}'),
//                     Text('Subtotal: Rp ${transaksi['ProdukID'].toStringAsFixed(2)}'),
//                   ],
//                 ),
//                 ),
//             );
//           },
//         )
//         ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualan extends StatefulWidget {
  const DetailPenjualan({super.key});

  @override
  State<DetailPenjualan> createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  List<Map<String, dynamic>> detailPenjualan = [];

  @override
  void initState(){
    super.initState();
    fetchDetailPenjualan();
  }

  //untuk mengambil data detail penjualan dari supabase
  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await Supabase.instance.client
      .from('detailpenjualan')
      .select('DetailID, PenjualanID, ProdukID, JumlahProduk, Subtotal(NamaProduk), penjualan(PelangganID)')
      .order('PenjualanID', ascending: false);

      if (response == null) {
        setState(() {
          detailPenjualan = List<Map<String, dynamic>>.from(response ??[]);
        });
      } else {
        print('Error fetching detail penjualan: ${response}');
      }
    } catch (e) {
      print('Error fetching detail penjualan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Pembelian'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color.fromRGBO(120, 179, 206, 1),
      body: detailPenjualan.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: detailPenjualan.length,
            itemBuilder: (context, index) {
              final detail = detailPenjualan[index];
              final produk = detail['produk'] ?? {};
              final pelangganID = detail['penjualan']['PelangganID'] ?? 'Unknown';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text('Penjualan ID: ${detail['PenjualanID']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Produk: ${produk['NamaProduk'] ?? 'Tanpa Nama Produk' }'),
                      Text('Pelanggan ID: $pelangganID'),
                      Text('Jumlah Produk: ${detail['JumlahProduk']}'),
                      Text('Subtotal: Rp ${detail['Subtotal'].toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              );
            }
            ),
          )
    );
  }
}