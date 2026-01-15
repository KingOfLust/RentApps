import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../models/iphone.dart';
import '../models/kamera.dart';
import 'payment_summary_screen.dart';

class DetailScreen extends StatefulWidget {
  final Produk unit;

  const DetailScreen({super.key, required this.unit});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _jumlahSewa = 1; // State untuk durasi sewa

  @override
  Widget build(BuildContext context) {
    const deepPurple = Color(0xFF4A148C);
    int totalHarga = widget.unit.harga * _jumlahSewa;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Sewa", style: TextStyle(color: Colors.white)),
        backgroundColor: deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan Nama dan Tipe Produk
                  Text(
                    widget.unit.nama,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // PILAR: POLYMORPHISM - Menampilkan detail unik tiap objek
                  if (widget.unit is Iphone) ...[
                    _buildSpecRow("Varian", (widget.unit as Iphone).warna),
                    _buildSpecRow("Storage", (widget.unit as Iphone).storage),
                    _buildSpecRow("RAM", (widget.unit as Iphone).ram),
                  ] else if (widget.unit is Kamera) ...[
                    _buildSpecRow("Jenis", (widget.unit as Kamera).jenis),
                    _buildSpecRow("Resolusi", (widget.unit as Kamera).resolusi),
                  ],

                  const Divider(height: 40),
                  const Text(
                    "DURASI SEWA (HARI)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // UI Counter Durasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_jumlahSewa > 1) setState(() => _jumlahSewa--);
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          color: deepPurple,
                          size: 32,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$_jumlahSewa",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _jumlahSewa++),
                        icon: const Icon(
                          Icons.add_circle,
                          color: deepPurple,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar untuk Total Biaya & Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: deepPurple,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL BIAYA",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp ${totalHarga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF4CAF50,
                      ), // Green warna sukses
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Navigasi ke Halaman Ringkasan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentSummaryScreen(
                            unit: widget.unit,
                            durasi: _jumlahSewa,
                            totalBiaya: totalHarga,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "LANJUT PEMBAYARAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk baris spesifikasi
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
//komentar buat ngubah deskripsi doang