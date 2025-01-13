import 'package:flutter/material.dart';

class IscPage extends StatelessWidget {
  const IscPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Ingeniería en Sistemas Computacionales",
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
        body: Column(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: "Plan 2020"),
                  Tab(text: "Plan 2009"),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  Plan2020Content(),
                  Plan2009Content(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Plan2020Content extends StatefulWidget {
  const Plan2020Content({super.key});

  @override
  _Plan2020ContentState createState() => _Plan2020ContentState();
}

class _Plan2020ContentState extends State<Plan2020Content> {
  final String _imageAssetPath = 'lib/src/assets/images/horarioisc.png';

  final List<Map<String, String>> _sections = [
    {
      "title": "Perfil de ingreso",
      "content":
          "Los aspirantes a estudiar este programa deberán tener conocimientos en matemáticas, física e informática. Es también conveniente que posea conocimientos de inglés.",
      "image": "lib/src/assets/images/perfilingreso.png"
    },
    {
      "title": "Perfil de egreso",
      "content":
          "El egresado del programa académico de Ingeniería en Sistemas Computacionales podrá desempeñarse en equipos multidisciplinarios.",
      "image": "lib/src/assets/images/perfilegreso.png"
    },
    {
      "title": "Atributos del Egresado",
      "content":
          "Los atributos de egreso son un conjunto de resultados evaluables individualmente, que conforman los componentes indicativos del potencial de un egresado.",
      "image": "lib/src/assets/images/atributos.png"
    },
    {
      "title": "Campo Laboral",
      "content":
          "El campo profesional en el que se desarrollan los egresados de este Programa Académico es muy amplio.",
      "image": "lib/src/assets/images/laboral.png"
    },
    {
      "title": "Titulación",
      "content":
          "En la Escuela Superior de Cómputo, de conformidad con el Reglamento de Titulación Profesional vigente.",
      "image": "lib/src/assets/images/titulacion.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      "Formar ingenieros en sistemas computacionales de sólida preparación científica y tecnológica.",
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

class Plan2009Content extends StatefulWidget {
  const Plan2009Content({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Plan2009ContentState createState() => _Plan2009ContentState();
}

class _Plan2009ContentState extends State<Plan2009Content> {
  final String _imageAssetPath = 'lib/src/assets/images/horarioisc2009.png';

  final List<Map<String, String>> _sections = [
    {
      "title": "Perfil de ingreso",
      "content":
          "Investigación, análisis y síntesis de información, Criterio y razonamiento lógico para la solución de problemas, Expresión oral y escrita, Actitudes de: respeto, responsabilidad, Interesado en las ciencias básicas y tecnologías de cómputo y Asumir una posición activa con respecto al estudio y al desarrollo de los proyectos y trabajos requeridos, coincidentes con el ideario y principios del IPN",
      "image": "lib/src/assets/images/perfilingreso.png"
    },
    {
      "title": "Perfil de egreso",
      "content":
          "Los egresados cuentan con una sólida formación integral, para proponer, analizar, diseñar, desarrollar, implementar, gestionar y administrar sistemas computacionales usando tecnologías de cómputo de vanguardia y aplicando metodologías, normas y estándares nacionales e internacionales de calidad para crear, mejorar y sistematizar procesos administrativos e industriales. ",
      "image": "lib/src/assets/images/perfilegreso.png"
    },
    {
      "title": "Atributos del Egresado",
      "content":
          "Los atributos de egreso son un conjunto de resultados evaluables individualmente, que conforman los componentes indicativos del potencial de un egresado para adquirir las competencias o capacidades para ejercer la práctica de la ingeniería a un nivel apropiado.",
      "image": "lib/src/assets/images/atributos.png"
    },
    {
      "title": "Campo Laboral",
      "content":
          "El Ingeniero en Sistemas Computacionales se desempeña en los sectores privado, público, académico y ejercicio libre de la profesión.",
      "image": "lib/src/assets/images/laboral.png"
    },
    {
      "title": "Titulación",
      "content":
          "En la Escuela Superior de Cómputo, de conformidad con el Reglamento de Titulación Profesional vigente se considerarán 9 opciones para titulación profesional en la carrera de Ing. en Sistemas Computacionales (ISC) e Ing. en Sistemas Automotrices (ISISA).",
      "image": "lib/src/assets/images/titulacion.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      "Formar Ingenieros en Sistemas Computacionales que cuenten con una sólida formación integral que les permita proponer, analizar, diseñar, desarrollar, implementar, gestionar y administrar sistemas computacionales usando tecnologías de cómputo de vanguardia.",
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


