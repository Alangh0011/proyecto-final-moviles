import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroHorariosPage extends StatefulWidget {
  const RegistroHorariosPage({super.key});

  @override
  _RegistroHorariosPageState createState() => _RegistroHorariosPageState();
}

class _RegistroHorariosPageState extends State<RegistroHorariosPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreMateriaController = TextEditingController();
  final _grupoController = TextEditingController();
  String? _selectedCarrera;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;

  // Lista de opciones para el DropdownButton
  final List<String> _carreras = ['ISC', 'IA', 'LCD'];
Future<void> _registrarMateria() async {
  // Validación del horario
  if (_horaInicio != null && _horaFin != null) {
    int minutosInicio = _horaInicio!.hour * 60 + _horaInicio!.minute;
    int minutosFin = _horaFin!.hour * 60 + _horaFin!.minute;

    if (minutosInicio >= minutosFin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora de inicio no puede ser mayor o igual a la de fin.')),
      );
      return; // No continuar con el registro si el horario es inválido
    }
  }

  if (_formKey.currentState!.validate()) {
    try {
      // Obtener el usuario autenticado
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Mostrar un mensaje si no hay un usuario autenticado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay usuario autenticado.')),
        );
        return;
      }

      // Consultar la colección "profesores" para obtener el nombre
      DocumentSnapshot<Map<String, dynamic>> profesorSnapshot = await FirebaseFirestore.instance
          .collection('profesores')
          .doc(user.uid)
          .get();

      if (!profesorSnapshot.exists) {
        // Mostrar un mensaje si el profesor no está registrado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró información del profesor.')),
        );
        return;
      }

      String nombreProfesor = profesorSnapshot.data()?['nombre'] ?? 'Desconocido';

      // Asegurar que los minutos siempre tengan dos dígitos
      String horaInicioFormateada = '${_horaInicio!.hour}:${_horaInicio!.minute.toString().padLeft(2, '0')}';
      String horaFinFormateada = '${_horaFin!.hour}:${_horaFin!.minute.toString().padLeft(2, '0')}';

      // Crear un mapa con los datos que quieres guardar en Firestore
      Map<String, dynamic> datosMateria = {
        'nombreMateria': _nombreMateriaController.text.toUpperCase(), // Convertir a mayúsculas
        'grupo': _grupoController.text.toUpperCase(), // Convertir a mayúsculas
        'carrera': _selectedCarrera,
        'horaInicio': horaInicioFormateada,
        'horaFin': horaFinFormateada,
        'profesorAsignado': nombreProfesor, // Nombre del profesor obtenido de Firestore
        'correoProfesor': user.email, // También puedes guardar el correo del profesor
      };

      // Guardar los datos en Firestore
      await FirebaseFirestore.instance.collection('horarios').add(datosMateria);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Materia registrada con éxito.')),
      );

      // Limpiar los campos del formulario
      _nombreMateriaController.clear();
      _grupoController.clear();
      setState(() {
        _selectedCarrera = null;
        _horaInicio = null;
        _horaFin = null;
      });
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la materia: $e')),
      );
    }
  }
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

  Future<void> _seleccionarHoraInicio() async {
    TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null && hora != _horaInicio) {
      setState(() {
        _horaInicio = hora;
      });
    }
  }

  Future<void> _seleccionarHoraFin() async {
    TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null && hora != _horaFin) {
      setState(() {
        _horaFin = hora;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registro de horario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                // Dropdown para seleccionar la carrera
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Carrera:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCarrera,
                  items: _carreras.map((String carrera) {
                    return DropdownMenuItem<String>(
                      value: carrera,
                      child: Text(carrera),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCarrera = newValue;
                    });
                  },
                  decoration: _inputDecoration('', ''),
                  validator: (value) =>
                      value == null ? 'Por favor selecciona una carrera' : null,
                ),
                const SizedBox(height: 24),
                // Campo para el nombre de la materia
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Nombre de la Materia:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                ),
                TextFormField(
                  controller: _nombreMateriaController,
                  decoration:
                      _inputDecoration('', 'Ingresa el nombre de la materia'),
                  validator: (value) => value!.isEmpty
                      ? 'Por favor ingresa el nombre de la materia'
                      : null,
                ),
                const SizedBox(height: 24),
                // Campo para el horario (rango de tiempo)
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Horario de la Materia:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _seleccionarHoraInicio,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _horaInicio != null
                                  ? _horaInicio!.format(context)
                                  : '',
                            ),
                            decoration: _inputDecoration('', 'Hora inicio'),
                            validator: (value) => value!.isEmpty
                                ? 'Por favor ingresa la hora de inicio'
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("a",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: _seleccionarHoraFin,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _horaFin != null
                                  ? _horaFin!.format(context)
                                  : '',
                            ),
                            decoration: _inputDecoration('', 'Hora fin'),
                            validator: (value) => value!.isEmpty
                                ? 'Por favor ingresa la hora de fin'
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Campo para el grupo
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("Grupo de la Materia:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      )),
                ),
                TextFormField(
                  controller: _grupoController,
                  decoration:
                      _inputDecoration('', 'Ingresa el grupo de la materia'),
                  validator: (value) => value!.isEmpty
                      ? 'Por favor ingresa el grupo de la materia'
                      : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _registrarMateria,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Registrar horario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
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
