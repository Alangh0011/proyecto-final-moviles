import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterProfesorPage extends StatefulWidget {
  const RegisterProfesorPage({super.key});

  @override
  State<RegisterProfesorPage> createState() => _RegisterProfesorPageState();
}

class _RegisterProfesorPageState extends State<RegisterProfesorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _curpController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String? _selectedAcademia; //Almacena la academia seleccionada por el profesor.
  List<DropdownMenuItem<String>> _academias = []; //Manejan la lista de academias obtenidas de Firestore y el estado de carga.
  bool _loadingAcademias = true; //Manejan la lista de academias obtenidas de Firestore y el estado de carga.

  @override
  void initState() {
    super.initState();
    _fetchAcademias(); 
  }

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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) =>
                      false, 
                );
              },
            ),
          ],
        );
      },
    );
  }

  //Cargar academias desde Firestore
  Future<void> _fetchAcademias() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('academias').get();

      final academias = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DropdownMenuItem<String>(
          value: data['academia'], 
          child: Text(data['academia'] ?? ''),
        );
      }).toList();

      setState(() {
        _academias = academias;
        _loadingAcademias = false;
      });
    } catch (e) {
      setState(() {
        _loadingAcademias = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar academias: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _registrarProfesor() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _correoController.text,
          password: _contrasenaController.text,
        );

        await FirebaseFirestore.instance
            .collection('profesores')
            .doc(userCredential.user!.uid)
            .set({
          'nombre': _nombreController.text,
          'matrícula': _matriculaController.text,
          'telefono': _telefonoController.text,
          'correo': _correoController.text,
          'academia': _selectedAcademia,
          'curp': _curpController.text,
          'uid': userCredential.user!.uid,
        });

        await _mostrarDialogoExito();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Registro de profesor",
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nombre:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nombreController,
                  decoration: _inputDecoration('', 'Ingresa tu nombre'),
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor ingresa tu nombre' : null,
                ),
                const SizedBox(height: 24),
                const Text("Número de empleado:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _matriculaController,
                  decoration:
                      _inputDecoration('', 'Ingresa tu número de empleado'),
                  validator: (value) => value!.isEmpty
                      ? 'Por favor ingresa tu número de empleado'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text("Academia",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                /*Si las academias están cargando, muestra un indicador de carga.
                Si ya están disponibles, muestra un desplegable para seleccionar una academia. */
                _loadingAcademias
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        value: _selectedAcademia,
                        items: _academias,
                        onChanged: (value) =>
                            setState(() => _selectedAcademia = value),
                        decoration:
                            _inputDecoration('', 'Selecciona una academia'),
                        validator: (value) => value == null
                            ? 'Por favor selecciona una academia'
                            : null,
                      ),
                const SizedBox(height: 24),
                const Text("Número de teléfono:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _telefonoController,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('', 'Ingresa tu teléfono'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Ingresa un teléfono válido de 10 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text("CURP:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _curpController,
                  maxLength: 18,
                  decoration: _inputDecoration('', 'Ingresa tu CURP'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu CURP';
                    } else if (value.length != 18) {
                      return 'El CURP debe tener exactamente 18 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text("Correo electrónico:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _correoController,
                  decoration: _inputDecoration('', 'Ingresa tu correo'),
                  validator: (value) =>
                      value!.isEmpty ? 'Por favor ingresa tu correo' : null,
                ),
                const SizedBox(height: 24),
                const Text("Contraseña:",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: _inputDecoration('', 'Ingresa tu contraseña'),
                  obscureText: true,
                  validator: (value) => value!.length < 6
                      ? 'La contraseña debe tener al menos 6 caracteres'
                      : null,
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _registrarProfesor,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
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

/*Semejanza con React;

En React, usarías formularios controlados y un hook para manejar la carga inicial de academias

 const [academias, setAcademias] = useState([]);
useEffect(() => {
  const fetchAcademias = async () => {
    const snapshot = await firestore.collection("academias").get();
    setAcademias(snapshot.docs.map(doc => doc.data()));
  };
  fetchAcademias();
}, []);


*/
