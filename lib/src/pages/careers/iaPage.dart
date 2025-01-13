import 'package:flutter/material.dart';

// ignore: camel_case_types
class iaPage extends StatefulWidget {
  const iaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlanIAContentState createState() => _PlanIAContentState();
} 

class _PlanIAContentState extends State<iaPage> {
  final String _imageAssetPath = 'lib/src/assets/images/horarioia.png';

  final List<Map<String, String>> _sections = [
    {
      "title": "Perfil de ingreso",
      "content":
          "Los estudiantes que ingresen al Instituto Politécnico Nacional, en cualquiera de sus programas y niveles, deberán contar con los conocimientos y las habilidades básicas que garanticen un adecuado desempeño en el nivel al que solicitan su ingreso. ",
      "image": "lib/src/assets/images/perfilingreso.png"    
    },
    {
      "title": "Perfil de egreso",
      "content":
          "El egresado de la Ingeniería en Inteligencia Artificial se desempeñará colaborativamente en equipos multidisciplinarios en el análisis, diseño, implementación, validación, implantación, supervisión y gestión de sistemas inteligentes, aplicando algoritmos en áreas como aprendizaje de máquina, procesamiento automático de lenguaje natural, visión artificial y modelos bioinspirados",
      "image": "lib/src/assets/images/perfilegreso.png"
    },
    {
      "title": "Campo laboral",
      "content":
          "Este profesional podrá desempeñarse en el desarrollo y aplicación de la Inteligencia Artificial, en los ámbitos público y privado",
      "image": "lib/src/assets/images/laboral.png"
    },
    {
      "title": "Titulación",
      "content":
          "En la Escuela Superior de Cómputo, de conformidad con el Reglamento de Titulación Profesional vigente se considerarán 9 opciones para titulación profesional en la carrera de Ing. en Sistemas Computacionales (ISC), Ing. en Inteligencia Artificial (IIA), Lic. en Ciencia de Datos (LCD) e Ing. en Sistemas Automotrices (ISISA)",
      "image": "lib/src/assets/images/titulacion.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            "Ingeniería en Inteligencia Artificial",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
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
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Objetivo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        "Formar expertos capaces de desarrollar sistemas inteligentes utilizando diferentes metodologías en áreas como aprendizaje de máquina, procesamiento de lenguaje natural y visión artificial, generando soluciones innovadoras para atender las necesidades de diversos sectores.",
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.5,
              ),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    _showDialog(context, _sections[index]["title"]!,
                        _sections[index]["content"]!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _sections[index][
                            "image"]!, // Utiliza la ruta de la imagen directamente
                        width: 24.0,
                        height: 24.0,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _sections[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
              const SizedBox(height: 20.0),
              Image.asset(
                _imageAssetPath,
                width: double.infinity,
                height: 300.0,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Text(
            content,
            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
