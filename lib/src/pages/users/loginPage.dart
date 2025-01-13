import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  Future<void> _iniciarSesion(BuildContext context) async {
    try {
      // Inicia sesión con el correo y contraseña
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _contrasenaController.text.trim(),
      );

      User? usuario = userCredential.user;

      if (usuario != null) {
        String uid = usuario.uid;

        // Verificar a qué colección pertenece el usuario
        String tipoUsuario = await _verificarColeccionUsuario(uid);

        // Obtener el nombre del usuario para el mensaje de bienvenida
        String nombre = await _obtenerNombreUsuario(uid, tipoUsuario);

        // Mostrar mensaje de bienvenida
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bienvenido, $nombre!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Redirigir a la página correspondiente
        if (tipoUsuario == 'usuario') {
          Navigator.pushNamed(context, '/pagina_principal');
        } else if (tipoUsuario == 'profesor') {
          Navigator.pushNamed(context, '/pagina_profesor');
        } else {
          // Usuario no encontrado en ninguna colección
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se encontró al usuario en ninguna colección.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Manejo de errores en la autenticación
      String errorMessage = 'Error desconocido';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuario no encontrado. Por favor revisa tu correo.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta. Intenta nuevamente.';
            break;
          case 'invalid-email':
            errorMessage = 'Correo inválido. Asegúrate de ingresar un correo válido.';
            break;
          case 'network-request-failed':
            errorMessage = 'Error de conexión. Verifica tu red.';
            break;
          default:
            errorMessage = 'Hubo un error al intentar iniciar sesión. Intenta más tarde.';
        }
      } else {
        errorMessage = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Función para verificar a qué colección pertenece el usuario
  Future<String> _verificarColeccionUsuario(String uid) async {
    try {
      // Busca en la colección "usuarios"
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
      if (usuarioDoc.exists) {
        return 'usuario'; // Pertenece a "usuarios"
      }

      // Busca en la colección "profesores"
      DocumentSnapshot profesorDoc = await FirebaseFirestore.instance.collection('profesores').doc(uid).get();
      if (profesorDoc.exists) {
        return 'profesor'; // Pertenece a "profesores"
      }

      // No pertenece a ninguna colección
      return 'desconocido';
    } catch (e) {
      print('Error al verificar la colección del usuario: $e');
      return 'error';
    }
  }

  /// Función para obtener el nombre del usuario
  Future<String> _obtenerNombreUsuario(String uid, String tipoUsuario) async {
    try {
      if (tipoUsuario == 'usuario') {
        // Busca en la colección "usuarios"
        DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
        return usuarioDoc['nombre'] ?? 'Usuario';
      } else if (tipoUsuario == 'profesor') {
        // Busca en la colección "profesores"
        DocumentSnapshot profesorDoc = await FirebaseFirestore.instance.collection('profesores').doc(uid).get();
        return profesorDoc['nombre'] ?? 'Profesor';
      }
      return 'Desconocido';
    } catch (e) {
      print('Error al obtener el nombre del usuario: $e');
      return 'Usuario';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'ESCOM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 40.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'ESCOMUNIDAD',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/registrar');
                    
                  },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate aquí',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                    const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _iniciarSesion(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.blue,
                  ),

                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
