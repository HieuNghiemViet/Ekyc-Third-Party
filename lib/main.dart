import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EKYCNativeScreen(title: 'eKYC Native Screen'),
    );
  }
}

class EKYCNativeScreen extends StatefulWidget {
  const EKYCNativeScreen({super.key, required this.title});

  final String title;

  @override
  State<EKYCNativeScreen> createState() => _EKYCNativeScreenState();
}

class _EKYCNativeScreenState extends State<EKYCNativeScreen> {

  static const platform = MethodChannel('flutter.sdk.ekyc/integrate');


  Future<void> _getDataEkyc() async {
    try {
      final result = await platform.invokeMethod('startEkycFull');
      print('HieuNV Success: ${jsonDecode(result)}');
    } on PlatformException catch (e) {
      print("HieuNV Failed: '${e.message}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _getDataEkyc();
          },
          child: const Text("eKYC Native Screen"),
        ),
      ),
    );
  }
}
