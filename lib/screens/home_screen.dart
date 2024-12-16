import 'package:deber_02/screens/detalle_nota_screen.dart';
import 'package:deber_02/screens/formulario_nota_screen.dart';
import 'package:deber_02/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  // Verifica si el usuario está logueado al iniciar
  void _checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Si no hay usuario logueado, redirige al login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Notas'),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige al login
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db.child('notas').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text('No hay notas disponibles.'));
          }

          final notesMap = (snapshot.data?.snapshot.value as Map<dynamic, dynamic>?) ?? {};
          final notes = notesMap.entries.map((entry) {
            final note = Map<String, dynamic>.from(entry.value);
            return {
              'id': entry.key,
              'titulo': note['titulo'] ?? '',
              'descripcion': note['descripcion'] ?? '',
            };
          }).toList();

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['titulo']),
                subtitle: Text(note['descripcion']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleNotaScreen(noteId: note['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioNotaScreen()), 
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
