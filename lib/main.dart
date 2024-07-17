import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cnbdvcutnnzdgfgtqkdm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuYmR2Y3V0bm56ZGdmZ3Rxa2RtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAzMjc5ODMsImV4cCI6MjAzNTkwMzk4M30.XjBBoEQRbfonTmR4-jeo9TCfZ-jnbMjvGLU2fb0_1SQ',
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}

// Define the simpan function
Future<void> simpan(String nim, String nama, String jurusan, String prodi,) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('mahasiswa').insert({
    'nama': nama,
    'jurusan': jurusan,
    'prodi': prodi,
    'nim' : nim,
  });

  if (response.error != null) {
    throw response.error!;
  }
}
