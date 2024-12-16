import 'package:flutter/material.dart';

class DetalleNotaScreen extends StatelessWidget {
  final String noteId;

  DetalleNotaScreen({required this.noteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Nota')),
      body: Center(
        child: Text('Aquí se mostrarán los detalles de la nota con ID: $noteId'),
      ),
    );
  }
}
