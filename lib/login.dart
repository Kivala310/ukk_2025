import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;


  //fungsi _login buat verifikasi username dan password di supabase
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await supabase
          .from('user')
          .select('username, password')
          .eq('username', username)
          .maybeSingle();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username tidak ditemukan!',style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (response['password'] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!',style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password salah!',style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Color.fromRGBO(120, 179, 206, 1),
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color.fromRGBO(201, 230, 240, 1),
        //titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //Image.asset('assets/login2.png'),

          Text(
            'Login',
            style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 20,
          ),
          
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Username',
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
           validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tolong masukkan username';
                  }
                  return null;
            },
            ),
      
      

            SizedBox(
            height: 20,
          ),

            TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
               prefixIcon: Icon(
                Icons.password,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              )
            ),
            onChanged: (String value) {},
            validator: (value) {
              return value!.isEmpty ? 'Tolong masukkan password' : null;
            },
            ),

            SizedBox(
              height: 20
              ),

              ElevatedButton(onPressed: _login,
               child:Text('Login')),

          //   ElevatedButton(
          //     onPressed: (){
          //     Navigator.push(
          //       context,
          //     MaterialPageRoute(builder: (context)=> const Beranda()),
          //     );
          //   },
          //    child: Text('Login')
          // ),
        ],
      ),
      );
  }
}