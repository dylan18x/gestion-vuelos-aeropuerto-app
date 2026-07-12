import 'package:flutter/material.dart';
import '../../../domain/model/torre_control.dart';

class TorreDetalleScreen extends StatelessWidget {
  final TorreControl torre;
  const TorreDetalleScreen({super.key, required this.torre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Torre: ${torre.nombre}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${torre.nombre}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}