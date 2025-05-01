import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi (stateless karena tidak berubah selama runtime)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter test 1 Page'),
    );
  }
}

// Stateful widget agar bisa mengubah nilai (seperti counter)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 2;

  // Fungsi untuk menambah nilai counter
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Fungsi untuk mereset counter ke 0
  void _resetCounter() {
    setState(() {
      _counter = 0;

      // Menampilkan notifikasi kecil saat reset berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Counter telah di-reset ke 0')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Warna AppBar diambil dari tema
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Anda telah menekan tombol sebanyak:'),
            Text(
              '$_counter', // Menampilkan nilai counter
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),

      // Dua tombol: tambah dan reset, diletakkan horizontal (Row)
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol increment
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Tambah',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16), // Jarak antar tombol

          // Tombol reset
          FloatingActionButton(
            onPressed: _resetCounter,
            tooltip: 'Reset',
            backgroundColor: Colors.red, // Warna merah untuk reset
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
