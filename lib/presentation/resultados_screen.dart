import 'package:flutter/material.dart';
import '../logica/servicio_votacion.dart';
import '../modelos/resultado_opcion.dart';
import 'tema.dart';

class ResultadosScreen extends StatelessWidget {
  final ServicioVotacion servicio;
  final String nombre;
  final bool votoRecienEmitido;

  const ResultadosScreen({
    super.key,
    required this.servicio,
    required this.nombre,
    required this.votoRecienEmitido,
  });

  String _votos(int n) => n == 1 ? '1 voto' : '$n votos';

  @override
  Widget build(BuildContext context) {
    final resultados = servicio.obtenerResultados();
    final total = resultados.fold<int>(0, (suma, r) => suma + r.opcion.votos);
    final ganadores = servicio.determinarGanador();
    final idsGanadores =
        total == 0 ? <String>{} : ganadores.map((o) => o.id).toSet();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
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
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (votoRecienEmitido)
                            Aparecer(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Paleta.turquesa,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      '¡Tu voto fue registrado!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const Text(
                            'Resultados',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ${_votos(total)}',
                            style: const TextStyle(
                              color: Paleta.dorado,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (total == 0)
                  const Aparecer(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Aún no hay votos. ¡Sé la primera persona en votar!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  )
                else
                  Aparecer(
                    child: _TarjetaGanador(
                      titulo: ganadores.length == 1 ? 'Va ganando' : 'Empate',
                      texto: ganadores.map((o) => o.texto).join('  •  '),
                    ),
                  ),
                const SizedBox(height: 8),
                for (var i = 0; i < resultados.length; i++)
                  Aparecer(
                    retrasoMs: 100 + 80 * i,
                    child: _BarraResultado(
                      resultado: resultados[i],
                      esGanador: idsGanadores.contains(resultados[i].opcion.id),
                      etiquetaVotos: _votos(resultados[i].opcion.votos),
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Volver al inicio'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaGanador extends StatelessWidget {
  final String titulo;
  final String texto;
  const _TarjetaGanador({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Paleta.dorado, Color(0xFFF7C95C)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Paleta.dorado.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded,
              size: 44, color: Paleta.azulProfundo),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo.toUpperCase(),
                  style: const TextStyle(
                    color: Paleta.azulProfundo,
                    fontSize: 12,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  texto,
                  style: const TextStyle(
                    color: Paleta.azulProfundo,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarraResultado extends StatelessWidget {
  final ResultadoOpcion resultado;
  final bool esGanador;
  final String etiquetaVotos;

  const _BarraResultado({
    required this.resultado,
    required this.esGanador,
    required this.etiquetaVotos,
  });

  @override
  Widget build(BuildContext context) {
    final colorBarra = esGanador ? Paleta.terracota : Paleta.azul;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: resultado.porcentaje),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, valor, _) {
          final factor = (valor / 100).clamp(0.0, 1.0).toDouble();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      resultado.opcion.texto,
                      style: const TextStyle(
                        color: Paleta.tinta,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${valor.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: colorBarra,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(height: 14, color: Colors.black12),
                    FractionallySizedBox(
                      widthFactor: factor,
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorBarra,
                              colorBarra.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                etiquetaVotos,
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          );
        },
      ),
    );
  }
}