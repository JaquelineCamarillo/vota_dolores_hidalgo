import 'package:flutter/material.dart';
import 'logica/servicio_votacion.dart';
import 'modelos/opcion_votacion.dart';
import 'modelos/votacion.dart';
import 'presentation/bienvenida_screen.dart';
import 'presentation/tema.dart';

void main() {
  final votacion = Votacion(
    pregunta: '¿Qué proyecto debería recibir el presupuesto participativo?',
    opciones: [
      OpcionVotacion(id: 'parque', texto: 'Rehabilitar el parque central'),
      OpcionVotacion(id: 'luz', texto: 'Alumbrado público en colonias'),
      OpcionVotacion(id: 'bici', texto: 'Ciclovía a la zona histórica'),
    ],
    fechaCierre: DateTime.now().add(const Duration(days: 7)),
  );

  runApp(VotaDoloresApp(servicio: ServicioVotacion(votacion)));
}

class VotaDoloresApp extends StatelessWidget {
  final ServicioVotacion servicio;
  const VotaDoloresApp({super.key, required this.servicio});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vota Dolores Hidalgo',
      debugShowCheckedModeBanner: false,
      theme: construirTema(),
      home: BienvenidaScreen(servicio: servicio),
    );
  }
}