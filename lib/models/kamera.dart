import 'produk.dart';

// PILAR: INHERITANCE
class Kamera extends Produk {
  String jenis;
  String resolusi;

  Kamera(super.nama, super.harga, this.jenis, this.resolusi, {required id});
}
