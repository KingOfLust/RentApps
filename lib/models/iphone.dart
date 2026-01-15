import 'produk.dart';

// PILAR: INHERITANCE
// Iphone mewarisi atribut 'nama' dan 'harga' dari class Produk.
class Iphone extends Produk {
  String warna;
  String storage;
  String ram;

  Iphone(super.nama, super.harga, this.warna, this.storage, this.ram, {required id}); // Mengirim data ke constructor parent
}
//komentar buat ngubah deskripsi doang