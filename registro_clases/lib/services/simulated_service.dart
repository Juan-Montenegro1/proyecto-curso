import 'dart:async';

class SimulatedService {
  // Simula una consulta que tarda entre 2 y 3 segundos y retorna una lista de strings
  // Si throwError es true, lanzará una excepción para simular un error de red
  Future<List<String>> fetchNames({bool throwError = false}) async {
    debugPrint('SimulatedService: started fetchNames');
    // Simular trabajo intermedio
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('SimulatedService: still working... (500ms elapsed)');

    // Retardo principal entre 2 y 3 segundos (usar 2s para demo)
    await Future.delayed(const Duration(seconds: 2));

    if (throwError) {
      debugPrint('SimulatedService: about to throw an error');
      throw Exception('Simulated error during fetch');
    }

    debugPrint('SimulatedService: completed fetchNames successfully');

    return [
      'Juan',
      'María',
      'Carlos',
      'Lucía',
    ];
  }
}

// A small helper for logging that uses Flutter's debugPrint when available
void debugPrint(String message) {
  // Use zone-independent print to ensure output in console
  // Keep it simple to avoid importing flutter here
  // ignore: avoid_print
  print(message);
}
