import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_final_moviles/src/pages/users/loginPage.dart';

class PerfilPageProfesores extends StatefulWidget {
  const PerfilPageProfesores({super.key});

  @override
  _PerfilPageProfesoresState createState() => _PerfilPageProfesoresState();
}

class _PerfilPageProfesoresState extends State<PerfilPageProfesores> {
  late Future<Map<String, dynamic>> _profesorData;

  @override
  void initState() {
    super.initState();
    _profesorData = _fetchProfesorData();
  }

  Future<Map<String, dynamic>> _fetchProfesorData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      DocumentSnapshot profesorDoc = await FirebaseFirestore.instance
          .collection('profesores')
          .doc(user.uid)
          .get();

      if (!profesorDoc.exists)
        throw Exception('Datos del profesor no encontrados');

      return profesorDoc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error al obtener datos del profesor: $e');
    }
  }

  Future<void> _updateUserData(
      BuildContext context, String fieldName, String currentValue) async {
    final TextEditingController controller =
        TextEditingController(text: currentValue);
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Usuario no autenticado')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Editar $fieldName',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary:
                        Colors.blue, // Cambia el color púrpura al interactuar
                  ),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Nuevo',
                labelStyle: TextStyle(color: Colors.black), // Texto estático
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue), // Borde azul al enfocar
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.grey), // Borde gris sin enfocar
                ),
              ),
              cursorColor: Colors.blue, // Cursor azul
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // Fondo rojo
                foregroundColor: Colors.white, // Texto blanco
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Actualizar el dato en Firestore usando el campo sin acento
                  await FirebaseFirestore.instance
                      .collection('profesores')
                      .doc(user.uid)
                      .update({
                    'telefono':
                        controller.text, // Aquí se usa 'telefono' sin acento
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Datos actualizados exitosamente',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green, // Fondo verde para éxito
                    ),
                  );

                  // Recargar los datos actualizados
                  setState(() {
                    _profesorData = _fetchProfesorData(); // Recargar datos
                  });
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al actualizar: $e',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red, // Fondo rojo para error
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Fondo azul
                foregroundColor: Colors.white, // Texto blanco
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  /// Cierra la sesión del usuario
  Future<void> _cerrarSesion(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Sesión cerrada correctamente')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Perfil del Profesor",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profesorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No se encontraron datos del profesor.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            Map<String, dynamic> profesorData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableUserInfo(
                    context,
                    "Nombre",
                    profesorData['nombre'] ?? 'Desconocido',
                  ),
                  const SizedBox(height: 16.0),
                  _buildEditableUserInfo(
                    context,
                    "Matrícula",
                    profesorData['matrícula'] ?? 'Desconocida',
                  ),
                  const SizedBox(height: 16.0),
                  _buildUserInfoContainer(
                    "Correo:",
                    profesorData['correo'] ?? 'Desconocido',
                  ),
                  const SizedBox(height: 16.0),
                  _buildUserInfoContainer(
                    "Academia:",
                    profesorData['academia'] ?? 'Desconocido',
                  ),
                  const SizedBox(height: 16.0),
                  _buildUserInfoContainer(
                    "CURP:",
                    profesorData['curp'] ?? 'Desconocido',
                  ),
                  const SizedBox(height: 16.0),
                  _buildEditableUserInfo(
                    context,
                    "Teléfono",
                    profesorData['telefono'] ?? 'Desconocido',
                  ),
                  const SizedBox(height: 32.0),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _cerrarSesion(context),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Cerrar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEditableUserInfo(
      BuildContext context, String fieldName, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fieldName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () =>
                  _updateUserData(context, fieldName.toLowerCase(), value),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserInfoContainer(String title, String value) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8.0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
