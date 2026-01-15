import 'package:flutter/material.dart';
import '../repository/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    const deepPurple = Color(0xFF4A148C);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Penyewaan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // FIXED: Memanggil getRiwayat() sesuai dengan DatabaseHelper terbaru
        future: _dbHelper.getRiwayat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada riwayat penyewaan."));
          }

          final riwayat = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: riwayat.length,
            itemBuilder: (context, index) {
              final item = riwayat[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: deepPurple,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(
                    item['nama_unit'] ?? 'Tanpa Nama',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Total: Rp ${item['total_harga']} \nDurasi: ${item['durasi']} hari (${item['tanggal']})",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(item['id'], item['nama_unit']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(int id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Riwayat"),
        content: Text("Apakah Anda yakin ingin menghapus riwayat sewa $nama?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // Operasi DELETE: Menghapus data berdasarkan ID di Database
              await _dbHelper.deleteTransaksi(id);
              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                setState(() {}); // Memicu UI untuk memuat ulang data
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Riwayat berhasil dihapus")),
                );
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
