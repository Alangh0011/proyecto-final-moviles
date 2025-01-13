import 'package:flutter/material.dart';

class McscmPage extends StatelessWidget {
  const McscmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Maestría en Sistemas Computacionales Móviles",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14.5,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const McscmContent(),
    );
  }
}

class McscmContent extends StatefulWidget {
  const McscmContent({super.key});

  @override
  _McscmContentState createState() => _McscmContentState();
}

class _McscmContentState extends State<McscmContent> {
   final String _imageAssetPath = 'lib/src/assets/images/aplicaciones.png';

  final List<Map<String, String>> _sections = [
    {
      "title": "Características",
      "content":
          "Duración: 2 años (4 semestres), Modalidad: Presencial, de tiempo completo, Desarrollo de sistemas para el cómputo móvil, Sistemas digitales, Comunicaciones móviles."
    },
    {
      "title": "Objetivo",    
      "content":
          "El programa busca desarrollar competencias en modelos de analítica avanzada, aprendizaje automático y métodos estadísticos."},{
      "title": "Costos",
      "content":
          "Muy accesible en el caso del IPN, con aportaciones semestrales voluntarias."
    },
    {
      "title": "Becas",
      "content":
      "Se puede aplicar a becas del CONACYT y del programa BEIFI"},
    {
      "title": "Perfil de egreso",
      "content":
      "El egresado está preparado para diseñar, innovar e implementar sistemas en computación móvil, además de continuar hacia un doctorado si lo desea. Esto abre oportunidades en investigación, academia, y sectores tecnológicos con alta demanda y remuneración competitiva​"},
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
                    Text(
                      "La Maestría en Ciencias en Sistemas Computacionales Móviles es un programa de posgrado orientado a formar expertos en computación móvil. Ofrecida por instituciones como el Instituto Politécnico Nacional (IPN), su enfoque está en la investigación, innovación y desarrollo de tecnologías móviles, atendiendo necesidades en sectores productivos y sociales.",
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
              fit: BoxFit.contain,)
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
