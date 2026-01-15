import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../repository/database_helper.dart';
import 'package:intl/intl.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final Produk unit;
  final int durasi;

  const PaymentSummaryScreen({
    super.key,
    required this.unit,
    required this.durasi,
    required int totalBiaya,
  });

  @override
  Widget build(BuildContext context) {
    final int totalHarga = unit.harga * durasi;
    const deepPurple = Color(0xFF4A148C);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ringkasan Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Unit", unit.nama),
            _buildInfoRow("Harga / Hari", "Rp ${unit.harga}"),
            _buildInfoRow("Durasi Sewa", "$durasi Hari"),
            const Divider(thickness: 2),
            _buildInfoRow("Total Bayar", "Rp $totalHarga", isBold: true),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  // 1. Siapkan data untuk disimpan (CREATE)
                  Map<String, dynamic> dataSewa = {
                    'nama_unit': unit.nama,
                    'durasi': durasi,
                    'total_harga': totalHarga,
                    'tanggal': DateFormat(
                      'dd MMM yyyy, HH:mm',
                    ).format(DateTime.now()),
                  };

                  // 2. Simpan ke Database
                  await DatabaseHelper().insertTransaksi(dataSewa);

                  // 3. Beri Feedback & Kembali ke Katalog
                  if (context.mounted) {
                    _showSuccessDialog(context);
                  }
                },
                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "Pembayaran Berhasil! Data telah disimpan ke riwayat.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Kembali ke katalog dan hapus semua stack navigasi
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/katalog',
                (route) => false,
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
//komentar buat ngubah deskripsi doang