import 'package:flutter/material.dart';
import 'iphone.dart';
import 'kamera.dart';

// PILAR: ABSTRACTION
// melainkan barang spesifik (iPhone/Kamera).
abstract class Produk {
  String nama;
  int harga;

  Produk(this.nama, this.harga);

  // PILAR: POLYMORPHISM (Getter)
  // Menentukan ikon secara dinamis berdasarkan tipe objek saat runtime.
  IconData get ikon {
    if (this is Iphone) return Icons.phone_iphone;
    if (this is Kamera) return Icons.camera_alt;
    return Icons.inventory_2;
  }

  get tipe => null;
}
//komentar buat ngubah deskripsi doang