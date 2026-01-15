import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  int _percentage = 0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  // Logika simulasi loading persentase
  void _startLoading() {
    const duration = Duration(milliseconds: 30); // Kecepatan loading
    Timer.periodic(duration, (timer) {
      setState(() {
        if (_progressValue < 1.0) {
          _progressValue += 0.01;
          _percentage = (_progressValue * 100).toInt();
        } else {
          timer.cancel();
          _navigateToHome();
        }
      });
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const KatalogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const deepPurple = Color(0xFF4A148C);

    return Scaffold(
      backgroundColor: deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo dengan animasi Hero
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage(
                'assets/images/Melascula_of_faith.png',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "MELASCULA RENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 60),

            // Progress Bar & Teks Persentase
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "$_percentage%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
