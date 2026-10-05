import 'package:flutter/material.dart';
import '../logica/resultado_voto.dart';
import '../logica/servicio_votacion.dart';
import '../modelos/opcion_votacion.dart';
import 'resultados_screen.dart';
import 'tema.dart';

class VotarScreen extends StatefulWidget {
  final ServicioVotacion servicio;
  final String idUsuario;
  final String nombre;

  const VotarScreen({
    super.key,
    required this.servicio,
    required this.idUsuario,
    required this.nombre,
  });

  @override
  State<VotarScreen> createState() => _VotarScreenState();
}

class _VotarScreenState extends State<VotarScreen> {
  String? _seleccion;

  void _aviso(String mensaje, IconData icono, Color color,
      {SnackBarAction? accion}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          action: accion,
          content: Row(
            children: [
              Icon(icono, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(mensaje)),
            ],
          ),
        ),
      );
  }

  void _irAResultados({required bool recienVoto}) {
    Navigator.of(context).pushReplacement(
      rutaSuave(ResultadosScreen(
        servicio: widget.servicio,
        nombre: widget.nombre,
        votoRecienEmitido: recienVoto,
      )),
    );
  }

  void _votar() {
    final idOpcion = _seleccion;
    if (idOpcion == null) return;

    final resultado = widget.servicio.registrarVoto(
      idUsuario: widget.idUsuario,
      idOpcion: idOpcion,
    );

    switch (resultado) {
      case ResultadoVoto.exitoso:
        _irAResultados(recienVoto: true);
      case ResultadoVoto.usuarioYaVoto:
        _aviso(
          'Ya emitiste tu voto, ${widget.nombre}.',
          Icons.info_rounded,
          Paleta.azul,
          accion: SnackBarAction(
            label: 'VER RESULTADOS',
            textColor: Paleta.dorado,
            onPressed: () => _irAResultados(recienVoto: false),
          ),
        );
      case ResultadoVoto.votacionCerrada:
        _aviso(
          'La votación ya cerró.',
          Icons.lock_clock_rounded,
          Paleta.terracota,
          accion: SnackBarAction(
            label: 'VER RESULTADOS',
            textColor: Colors.white,
            onPressed: () => _irAResultados(recienVoto: false),
          ),
        );
      case ResultadoVoto.opcionInvalida:
        _aviso(
          'Esa opción no es válida.',
          Icons.error_rounded,
          Paleta.terracota,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final votacion = widget.servicio.votacion;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: fondoHeroe,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, ${widget.nombre}',
                            style: const TextStyle(
                              color: Paleta.dorado,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            votacion.pregunta,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: votacion.opciones.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final opcion = votacion.opciones[i];
                return Aparecer(
                  retrasoMs: 80 * i,
                  child: _TarjetaOpcion(
                    opcion: opcion,
                    letra: String.fromCharCode(65 + i),
                    seleccionada: _seleccion == opcion.id,
                    onTap: () => setState(() => _seleccion = opcion.id),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: FilledButton.icon(
                onPressed: _seleccion == null ? null : _votar,
                icon: const Icon(Icons.how_to_vote_rounded),
                label: const Text('Emitir mi voto'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaOpcion extends StatelessWidget {
  final OpcionVotacion opcion;
  final String letra;
  final bool seleccionada;
  final VoidCallback onTap;

  const _TarjetaOpcion({
    required this.opcion,
    required this.letra,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: seleccionada ? Paleta.azul : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: seleccionada ? Paleta.dorado : Colors.black12,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: seleccionada ? 0.18 : 0.06),
            blurRadius: seleccionada ? 18 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: seleccionada
                      ? Paleta.dorado
                      : Paleta.azul.withValues(alpha: 0.10),
                  child: Text(
                    letra,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: seleccionada ? Paleta.azulProfundo : Paleta.azul,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    opcion.texto,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: seleccionada ? Colors.white : Paleta.tinta,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: seleccionada
                      ? const Icon(Icons.check_circle_rounded,
                          key: ValueKey('on'), color: Paleta.dorado)
                      : const Icon(Icons.circle_outlined,
                          key: ValueKey('off'), color: Colors.black26),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}