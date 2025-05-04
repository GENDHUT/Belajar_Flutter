import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'board.dart';
import 'piece.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fullscreen immersive & landscape
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Catur',
      debugShowCheckedModeBanner: false,
      home: const ChessGameScreen(),
    );
  }
}

class ChessGameScreen extends StatefulWidget {
  const ChessGameScreen({super.key});
  @override
  State<ChessGameScreen> createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  final List<Piece> whiteCaptured = [];
  final List<Piece> blackCaptured = [];
  // untuk rebuild ChessBoard saat restart
  int gameId = 0;

  // dipanggil Board saat ada capture non-king
  void handleCapture(Piece captured) {
    setState(() {
      if (captured.isWhite) {
        whiteCaptured.add(captured);
      } else {
        blackCaptured.add(captured);
      }
    });
  }

  // dipanggil Board saat king tertangkap
  void handleGameEnd(bool whiteWinner) {
    showDialog(
      context: context,
      barrierDismissible: false, // wajib tekan tombol
      builder: (ctx) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(whiteWinner ? 'White wins!' : 'Black wins!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // tutup dialog
              setState(() {
                // reset skor
                whiteCaptured.clear();
                blackCaptured.clear();
                // rebuild board
                gameId++;
              });
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturedList(List<Piece> list, bool isWhite) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: list
          .map((p) => Text(
                p.symbol,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: p.displayColor,
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // panel kiri: white lost
          Container(
            width: 100,
            color: Colors.grey[900],
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'White Lost',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildCapturedList(whiteCaptured, true),
              ],
            ),
          ),
          // papan catur
          Expanded(
            child: Center(
              child: ChessBoard(
                key: ValueKey(gameId),
                onCapture: handleCapture,
                onGameEnd: handleGameEnd,
              ),
            ),
          ),
          // panel kanan: black lost
          Container(
            width: 100,
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Black Lost',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildCapturedList(blackCaptured, false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
