import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetallesAlumnosPage extends StatelessWidget {
  final String usuarioId; 

  const DetallesAlumnosPage({Key? key, required this.usuarioId, required String profesorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Información del alumno",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuarioId) 
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No se encontró la información."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre: ${data['nombre']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.blue),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Boleta:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "${data['boleta']}",
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Correo:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "${data['correo']}",
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 24.0),
             
           
                
              ],
            ),
          );
        },
      ),
    );
  }
}
