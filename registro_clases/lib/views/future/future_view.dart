import 'dart:async';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

import '../../widgets/base_view.dart';
import '../../services/simulated_service.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  List<String> _nombres = []; 
  String _statusMessage = '';
  bool _isLoading = false;
  bool _isError = false;
  final SimulatedService _service = SimulatedService();
  
  // Permitir forzar un error desde la UI para probar el flujo de Error
  bool _simulateError = false;
  // Timer 
  Timer? _timer;
  Duration _elapsed = Duration.zero; 
  bool _isRunning = false;

  final Duration _tick = const Duration(seconds: 1);

  @override
  // !inicializa el estado
  void initState() {
    super.initState();
    obtenerDatos(); // carga al iniciar
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
  Future<void> obtenerDatos() async {
  if (foundation.kDebugMode) foundation.debugPrint('UI: antes de llamar al servicio (before await)');

    setState(() {
      _isLoading = true;
      _isError = false;
      _statusMessage = 'Cargando...';
    });

    try {
  // Llamada async al servicio simulado
  final datos = await _service.fetchNames(throwError: _simulateError);

  if (foundation.kDebugMode) foundation.debugPrint('UI: después de await (after await) - datos recibidos: ${datos.length}');

      if (!mounted) return;
      setState(() {
        _nombres = datos;
        _isLoading = false;
        _statusMessage = 'Éxito - ${datos.length} elementos recibidos';
      });
    } catch (e) {
  if (foundation.kDebugMode) foundation.debugPrint('UI: captura de error después de await: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isError = true;
        _statusMessage = 'Error al cargar datos';
      });
    } finally {
  if (foundation.kDebugMode) foundation.debugPrint('UI: finally - la llamada ha finalizado');
    }
  }

  void _startTimer() {
  if (_isRunning) return;
  if (foundation.kDebugMode) foundation.debugPrint('Timer: iniciar');
    _timer = Timer.periodic(_tick, (t) {
      setState(() {
        _elapsed += _tick;
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
  if (!_isRunning) return;
  if (foundation.kDebugMode) foundation.debugPrint('Timer: pausar');
    _cancelTimer();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
  if (_isRunning) return;
  if (foundation.kDebugMode) foundation.debugPrint('Timer: reanudar');
    _startTimer();
  }

  void _resetTimer() {
  if (foundation.kDebugMode) foundation.debugPrint('Timer: reiniciar');
    _cancelTimer();
    setState(() {
      _elapsed = Duration.zero;
      _isRunning = false;
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Futures - GridView',
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color.fromARGB(255, 58, 139, 168),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      // Mostrar HH:MM:SS
                      _formatDuration(_elapsed),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _isRunning ? null : _startTimer,
                          child: const Text('Iniciar'),
                        ),
                        ElevatedButton(
                          onPressed: _isRunning ? _pauseTimer : null,
                          child: const Text('Pausar'),
                        ),
                        ElevatedButton(
                          onPressed: !_isRunning && _elapsed > Duration.zero ? _resumeTimer : null,
                          child: const Text('Reanudar'),
                        ),
                        ElevatedButton(
                          onPressed: _elapsed > Duration.zero ? _resetTimer : null,
                          child: const Text('Reiniciar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Control para simular error (testing)
            SwitchListTile(
              title: const Text('Simular error'),
              value: _simulateError,
              onChanged: (v) {
                setState(() {
                  _simulateError = v;
                });
              },
            ),

            // Estado
            Card(
              color: _isError ? Colors.red[100] : Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _statusMessage.isEmpty ? 'Presiona recargar para iniciar' : _statusMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isError ? Colors.red[900] : Colors.blue[900],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botón para recargar manualmente
            ElevatedButton.icon(
              onPressed: _isLoading ? null : obtenerDatos,
              icon: const Icon(Icons.refresh),
              label: const Text('Recargar'),
            ),

            const SizedBox(height: 12),

            // Contenido principal
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isError
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.error_outline, size: 48, color: Colors.red),
                              SizedBox(height: 8),
                              Text('Ocurrió un error al cargar los datos'),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: _nombres.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // columnas
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Card(
                              color: const Color.fromARGB(255, 87, 194, 180),
                              child: Center(
                                child: Text(
                                  _nombres[index], // muestra el nombre en la posicion index
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
