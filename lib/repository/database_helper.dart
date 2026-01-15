import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produk.dart';
import '../models/iphone.dart';
import '../models/kamera.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Nama database versi 3 untuk memastikan seeding ulang berjalan lancar
    String path = join(await getDatabasesPath(), 'melascula_final_v3.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 1. Membuat Tabel Katalog Produk (Master)
        await db.execute('''
          CREATE TABLE produk(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT, harga INTEGER, tipe TEXT, spek1 TEXT, spek2 TEXT, spek3 TEXT
          )
        ''');

        // 2. Membuat Tabel Riwayat Transaksi (CRUD)
        await db.execute('''
          CREATE TABLE transaksi(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_unit TEXT, durasi INTEGER, total_harga INTEGER, tanggal TEXT
          )
        ''');

        // 3. SEEDING: Memasukkan 12 iPhone & 12 Kamera otomatis
        List<Map<String, dynamic>> initialData = [
          // iPhone Series
          {'nama': 'iPhone 15 Pro Max', 'harga': 250000, 'tipe': 'iPhone', 'spek1': 'Natural Titanium', 'spek2': '256GB', 'spek3': '8GB'},
          {'nama': 'iPhone 15 Pro', 'harga': 220000, 'tipe': 'iPhone', 'spek1': 'Blue Titanium', 'spek2': '128GB', 'spek3': '8GB'},
          {'nama': 'iPhone 15 Plus', 'harga': 180000, 'tipe': 'iPhone', 'spek1': 'Black', 'spek2': '256GB', 'spek3': '6GB'},
          {'nama': 'iPhone 15', 'harga': 150000, 'tipe': 'iPhone', 'spek1': 'Pink', 'spek2': '128GB', 'spek3': '6GB'},
          {'nama': 'iPhone 14 Pro Max', 'harga': 200000, 'tipe': 'iPhone', 'spek1': 'Deep Purple', 'spek2': '512GB', 'spek3': '6GB'},
          {'nama': 'iPhone 14 Pro', 'harga': 170000, 'tipe': 'iPhone', 'spek1': 'Space Black', 'spek2': '256GB', 'spek3': '6GB'},
          {'nama': 'iPhone 14 Plus', 'harga': 140000, 'tipe': 'iPhone', 'spek1': 'Starlight', 'spek2': '128GB', 'spek3': '6GB'},
          {'nama': 'iPhone 14', 'harga': 130000, 'tipe': 'iPhone', 'spek1': 'Midnight', 'spek2': '128GB', 'spek3': '6GB'},
          {'nama': 'iPhone 13 Pro Max', 'harga': 160000, 'tipe': 'iPhone', 'spek1': 'Sierra Blue', 'spek2': '256GB', 'spek3': '6GB'},
          {'nama': 'iPhone 13 Pro', 'harga': 140000, 'tipe': 'iPhone', 'spek1': 'Alpine Green', 'spek2': '128GB', 'spek3': '6GB'},
          {'nama': 'iPhone 13', 'harga': 110000, 'tipe': 'iPhone', 'spek1': 'Starlight', 'spek2': '128GB', 'spek3': '4GB'},
          {'nama': 'iPhone 13 Mini', 'harga': 95000, 'tipe': 'iPhone', 'spek1': 'Red', 'spek2': '128GB', 'spek3': '4GB'},

          // Kamera Series
          {'nama': 'Sony A7 IV', 'harga': 220000, 'tipe': 'Kamera', 'spek1': 'Full Frame Mirrorless', 'spek2': '33MP', 'spek3': '-'},
          {'nama': 'Sony A7 III', 'harga': 180000, 'tipe': 'Kamera', 'spek1': 'Full Frame Mirrorless', 'spek2': '24.2MP', 'spek3': '-'},
          {'nama': 'Sony A6400', 'harga': 120000, 'tipe': 'Kamera', 'spek1': 'APS-C Mirrorless', 'spek2': '24.2MP', 'spek3': '-'},
          {'nama': 'Sony ZV-E10', 'harga': 100000, 'tipe': 'Kamera', 'spek1': 'Vlogging Mirrorless', 'spek2': '24.2MP', 'spek3': '-'},
          {'nama': 'Canon EOS R6 Mark II', 'harga': 240000, 'tipe': 'Kamera', 'spek1': 'Full Frame Mirrorless', 'spek2': '24.2MP', 'spek3': '-'},
          {'nama': 'Canon EOS R7', 'harga': 170000, 'tipe': 'Kamera', 'spek1': 'APS-C Mirrorless', 'spek2': '32.5MP', 'spek3': '-'},
          {'nama': 'Canon EOS R10', 'harga': 140000, 'tipe': 'Kamera', 'spek1': 'APS-C Mirrorless', 'spek2': '24.2MP', 'spek3': '-'},
          {'nama': 'Canon EOS 90D', 'harga': 130000, 'tipe': 'Kamera', 'spek1': 'DSLR', 'spek2': '32.5MP', 'spek3': '-'},
          {'nama': 'Fujifilm X-T5', 'harga': 210000, 'tipe': 'Kamera', 'spek1': 'Mirrorless', 'spek2': '40MP', 'spek3': '-'},
          {'nama': 'Fujifilm X-T4', 'harga': 160000, 'tipe': 'Kamera', 'spek1': 'Mirrorless', 'spek2': '26MP', 'spek3': '-'},
          {'nama': 'Fujifilm X-S10', 'harga': 110000, 'tipe': 'Kamera', 'spek1': 'Mirrorless', 'spek2': '26.1MP', 'spek3': '-'},
          {'nama': 'Fujifilm X-T30 II', 'harga': 105000, 'tipe': 'Kamera', 'spek1': 'Mirrorless', 'spek2': '26.1MP', 'spek3': '-'},
        ];

        for (var item in initialData) {
          await db.insert('produk', item);
        }
      },
    );
  }

  // === OPERASI READ (KATALOG) ===
  Future<List<Produk>> getProduk() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produk');

    return List.generate(maps.length, (i) {
      if (maps[i]['tipe'] == 'iPhone') {
        return Iphone(
          maps[i]['nama'],
          maps[i]['harga'],
          maps[i]['spek1'],
          maps[i]['spek2'],
          maps[i]['spek3'],
          id: maps[i]['id'],
        );
      } else {
        return Kamera(
          maps[i]['nama'],
          maps[i]['harga'],
          maps[i]['spek1'],
          maps[i]['spek2'],
          id: maps[i]['id'],
        );
      }
    });
  }

  // === OPERASI CREATE (SIMPAN SEWA) ===
  Future<int> insertTransaksi(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('transaksi', data);
  }

  // === OPERASI READ (RIWAYAT) ===
  Future<List<Map<String, dynamic>>> getRiwayat() async {
    final db = await database;
    return await db.query('transaksi', orderBy: 'id DESC');
  }

  // === OPERASI DELETE (HAPUS RIWAYAT) ===
  Future<int> deleteTransaksi(int id) async {
    final db = await database;
    return await db.delete('transaksi', where: 'id = ?', whereArgs: [id]);
  }
}