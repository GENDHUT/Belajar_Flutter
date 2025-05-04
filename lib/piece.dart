import 'package:flutter/material.dart';

/// Semua tipe bidak catur.
enum PieceType {
  /// Pion
  pawn,

  /// Benteng
  rook,

  /// Kuda
  knight,

  /// Gajah
  bishop,

  /// Ratu
  queen,

  /// Raja
  king,
}

/// Extension pada [PieceType] untuk mendapatkan simbol Unicode
/// dan (opsional) nama yang lebih “manusiawi”.
extension PieceTypeExtension on PieceType {
  /// Simbol Unicode untuk bidak ini,
  /// bergantung pada warna [isWhite].
  String symbol(bool isWhite) {
    switch (this) {
      case PieceType.king:
        return isWhite ? '♔' : '♚';
      case PieceType.queen:
        return isWhite ? '♕' : '♛';
      case PieceType.rook:
        return isWhite ? '♖' : '♜';
      case PieceType.bishop:
        return isWhite ? '♗' : '♝';
      case PieceType.knight:
        return isWhite ? '♘' : '♞';
      case PieceType.pawn:
        return isWhite ? '♙' : '♟';
    }
  }

  /// Nama bidak yang lebih “readable”.
  String get displayName {
    switch (this) {
      case PieceType.king:
        return 'King';
      case PieceType.queen:
        return 'Queen';
      case PieceType.rook:
        return 'Rook';
      case PieceType.bishop:
        return 'Bishop';
      case PieceType.knight:
        return 'Knight';
      case PieceType.pawn:
        return 'Pawn';
    }
  }
}

/// Representasi sebuah bidak catur immutable.
class Piece {
  /// Jenis bidak (pawn, rook, dst).
  final PieceType type;

  /// `true` jika bidak milik White, `false` untuk Black.
  final bool isWhite;

  /// Buat [Piece] konstan dengan [type] dan [isWhite].
  const Piece({
    required this.type,
    required this.isWhite,
  });

  /// Simbol Unicode bidak ini (♔♕…♟) sesuai warna.
  String get symbol => type.symbol(isWhite);

  /// Warna teks bidak untuk ditampilkan di UI.
  Color get displayColor => isWhite ? Colors.white : Colors.black;

  @override
  String toString() => '${type.displayName}(${isWhite ? "White" : "Black"})';
}
