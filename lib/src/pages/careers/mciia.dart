import 'package:flutter/material.dart';

class MciiaPage extends StatelessWidget {
  const MciiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Maestría en Intelicencia Artificial",
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
      body: const MciiaContent(),
    );
  }
}

class MciiaContent extends StatefulWidget {
  const MciiaContent({super.key});

  @override
  _MciiaContentState createState() => _MciiaContentState();
}

class _MciiaContentState extends State<MciiaContent> {
 final String _imageAssetPath = 'lib/src/assets/images/cerebro.png';

  final List<Map<String, String>> _sections = [
    {
      "title": "Plan de estudios",
      "content":
          "Incluye un núcleo básico (matemáticas computacionales, métodos avanzados), un paquete primario con fundamentos de IA y un paquete especializado con asignaturas como aprendizaje por refuerzo, procesamiento de lenguaje natural y visión por computadora."},
    {
      "title": "Enfoques",
      "content":
          "Investigación en ingeniería biomédica y desarrollo de software/hardware inteligente."},
    {
      "title": "Duración",
      "content":
          "Dos años (4 semestres)."},
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
                      "Información",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(" Maestría en Inteligencia Artificial (IA) está disponible en diversas instituciones en México y ofrece enfoques innovadores en investigación, desarrollo tecnológico y aplicación de la IA a sectores como la industria, salud y ciencias sociales.",
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
                  child: Text(
                    _sections[index]["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
              Image.asset(
              _imageAssetPath,
              width: double.infinity,
              height: 200.0,
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
