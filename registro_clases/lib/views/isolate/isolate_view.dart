import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  String resultado = "Presiona el botón para ejecutar";
  double _progress = 0.0; // 0..1
  int _workSize = 5000000; // tamaño por defecto de la tarea (N)

  //!Función que ejecuta la tarea pesada en un Isolate
  //es Future<void> porque se ejecuta en un hilo secundario
  //Future se usa para ejecutar tareas asincronas
  Future<void> isolateTask() async {
    setState(() {
      resultado = 'Iniciando isolate...';
      _progress = 0.0;
    });
    // If running on the web, dart:isolate is not supported. Use a chunked
    // computation fallback that yields periodically to the event loop so the
    // UI remains responsive and we can report progress.
    if (kIsWeb) {
      // Web fallback: compute in chunks and report progress
      final result = await _int64SumChunkedOnMainThread(_workSize, (progressValue) {
        if (!mounted) return;
        setState(() {
          _progress = progressValue;
          resultado = 'Progreso: ${(progressValue * 100).toStringAsFixed(1)}%';
        });
      });

      if (!mounted) return;
      setState(() {
        _progress = 1.0;
        resultado = 'Tarea completada (web fallback). Resultado: $result';
      });
      return;
    }

    final receivePort = ReceivePort(); // para recibir el SendPort del isolate

    // Spawn del isolate
    await Isolate.spawn(_heavyComputeIsolate, receivePort.sendPort);

    // Recibir el sendPort del isolate
    final sendPort = await receivePort.first as SendPort;

    // Canal para recibir progresos y resultado
    final response = ReceivePort();

    // Enviar la tarea: [workSize, replyPort]
    sendPort.send([_workSize, response.sendPort]);

    // Escuchar mensajes del isolate (puede enviar múltiples: progress + done)
    await for (final message in response) {
      if (message is Map) {
        final type = message['type'] as String?;
        if (type == 'progress') {
          final progressValue = message['progress'] as double? ?? 0.0;
          if (!mounted) continue;
          setState(() {
            _progress = progressValue;
            resultado = 'Progreso: ${(progressValue * 100).toStringAsFixed(1)}%';
          });
        } else if (type == 'done') {
          final res = message['result'];
          if (!mounted) break;
          setState(() {
            _progress = 1.0;
            resultado = 'Tarea completada. Resultado: $res';
          });
          break; // salir del listener
        }
      } else if (message is String) {
        // Compatibilidad con mensajes simples
        if (!mounted) continue;
        setState(() {
          resultado = message;
        });
      }
    }

    // Cerrar el puerto de respuesta
    response.close();
    receivePort.close();
  }

  // Fallback computation for web: chunked sum with periodic yields
  static Future<int> _int64SumChunkedOnMainThread(int n, void Function(double) onProgress) async {
    final int reportChunks = 20;
    final int chunk = (n / reportChunks).ceil();
    int sum = 0;
    for (int i = 1; i <= n; i++) {
      sum += i;
      if (i % chunk == 0 || i == n) {
        final progress = i / n;
        onProgress(progress);
        // yield to event loop so UI can update
        await Future.delayed(const Duration(milliseconds: 1));
      }
    }
    return sum;
  }

  //!simulacionTareaPesada es una función que simula una tarea pesada en un Isolate
  // *SendPort es un canal de comunicación unidireccional que se puede usar para enviar mensajes a un Isolate.
  // Isolate que realiza la suma pesada y envía progresos
  static void _heavyComputeIsolate(SendPort sendPort) {
    final port = ReceivePort();
    // Enviar el sendPort del isolate al principal
    sendPort.send(port.sendPort);

    port.listen((message) {
      // message esperado: [int workSize, SendPort replyPort]
      final workSize = message[0] as int;
      final replyPort = message[1] as SendPort;

      // Realizar suma en bloques y reportar progreso
      int64Sum(workSize, replyPort);

      // cerrar puerto y salir
      port.close();
      Isolate.exit();
    });
  }

  // Helper que hace la suma en enteros grandes y reporta progreso
  static void int64Sum(int n, SendPort replyPort) {
    // Para evitar bloqueos demasiado largos sin mensajes, enviamos progreso cada cierto intervalo
    final int reportChunks = 20; // cuántos updates queremos al final
    final int chunk = (n / reportChunks).ceil();

    // Usamos num (int) que en Dart es arbitrariamente grande
    int sum = 0;
    for (int i = 1; i <= n; i++) {
      sum += i;
      if (i % chunk == 0 || i == n) {
        final progress = i / n;
        replyPort.send({'type': 'progress', 'progress': progress});
      }
    }

    replyPort.send({'type': 'done', 'result': sum});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Demo de Isolate",
      body: Center(
        child: Padding(
          //Padding es un widget que añade espacio alrededor de su hijo.
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(resultado, textAlign: TextAlign.center),
              const SizedBox(height: 12),

              // Barra de progreso
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 12),

              // Entrada para tamaño del trabajo
              Row(
                children: [
                  const Expanded(
                    child: Text('Tamaño de tarea (n):', style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      initialValue: _workSize.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      onChanged: (v) {
                        final parsed = int.tryParse(v.replaceAll(',', '').trim());
                        if (parsed != null && parsed > 0) {
                          setState(() {
                            _workSize = parsed;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: isolateTask,
                child: const Text("Ejecutar tarea en segundo plano"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
