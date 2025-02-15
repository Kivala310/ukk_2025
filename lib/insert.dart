import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  //untuk menginsert data produk ke supabase
  Future<void> _addProduk() async {
    if (_formKey.currentState!.validate()) {
      final namaproduk = _namaController.text;
      final harga = double.tryParse(_hargaController.text);
      final stok = int.tryParse(_stokController.text);

      //untuk validasi input
      if (harga == null || stok == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harga harus berupa angka desimal, stok harus berupa angka bulat')),
          );
          return;
      }

      //insert ke supabase
      final response = await Supabase.instance.client.from('produk').insert({
        'NamaProduk': namaproduk,
        'Harga' : harga,
        'Stok': stok,
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
            content: Text('Produk berhasil ditambahkan',
           style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

          //clear form
          _namaController.clear();
          _hargaController.clear();
          _stokController.clear();

          //untuk kembali ke beranda
          Navigator.pop(context, true);
      } 
    }
  }










  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Produk!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Masukkan Harga!';
                }
                if (double.tryParse(value) == null){
                  return 'Harga harus berupa angka desimal!';
                }
                return null;
                },
              ),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(labelText: 'stok'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Stok!';
                  }
                  if (int.tryParse(value)== null) {
                    return 'Stok harus berupa angka bulat!';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 20,
              ),

              ElevatedButton(onPressed: (){
                if (_formKey.currentState!.validate()){
                  _addProduk();
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
              child: Text('Tambah Produk'),
              ),
            ],
          )
        ),
        ),
    );
  }
}