import 'package:flutter/material.dart';
import './src/routes/routes.dart';
import './src/config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();// Asegura que Flutter esté completamente inicializado antes de ejecutar el código asíncrono, como la inicialización de Firebase.
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto final',
      initialRoute: AppRoutes.login, // Ruta inicial
      routes: AppRoutes.getRoutes(), // Importar rutas desde el archivo
    );
  }
}
