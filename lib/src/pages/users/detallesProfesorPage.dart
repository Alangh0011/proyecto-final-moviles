import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetallesProfesorPage extends StatelessWidget {
  final String profesorId; // Para identificar al profesor seleccionado

  const DetallesProfesorPage({Key? key, required this.profesorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Información del profesor",
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
            .collection('profesores')
            .doc(profesorId) // Buscar el profesor por su ID
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No se encontró la información."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Convertir la carrera abreviada a su nombre completo
          String carreraNombre = _getCarreraNombre(data['academia']);

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
                  "Matrícula:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "${data['matricula']}",
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),

                const Text(
                  "Academia:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "$carreraNombre", // Aquí mostramos el nombre completo de la carrera
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "CURP:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  "${data['curp']}".toUpperCase(),
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                // Agrega más información si es necesario
              ],
            ),
          );
        },
      ),
    );
  }

  // Función que convierte la abreviatura de la carrera al nombre completo
  String _getCarreraNombre(String abreviatura) {
    switch (abreviatura) {
      case 'ACB':
        return 'Academia de Ciencia Básicas';
      case 'ACC':
        return 'Academia de Ciencias de la Comunicación';
      case 'ACS':
        return 'Academia de Ciencias Sociales';
      case 'AFSE':
        return 'Academia de Fundamentos de Sistemas Electrónicos';
      case 'AIS':
        return 'Academia de Ingeniería de Software';
      case 'APETD':
        return 'Academia de Proyectos Estratégicos y Toma de Decisiones';
      case 'ASDIG':
        return 'Academia De Sistemas Digitales';
      case 'ASDIS':
        return 'Academia de Sistemas Distribuidos';
      case 'ACD':
        return 'Academia de Ciencia de Datos';
      case 'AIA':
        return 'Academia de Inteligencia Artificial';
      default:
        return 'Carrera desconocida'; // Valor predeterminado si no se encuentra la abreviatura
    }
  }
}
