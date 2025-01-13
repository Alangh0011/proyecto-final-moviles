import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VistaHorariosPage extends StatefulWidget {
  const VistaHorariosPage({super.key});

  @override
  State<VistaHorariosPage> createState() => _VistaHorariosPageState();
}

class _VistaHorariosPageState extends State<VistaHorariosPage> {
  final Map<String, TextEditingController> searchControllers = {
    "ISC": TextEditingController(),
    "IA": TextEditingController(),
    "LCD": TextEditingController(),
  };

  Stream<List<Map<String, dynamic>>> fetchHorariosByCarrera(
      String carrera, String query) {
    return FirebaseFirestore.instance
        .collection('horarios')
        .where('carrera', isEqualTo: carrera)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((horario) =>
                horario['nombreMateria']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                horario['grupo']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                horario['profesorAsignado']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Horarios registrados",
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
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: "ISC"),
                  Tab(text: "IA"),
                  Tab(text: "LCD"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                 
                  buildTabContent("ISC"),
                 
                  buildTabContent("IA"),
                  
                  buildTabContent("LCD"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(String carrera) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchControllers[carrera],
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar en $carrera...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: buildHorariosList(fetchHorariosByCarrera(
            carrera,
            searchControllers[carrera]!.text,
          )),
        ),
      ],
    );
  }

  Widget buildHorariosList(Stream<List<Map<String, dynamic>>> horariosStream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: horariosStream,
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
              'No hay horarios registrados.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          final horarios = snapshot.data!;
          return ListView.builder(
            itemCount: horarios.length,
            itemBuilder: (context, index) {
              final horario = horarios[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4.0,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Materia: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: horario['nombreMateria'],
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Grupo: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: horario['grupo'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Horario: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${horario['horaInicio']} - ${horario['horaFin']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Carrera: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: horario['carrera'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                        const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Profesor asignado: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${horario['profesorAsignado']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                       const SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Correo del profesor: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${horario['correoProfesor']}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
