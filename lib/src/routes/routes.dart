import 'package:flutter/material.dart';
import 'package:proyecto_final_moviles/src/pages/careers/iaPage.dart';
import 'package:proyecto_final_moviles/src/pages/careers/iscPage.dart';
import 'package:proyecto_final_moviles/src/pages/careers/lcdPage.dart';
import 'package:proyecto_final_moviles/src/pages/careers/mccdPage.dart';
import 'package:proyecto_final_moviles/src/pages/careers/mciia.dart';
import 'package:proyecto_final_moviles/src/pages/careers/mcscmPage.dart';
import 'package:proyecto_final_moviles/src/pages/principal/paginaPrincipalPage.dart';
import 'package:proyecto_final_moviles/src/pages/principal/paginaPrincipalProfesores.dart';
import 'package:proyecto_final_moviles/src/pages/users/perfilPage.dart';
import 'package:proyecto_final_moviles/src/pages/users/perfilPageProfesores.dart';
import 'package:proyecto_final_moviles/src/pages/users/registerPage.dart';
import 'package:proyecto_final_moviles/src/pages/users/registerProfesorPage.dart';
import 'package:proyecto_final_moviles/src/pages/users/registroHorarios.dart';
import 'package:proyecto_final_moviles/src/pages/users/vistaAlumnos.dart';
import 'package:proyecto_final_moviles/src/pages/users/vistaHorarios.dart';
import 'package:proyecto_final_moviles/src/pages/users/vistaProfesores.dart';
import '../pages/users/loginPage.dart';

class AppRoutes {
  // Rutas estáticas
  static const String login = '/login';
  static const String register = '/registrar';
  static const String pagprincipal = '/pagina_principal';
  static const String perfil = '/perfil';
  static const String perfilProfesor = '/perfilProfesor';
  static const String registrarprofesor = '/registrarprofesor';
  static const String pagprincipalprof = '/pagina_profesor';
  static const String isc = '/isc';
  static const String ia = '/ia';
  static const String lcd = '/lcd';
  static const String mcscm = '/mcscm';
  static const String mciia = '/mciia';
  static const String mccd = '/mccd';
  static const String vistaProfesores = '/vistaProfesores';
  static const String vistaAlumnos = '/vistaAlumnos';
  static const String vistaHorarios = '/vistaHorarios';
  static const String registroHorarios = '/registroHorarios';

  // Mapa de rutas
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginPage(),
      register: (context) => const RegistroUsuarioScreen(),
      pagprincipal: (context) => const PaginaPrincipalPage(),
      perfil: (context) => const PerfilPage(),
      perfilProfesor: (context) => const PerfilPageProfesores(),
      registrarprofesor: (context) => const RegisterProfesorPage(),
      pagprincipalprof: (context) => const PaginaPrincipalProfesoresPage(),
      isc: (context) => const IscPage(),
      ia: (context) => const iaPage(),
      lcd: (context) => const LcdPage(),
      mcscm: (context) => const McscmPage(),
      mciia: (context) => const MciiaPage(),
      mccd: (context) => const MccdPage(),
      vistaProfesores: (context) => const VistaProfesoresPage(),
      vistaAlumnos: (context) => const VistaAlumnosPage(),
      vistaHorarios: (context) => const VistaHorariosPage(),
      registroHorarios: (context) => const RegistroHorariosPage()

    };
  }
}
