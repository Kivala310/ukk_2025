import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertPelanggan extends StatefulWidget {
  const InsertPelanggan({super.key});

  @override
  State<InsertPelanggan> createState() => _InsertPelangganState();
}

class _InsertPelangganState extends State<InsertPelanggan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorteleponController = TextEditingController();

  //untuk menginsert data produk ke supabase
  Future<void> _addPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final namapelanggan = _namaController.text;
      final alamat = _alamatController.text;
      final nomortelepon = _nomorteleponController.text;

      //untuk validasi input
      // if (harga == null || stok == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Harga harus berupa angka desimal, stok harus berupa angka bulat')),
      //     );
      //     return;
      // }

      //insert ke supabase
      final response = await Supabase.instance.client.from('pelanggan').insert({
        'NamaPelanggan': namapelanggan,
        'Alamat' : alamat,
        'NomorTelepon': nomortelepon,
      });

      //ngecheck error response
      if (response != null){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error!.message}')),
          );
      } else {
        //menunjukkan pesan success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pelanggan berhasil ditambahkan',
           style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

          //clear form
          _namaController.clear();
          _alamatController.clear();
          _nomorteleponController.clear();

          //untuk kembali ke beranda
          Navigator.pop(context, true);
      } 
    }
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Pelanggan!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                //keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Masukkan Alamat!';
                // }
                // if (double.tryParse(value) == null){
                //   return 'Harga harus berupa angka desimal!';
                }
                return null;
                },
              ),
              TextFormField(
                controller: _nomorteleponController,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Stok!';
                  }
                  // if (int.tryParse(value)== null) {
                  //   return 'Stok harus berupa angka bulat!';
                  // }
                  return null;
                },
              ),

              SizedBox(
                height: 20,
              ),

              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate()){
                  _addPelanggan();
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Tambah Pelanggan'),
              ),
            ],
          )
        ),
        ),
    );
  }
}