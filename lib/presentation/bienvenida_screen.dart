import 'package:flutter/material.dart';
import '../logica/servicio_votacion.dart';
import 'resultados_screen.dart';
import 'tema.dart';
import 'votar_screen.dart';

class BienvenidaScreen extends StatefulWidget {
  final ServicioVotacion servicio;
  const BienvenidaScreen({super.key, required this.servicio});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final _controlador = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final nombre = _controlador.text.trim();
    if (nombre.isEmpty) {
      setState(() => _error = 'Escribe tu nombre para continuar');
      return;
    }
    setState(() => _error = null);
    await Navigator.of(context).push(
      rutaSuave(VotarScreen(
        servicio: widget.servicio,
        idUsuario: nombre.toLowerCase(),
        nombre: nombre,
      )),
    );
    if (mounted) _controlador.clear();
  }

  void _verResultados() {
    Navigator.of(context).push(
      rutaSuave(ResultadosScreen(
        servicio: widget.servicio,
        nombre: '',
        votoRecienEmitido: false,
      )),
    );
  }

  String _fecha(DateTime f) {
    const meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final hora = f.hour.toString().padLeft(2, '0');
    final min = f.minute.toString().padLeft(2, '0');
    return '${f.day} ${meses[f.month - 1]} ${f.year}, $hora:$min';
  }

  Widget _circulo(double tamano, Color color) => Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  @override
  Widget build(BuildContext context) {
    final votacion = widget.servicio.votacion;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: fondoHeroe),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: _circulo(240, Paleta.dorado.withValues(alpha: 0.18)),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: _circulo(280, Paleta.terracota.withValues(alpha: 0.16)),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Aparecer(
                          child: Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.10),
                              border: Border.all(color: Paleta.dorado, width: 3),
                            ),
                            child: const Icon(
                              Icons.how_to_vote_rounded,
                              size: 54,
                              color: Paleta.dorado,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Aparecer(
                          retrasoMs: 100,
                          child: Text(
                            'Vota\nDolores Hidalgo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Aparecer(
                          retrasoMs: 200,
                          child: Text(
                            'CUNA DE LA INDEPENDENCIA',
                            style: TextStyle(
                              color: Paleta.dorado,
                              fontSize: 13,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Aparecer(
                          retrasoMs: 300,
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Paleta.terracota
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'PLEBISCITO',
                                    style: TextStyle(
                                      color: Paleta.terracota,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  votacion.pregunta,
                                  style: const TextStyle(
                                    color: Paleta.tinta,
                                    fontSize: 21,
                                    height: 1.25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.event_rounded,
                                        size: 18, color: Paleta.turquesa),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Cierra el ${_fecha(votacion.fechaCierre)}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _controlador,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _entrar(),
                                  decoration: InputDecoration(
                                    hintText: 'Tu nombre',
                                    errorText: _error,
                                    prefixIcon:
                                        const Icon(Icons.person_rounded),
                                    filled: true,
                                    fillColor: const Color(0xFFF4F1EA),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  onPressed: _entrar,
                                  icon: const Icon(Icons.arrow_forward_rounded),
                                  label: const Text('Entrar a votar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Aparecer(
                          retrasoMs: 400,
                          child: TextButton.icon(
                            onPressed: _verResultados,
                            icon: const Icon(Icons.bar_chart_rounded,
                                color: Colors.white),
                            label: const Text(
                              'Ver resultados',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}