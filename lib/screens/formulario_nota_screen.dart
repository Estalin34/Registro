import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FormularioNotaScreen extends StatefulWidget {
  const FormularioNotaScreen({Key? key}) : super(key: key);

  @override
  _FormularioNotaScreenState createState() => _FormularioNotaScreenState();
}

class _FormularioNotaScreenState extends State<FormularioNotaScreen> {
  final DatabaseReference db = FirebaseDatabase.instance.ref();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            TextField(
              controller: precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newNote = {
                  'titulo': tituloController.text,
                  'descripcion': descripcionController.text,
                  'precio': precioController.text,
                };

              
                db.child('notas').push().set(newNote).then((_) {
                  print("Nota guardada con éxito");
                  Navigator.pop(context); 
                }).catchError((error) {
                  print("Error al guardar la nota: $error");
                });
              },
              child: const Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}
