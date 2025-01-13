import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

class PaginaPrincipalPage extends StatefulWidget {
  const PaginaPrincipalPage({super.key});

  @override
  _PaginaPrincipalPageState createState() => _PaginaPrincipalPageState();
}

class _PaginaPrincipalPageState extends State<PaginaPrincipalPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'ESCOM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/perfil');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Aquí va la vista del mapa cuando se selecciona "Ubicación"
          _buildMapaPage(),
          // Aquí va la vista principal cuando se selecciona "Inicio"
          _buildMainPage(),
          const RedesSocialesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Redes',
          ),
        ],
      ),
    );
  }

  // Vista del mapa
  Widget _buildMapaPage() {
    return Column(
      children: [
        // Mapa
        SizedBox(
            height: 300, // Ajusta la altura del mapa
            child: FlutterMap(
              options: const MapOptions(
                initialCenter:
                    LatLng(19.505, -99.146667), // Center the map over London
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  // Display map tiles from any source
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                  userAgentPackageName: 'com.example.app',
                  // And many more recommended properties!
                ),
                const MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                          19.505, -99.146667), // Coordenadas del marcador
                      child: Icon(
                        Icons.location_on, // Icono del marcador
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    // Puedes agregar más marcadores si es necesario
                  ],
                ),
                const RichAttributionWidget(
                  // Include a stylish prebuilt attribution widget that meets all requirments
                  attributions: [
                    // TextSourceAttribution(
                    //   'OpenStreetMap contributors',
                    //   onTap: () => launchUrl(Uri.parse(
                    //       'https://openstreetmap.org/copyright')), // (external)
                    // ),
                    // Also add images...
                  ],
                ),
              ],
            )),

        // Coordenadas debajo del mapa
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alineación a la izquierda
            children: [
              Text(
                'Ubicación:', // Coordenadas de la ubicación
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue),
              ),
              Text(
                "ESCOM - Escuela Superior de Cómputo - IPN",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
              ),
              Text(
                "ESCOM IPN, Unidad Profesional Adolfo López Mateos, Av. Juan de Dios Bátiz, Nueva Industrial Vallejo, Gustavo A. Madero, 07320 Ciudad de México, CDMX",
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Vista principal cuando se selecciona "Inicio"
  Widget _buildMainPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: 175,
            child: Center(
              child: Image.asset(
                'lib/src/assets/images/logoescom.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Escuela Superior de Cómputo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
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
                    child: Text(
                      "La Escuela Superior de Cómputo fue fundada el 13 de agosto de 1993 y ofrece las carreras de ISC, IIA y LCD.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Oferta Educativa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
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
            height: 250,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                const items = [
                  OfertaEducativaItem(
                      label: "ISC",
                      assetPath: "lib/src/assets/images/isc.png",
                      route: '/isc'),
                  OfertaEducativaItem(
                      label: "IIA",
                      assetPath: "lib/src/assets/images/ia.png",
                      route: '/ia'),
                  OfertaEducativaItem(
                      label: "LCD",
                      assetPath: "lib/src/assets/images/lcd.png",
                      route: '/lcd'),
                  OfertaEducativaItem(
                      label: "MCSCM",
                      assetPath: "lib/src/assets/images/mcsm.png",
                      route: '/mcscm'),
                  OfertaEducativaItem(
                      label: "MCIIA",
                      assetPath: "lib/src/assets/images/mciia.png",
                      route: '/mciia'),
                  OfertaEducativaItem(
                      label: "MCCD",
                      assetPath: "lib/src/assets/images/mccd.png",
                      route: '/mccd'),
                ];
                return items[index];
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Espaciado igual
              children: [
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/vistaProfesores'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 40),
                    backgroundColor: Colors.blue,
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ajusta el tamaño al contenido
                    children: [
                      Image.asset(
                        'lib/src/assets/images/profesor.png', // Ruta del asset
                        height: 24, // Tamaño de la imagen
                        width: 24,
                      ),
                      const SizedBox(
                          width: 8), // Espacio entre la imagen y el texto
                      const Text(
                        'Ver profesores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      {Navigator.pushNamed(context, '/vistaHorarios')},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 40),
                    backgroundColor: Colors.green,
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ajusta el tamaño al contenido
                    children: [
                      Image.asset(
                        'lib/src/assets/images/horario.png', // Ruta del asset
                        height: 24, // Tamaño de la imagen
                        width: 24,
                      ),
                      const SizedBox(
                          width: 8), // Espacio entre la imagen y el texto
                      const Text(
                        'Ver horarios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OfertaEducativaItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final String route;

  const OfertaEducativaItem(
      {super.key,
      required this.label,
      required this.assetPath,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class RedesSocialesPage extends StatefulWidget {
  const RedesSocialesPage({super.key});

  @override
  _RedesSocialesPageState createState() => _RedesSocialesPageState();
}

class _RedesSocialesPageState extends State<RedesSocialesPage> {
  final List<Map<String, String>> _redesSociales = [
    {
      'nombre': 'Facebook',
      'url': 'https://www.facebook.com/escomipnmx',
      'icon': 'lib/src/assets/images/facebook.png',
    },
    {
      'nombre': 'Twitter',
      'url': 'https://x.com/escomunidad/',
      'icon': 'lib/src/assets/images/twitter.png',
    },
    {
      'nombre': 'Página oficial',
      'url': 'https://www.escom.ipn.mx',
      'icon': 'lib/src/assets/images/web.png',
    },
  ];

  void _copyToClipboard(String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            'Enlace copiado al portapapeles',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Redes Sociales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            // Aquí mostramos los íconos de redes sociales sin el dropdown
            ..._redesSociales.map((redSocial) {
              return ListTile(
                leading: Image.asset(
                  redSocial['icon']!,
                  width: 40,
                  height: 40,
                ),
                title: Text(redSocial['nombre']!),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(redSocial['url']!),
                ),
                onTap: () {
                  // Lógica para abrir la URL si es necesario
                  // Puedes usar un paquete como url_launcher si deseas abrir el enlace en el navegador
                  // launch(redSocial['url']!);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}


// class WebViewPage extends StatelessWidget {
//   final String url;

//   const WebViewPage({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final WebViewController controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Handle progress updates
//           },
//           onPageStarted: (String url) {
//             // Handle page load start
//           },
//           onPageFinished: (String url) {
//             // Handle page load finish
//           },
//           onWebResourceError: (WebResourceError error) {
//             // Handle errors
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(url));

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Navegador'),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }