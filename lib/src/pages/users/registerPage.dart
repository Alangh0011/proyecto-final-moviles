import 'package:flutter/material.dart';
import '../../models/usuarios.dart';
import 'loginPage.dart'; 

class RegistroUsuarioScreen extends StatefulWidget {
  const RegistroUsuarioScreen({super.key});

  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _boletaController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      try {
       
        bool boletaExistente = await FirebaseService.boletaExistente(
            _boletaController.text.trim());

        if (boletaExistente) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La boleta ya está registrada.')),
          );
          return;
        }

    
        await FirebaseService.registrarUsuario(
          nombre: _nombreController.text.trim(),
          boleta: _boletaController.text.trim(),
          correo: _correoController.text.trim(),
          contrasena: _contrasenaController.text.trim(),
        );

      
        await _mostrarDialogoExito();

       
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, 
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _mostrarDialogoExito() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Registro Exitoso',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: const Text(
            'Tu cuenta ha sido creada con éxito. Ahora puedes iniciar sesión.',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  //Define un estilo reutilizable para los campos de texto.
  InputDecoration _inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Colors.blue,
          width: 2.0,
        ),
      ),
    );
  }

  //Interfaz de Usuario (Método build)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registro de cuenta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
    
      body: Container(
        color: Colors.white, 
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Nombre:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ))),
                TextFormField(
                  controller: _nombreController,
                  decoration: _inputDecoration('', 'Ingresa tu nombre'),
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor ingresa tu nombre' : null,
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Boleta:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ))),
                TextFormField(
                  controller: _boletaController,
                  decoration: _inputDecoration('', 'Ingresa tu boleta'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu boleta';
                    }
                    if (value.length != 10) {
                      return 'La boleta debe tener exactamente 10 caracteres';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'La boleta debe ser numérica';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Correo electrónico:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ))),
                TextFormField(
                  controller: _correoController,
                  decoration: _inputDecoration(
                      '', 'Ingresa tu correo electrónico'),
                  validator: (value) => value!.isEmpty
                      ? 'Por favor ingresa tu correo'
                      : (!value.contains('@') ? 'Correo inválido' : null),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Contraseña:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ))),
                TextFormField(
                  controller: _contrasenaController,
                  decoration:
                      _inputDecoration('', 'Ingresa tu contraseña'),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'La contraseña debe tener al menos 6 caracteres'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const Text("-o-", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey),),
                GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/registrarprofesor');
              },
              child: const Text(
                'Si eres profesor. Regístrate aquí',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
