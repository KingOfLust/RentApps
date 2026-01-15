import 'package:flutter/material.dart';
import 'repository/database_helper.dart';
import 'models/produk.dart';
import 'models/iphone.dart';
import 'models/kamera.dart';
import 'pages/splash_screen.dart';
import 'pages/detail_screen.dart';
import 'pages/history_page.dart'; // Import halaman riwayat

void main() => runApp(const MelasculaRentApp());

class MelasculaRentApp extends StatelessWidget {
  const MelasculaRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MELASCULA RENT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A148C)),
        useMaterial3: true,
      ),
      // Mengarahkan ke Splash Screen saat pertama buka
      home: const SplashScreen(),
      // Mendaftarkan Route untuk navigasi antar halaman
      routes: {
        '/katalog': (context) => const KatalogScreen(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  State<KatalogScreen> createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Produk> allUnits = [];
  List<Produk> filteredUnits = [];
  String selectedCategory = "Semua";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk mengambil data dari Database
  Future<void> _loadData() async {
    setState(() => isLoading = true);

    // Memanggil fungsi getProduk yang sudah berisi 24 item otomatis
    List<Produk> data = await _dbHelper.getProduk();

    setState(() {
      allUnits = data;
      filteredUnits = data;
      isLoading = false;
    });
  }

  void _filterLogic(String query, String category) {
    setState(() {
      selectedCategory = category;
      filteredUnits = allUnits.where((u) {
        bool matchQuery = u.nama.toLowerCase().contains(query.toLowerCase());
        bool matchCategory = true;
        if (category == "iPhone") matchCategory = u is Iphone;
        if (category == "Kamera") matchCategory = u is Kamera;
        return matchQuery && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const deepPurple = Color(0xFF4A148C);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MELASCULA RENT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: deepPurple,
        centerTitle: true,
        actions: [
          // Tombol untuk melihat riwayat sewa (READ CRUD)
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (val) => _filterLogic(val, selectedCategory),
                    decoration: InputDecoration(
                      hintText: "Cari unit (iPhone/Kamera)...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                // Filter Chips (Pilar Polymorphism)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ["Semua", "iPhone", "Kamera"].map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (bool selected) {
                            _filterLogic("", selected ? cat : "Semua");
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Katalog List dari SQLite
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUnits.length,
                    itemBuilder: (context, index) {
                      final unit = filteredUnits[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          // Menampilkan ikon berdasarkan jenis objek (Polimorfisme)
                          leading: Icon(
                            unit is Iphone
                                ? Icons.phone_android
                                : Icons.camera_alt,
                            color: deepPurple,
                          ),
                          title: Text(
                            unit.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Rp ${unit.harga} / hari"),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(unit: unit),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
// Update keterangan folder