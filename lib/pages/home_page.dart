import 'package:flutter/material.dart';
import '../repository/database_helper.dart';
import '../models/produk.dart';
import '../models/iphone.dart';
import '../models/kamera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Melascula Rent",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Produk>>(
        // Memanggil fungsi READ dari DatabaseHelper
        future: DatabaseHelper().getProduk(),
        builder: (context, snapshot) {
          // Menampilkan loading saat database sedang dibaca
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menangani error atau jika data kosong
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Katalog kosong. Pastikan sudah Uninstall & Install ulang.",
              ),
            );
          }

          final listBarang = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listBarang.length,
            itemBuilder: (context, index) {
              final barang = listBarang[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  // PILAR POLYMORPHISM: Ikon berubah tergantung tipe objek
                  leading: CircleAvatar(
                    // ignore: deprecated_member_use
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: Icon(
                      barang is Iphone ? Icons.phone_android : Icons.camera_alt,
                      color: Colors.blueAccent,
                    ),
                  ),
                  title: Text(
                    barang.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Harga: Rp ${barang.harga} / hari"),
                      // Menampilkan spek singkat dari database
                      Text(
                        barang is Iphone
                            ? "Warna: ${barang.warna} | ${barang.storage}"
                            : "Jenis: ${(barang as Kamera).jenis}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigasi ke Detail Page
                    Navigator.pushNamed(context, '/detail', arguments: barang);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
//komentar buat ngubah deskripsi doang