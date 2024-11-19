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
      title: 'Flutter Demo',
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
  @override
  Widget build(BuildContext context) {
    const String viewType = 'ekyc-view';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: UiKitView(
            viewType: viewType,
            creationParams: creationParams,
            layoutDirection: TextDirection.ltr,
            creationParamsCodec: const StandardMessageCodec()),
      ),
    );
  }
}
