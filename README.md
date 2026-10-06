# Vota Dolores Hidalgo 🗳️

App de **plebiscito ciudadano** para Dolores Hidalgo, Guanajuato, desarrollada en **Flutter** siguiendo la metodología **TDD (Test-Driven Development)**: primero se escribe la prueba que falla, luego el código mínimo para pasarla y al final se refactoriza.

**Autora:** Juana Jaqueline Camarillo Olaez
**Institución:** Universidad Tecnológica del Norte de Guanajuato (UTNG) — Grupo GIDS6102-E

---

## ¿Qué hace la app?

- Muestra una pregunta de plebiscito con varias opciones.
- Cada persona puede votar **una sola vez**.
- No se aceptan votos después de la **fecha de cierre**.
- Los resultados se muestran en porcentajes, con barras animadas y el ganador (o el empate).

## Reglas de negocio (cubiertas con pruebas)

| Ronda | Regla | Resultado esperado |
|---|---|---|
| 1 | Voto válido | `ResultadoVoto.exitoso` y se suma 1 voto |
| 2 | Opción inexistente | `ResultadoVoto.opcionInvalida` |
| 3 | Persona que ya votó | `ResultadoVoto.usuarioYaVoto` |
| 4 | Porcentajes (incluye caso con 0 votos) | Suma coherente, sin dividir entre cero |
| 5 | Ganador | La opción con más votos |
| 6 | Empate | Se devuelven todas las opciones empatadas |
| 7 | Votación cerrada / abierta | `ResultadoVoto.votacionCerrada` o `exitoso` |
| 8 | Refactor | Cláusulas de guarda y código más legible, sin romper pruebas |
| — | Prueba de integración | Simulación completa de una votación |
| **RETO** | **Reloj inyectado** | El cierre se prueba sin depender de la fecha del sistema |

### RETO: reloj inyectado

`ServicioVotacion` recibe opcionalmente una función `DateTime Function() ahora`. Por defecto usa `DateTime.now`, pero en las pruebas se le pasa una hora fija:

```dart
final servicio = ServicioVotacion(
  votacion,
  ahora: () => DateTime(2030, 1, 1, 17, 59),
);
```

Así se prueba que un voto un minuto antes del cierre es válido, que un voto justo en el instante del cierre todavía cuenta y que un voto un segundo después se rechaza. Las pruebas son deterministas y no dependen del reloj de la computadora.

## Arquitectura

```
lib/
  main.dart                     # Punto de entrada y datos de la votación
  modelos/
    opcion_votacion.dart        # id, texto, votos
    votacion.dart               # pregunta, opciones, fechaCierre, votantes
    resultado_opcion.dart       # opción + porcentaje
  logica/
    resultado_voto.dart         # enum ResultadoVoto
    servicio_votacion.dart      # reglas de negocio (sin dependencias de UI)
  presentation/
    tema.dart                   # paleta, tema, animaciones reutilizables
    bienvenida_screen.dart      # pantalla 1: bienvenida y nombre
    votar_screen.dart           # pantalla 2: elegir y emitir voto
    resultados_screen.dart      # pantalla 3: resultados y ganador
test/
  servicio_votacion_test.dart   # 14 pruebas
docs/capturas/                  # evidencias (tests y app corriendo)
```

La lógica está separada de la interfaz, por lo que se prueba sin levantar ningún widget.



## Cómo correr las pruebas

```
flutter test
```

Resultado esperado: `All tests passed!` (14 pruebas).

---

## Evidencias

### Pruebas pasando

<img width="770" height="68" alt="image" src="https://github.com/user-attachments/assets/84e585ce-bd6e-4c6d-8522-577bb01b33f8" />


### App corriendo

| Bienvenida | Votar | Resultados |
|---|---|---|
| <img width="620" height="975" alt="image" src="https://github.com/user-attachments/assets/b4cc06c1-e9c2-46bf-b9da-d76a3687cadc" /> | <img width="622" height="880" alt="image" src="https://github.com/user-attachments/assets/4a6eca03-7ec8-4809-9e5a-8de232fd1843" /> | <img width="622" height="881" alt="image" src="https://github.com/user-attachments/assets/93302553-1666-493a-a9c0-e9d52b6f464d" /> |
|---|<img width="635" height="887" alt="image" src="https://github.com/user-attachments/assets/b0f37b32-d499-4316-b943-4af033317e41" /> | <img width="627" height="937" alt="image" src="https://github.com/user-attachments/assets/a9419c8b-a0dd-444b-9c00-91e4ef3e285a" /> |
 

---

## Posibles mejoras

- Límite máximo de votantes.
- Modo de voto anónimo.
- Persistencia de los votos con `shared_preferences` o Firebase.
- Animación de confeti para el ganador.
