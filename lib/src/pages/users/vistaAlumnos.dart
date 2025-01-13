import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final_moviles/src/pages/users/detallesAlumnosPage.dart';

class VistaAlumnosPage extends StatefulWidget {
  const VistaAlumnosPage({Key? key}) : super(key: key);

  @override
  _VistaAlumnosPageState createState() => _VistaAlumnosPageState();
}

class _VistaAlumnosPageState extends State<VistaAlumnosPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim();
      });
    });
  }

  Stream<QuerySnapshot> _buildQuery() {
    return FirebaseFirestore.instance.collection('usuarios').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Alumnos registrados",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
         
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, correo o boleta',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _buildQuery(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No se encontraron usuarios."));
                  }

                 
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final nombre =
                        data['nombre']?.toString().toLowerCase() ?? '';
                    final correo =
                        data['correo']?.toString().toLowerCase() ?? '';
                    final identificacion =
                        data['boleta']?.toString().toLowerCase() ?? '';

                    return nombre.contains(_searchText.toLowerCase()) ||
                        correo.contains(_searchText.toLowerCase()) ||
                        identificacion.contains(_searchText.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(
                        child: Text("No se encontraron resultados."));
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(
                            data['nombre'] ?? 'Sin nombre',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          subtitle: Text(
                            'Correo: ${data['correo'] ?? 'N/A'}\nID: ${data['boleta'] ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                          ),
                          leading: const Icon(Icons.person),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetallesAlumnosPage(
                                  usuarioId: doc.id,
                                  profesorId: '',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
