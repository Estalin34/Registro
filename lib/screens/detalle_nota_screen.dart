import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DetalleNotaScreen extends StatefulWidget {
  final String noteId;

  DetalleNotaScreen({required this.noteId});

  @override
  _DetalleNotaScreenState createState() => _DetalleNotaScreenState();
}

class _DetalleNotaScreenState extends State<DetalleNotaScreen> {
  final DatabaseReference db = FirebaseDatabase.instance.ref('notas');
  late String title = "", description = "", price = "";

  @override
  void initState() {
    super.initState();

    
    db.child(widget.noteId).get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> noteData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          title = noteData['titulo'] ?? 'No title'; 
          description = noteData['descripcion'] ?? 'No description'; 
          price = noteData['precio']?.toString() ?? '0'; 
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título: $title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción: $description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Precio: \$${price}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
