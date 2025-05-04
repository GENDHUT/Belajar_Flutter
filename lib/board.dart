import 'package:flutter/material.dart';
import 'piece.dart';

class ChessBoard extends StatefulWidget {
  final void Function(Piece)? onCapture;
  final void Function(bool whiteWinner)? onGameEnd;

  const ChessBoard({
    super.key,
    this.onCapture,
    this.onGameEnd,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  static const int boardSize = 8;
  late List<Piece?> pieces;
  int? selectedIndex;
  List<int> validMoves = [];
  bool isWhiteTurn = true;

  @override
  void initState() {
    super.initState();
    pieces = List<Piece?>.filled(boardSize * boardSize, null);
    _setupInitialBoard();
  }

  void _setupInitialBoard() {
    // pion
    for (int i = 8; i < 16; i++) {
      pieces[i] = const Piece(type: PieceType.pawn, isWhite: false);
      pieces[48 + (i - 8)] =
          const Piece(type: PieceType.pawn, isWhite: true);
    }
    // baris utama
    final order = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];
    for (int i = 0; i < 8; i++) {
      pieces[i] = Piece(type: order[i], isWhite: false);
      pieces[56 + i] = Piece(type: order[i], isWhite: true);
    }
  }

  bool _inBounds(int x) => x >= 0 && x < 64;
  int _row(int x) => x ~/ boardSize;
  int _col(int x) => x % boardSize;
  bool _isEnemy(int x, bool white) =>
      _inBounds(x) && pieces[x] != null && pieces[x]!.isWhite != white;
  bool _isEmpty(int x) => _inBounds(x) && pieces[x] == null;

  List<int> _calculateValidMoves(int from) {
    final p = pieces[from];
    if (p == null) return [];
    final List<int> m = [];
    final r = _row(from);

    switch (p.type) {
      case PieceType.pawn:
        final dir = p.isWhite ? -1 : 1;
        final fwd = from + dir * 8;
        if (_isEmpty(fwd)) m.add(fwd);
        final start = p.isWhite ? 6 : 1;
        if (r == start &&
            _isEmpty(fwd) &&
            _isEmpty(from + dir * 16)) {
          m.add(from + dir * 16);
        }
        for (int dc in [-1, 1]) {
          final diag = fwd + dc;
          if (_isEnemy(diag, p.isWhite)) m.add(diag);
        }
        break;
      case PieceType.rook:
        m.addAll(_slideMoves(from, [8, -8, 1, -1]));
        break;
      case PieceType.bishop:
        m.addAll(_slideMoves(from, [9, -9, 7, -7]));
        break;
      case PieceType.queen:
        m.addAll(_slideMoves(
            from, [8, -8, 1, -1, 9, -9, 7, -7]));
        break;
      case PieceType.knight:
        for (int d in [-17, -15, -10, -6, 6, 10, 15, 17]) {
          final to = from + d;
          if (_inBounds(to) &&
              (_isEmpty(to) || _isEnemy(to, p.isWhite)) &&
              (_row(from) - _row(to)).abs() <= 2 &&
              (_col(from) - _col(to)).abs() <= 2) {
            m.add(to);
          }
        }
        break;
      case PieceType.king:
        for (int d in [-9, -8, -7, -1, 1, 7, 8, 9]) {
          final to = from + d;
          if (_inBounds(to) &&
              (_isEmpty(to) || _isEnemy(to, p.isWhite)) &&
              (_row(from) - _row(to)).abs() <= 1 &&
              (_col(from) - _col(to)).abs() <= 1) {
            m.add(to);
          }
        }
        break;
    }
    return m;
  }

  List<int> _slideMoves(int from, List<int> dirs) {
    final p = pieces[from];
    if (p == null) return [];
    final List<int> m = [];
    for (int dir in dirs) {
      int to = from + dir;
      while (_inBounds(to) &&
          (_row(to) - _row(to - dir)).abs() <= 1 &&
          (_col(to) - _col(to - dir)).abs() <= 1) {
        if (_isEmpty(to)) {
          m.add(to);
        } else if (_isEnemy(to, p.isWhite)) {
          m.add(to);
          break;
        } else {
          break;
        }
        to += dir;
      }
    }
    return m;
  }

  void _handleTap(int idx) {
    setState(() {
      final tapped = pieces[idx];
      if (selectedIndex == null) {
        if (tapped != null && tapped.isWhite == isWhiteTurn) {
          selectedIndex = idx;
          validMoves = _calculateValidMoves(idx);
        }
      } else {
        if (validMoves.contains(idx)) {
          // kalau ada bidak tertangkap
          final Piece? cap = pieces[idx];
          if (cap != null) {
            // kalau yang tertangkap adalah Raja → game end
            if (cap.type == PieceType.king) {
              widget.onGameEnd?.call(!cap.isWhite);
            } else {
              widget.onCapture?.call(cap);
            }
          }
          // pindahkan bidak
          pieces[idx] = pieces[selectedIndex!];
          pieces[selectedIndex!] = null;
          isWhiteTurn = !isWhiteTurn;
        }
        selectedIndex = null;
        validMoves.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: boardSize * boardSize,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardSize,
        ),
        itemBuilder: (ctx, idx) {
          final r = _row(idx), c = _col(idx);
          final isLight = (r + c) % 2 == 0;
          final p = pieces[idx];
          final sel = selectedIndex == idx;
          final ok = validMoves.contains(idx);

          Color bg =
              isLight ? Colors.brown[300]! : Colors.brown[700]!;
          if (sel) bg = const Color.fromARGB(76, 255, 59, 222);
          else if (ok) bg = Colors.green;

          return GestureDetector(
            onTap: () => _handleTap(idx),
            child: Container(
              color: bg,
              child: Center(
                child: Text(
                  p?.symbol ?? '',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: p?.displayColor ?? Colors.transparent,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
