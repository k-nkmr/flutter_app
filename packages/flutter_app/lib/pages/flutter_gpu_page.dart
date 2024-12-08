import 'package:flutter/material.dart';

class FlutterGpuPage extends StatelessWidget {
  const FlutterGpuPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GPU Demo'),
      ),
      body: const Center(
        child: Text('hoge'),
      ),
    );
  }
}
