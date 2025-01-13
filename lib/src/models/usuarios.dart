import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  // Verificar si la boleta ya existe
  static Future<bool> boletaExistente(String boleta) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('boleta', isEqualTo: boleta)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar la boleta: $e');
    }
  }

  // Verificar si el correo ya existe
  static Future<bool> correoExistente(String correo) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: correo)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar el correo: $e');
    }
  }

  static Future<bool> matriculaExistente(String matricula) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('profesores')
          .where('matricula', isEqualTo: matricula)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar la matrícula: $e');
    }
  }

  // Verificar si el correo ya existe
  static Future<bool> correoProfesorExistente(String correo) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('profesores')
          .where('correo', isEqualTo: correo)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar el correo: $e');
    }
  }

  // Método para registrar usuarios
  static Future<void> registrarUsuario({
    required String nombre,
    required String boleta,
    required String correo,
    required String contrasena,
  }) async {
    try {
      bool boletaExiste = await boletaExistente(boleta);
      if (boletaExiste) {
        throw Exception('La boleta ya está registrada');
      }

      bool correoExiste = await correoExistente(correo);
      if (correoExiste) {
        throw Exception('El correo ya está registrado');
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set({
        'nombre': nombre,
        'boleta': boleta,
        'correo': correo,
        'uid': userCredential.user!.uid,
      });
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  // Método para iniciar sesión
  static Future<User?> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: correo, password: contrasena);
      return userCredential.user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  static Future<void> registrarProfesor({
    required String nombre,
    required String matricula,
    required String correo,
    required String contrasena,
    required String academia,
    required String curp,
    required String telefono,
  }) async {
    try {
      bool matriculaExiste = await matriculaExistente(matricula);
      if (matriculaExiste) {
        throw Exception('La matrícula ya está registrada');
      }

      bool correoExiste = await correoProfesorExistente(correo);
      if (correoExiste) {
        throw Exception('El correo ya está registrado');
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      await FirebaseFirestore.instance
          .collection('profesores')
          .doc(userCredential.user!.uid)
          .set({
        'nombre': nombre,
        'matricula': matricula,
        'correo': correo,
        'academia': academia,
        'curp': curp,
        'telefono': telefono,
        'uid': userCredential.user!.uid,
      });
    } catch (e) {
      throw Exception('Error al registrar profesor: $e');
    }
  }
}
