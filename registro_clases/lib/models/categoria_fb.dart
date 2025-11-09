class CategoriaFb {
  final String id;
  final String nombre;
  final String descripcion;
  final String direccion;
  final String paginaWeb;
  final String telefono;
  final String nit;

  CategoriaFb({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.direccion = '',
    this.paginaWeb = '',
    this.telefono = '',
    this.nit = '',
  });

  factory CategoriaFb.fromMap(String id, Map<String, dynamic> data) {
    return CategoriaFb(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      direccion: data['direccion'] ?? '',
      paginaWeb: data['pagina_web'] ?? data['paginaWeb'] ?? '',
      telefono: data['telefono'] ?? '',
      nit: data['nit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'direccion': direccion,
      'pagina_web': paginaWeb,
      'telefono': telefono,
      'nit': nit,
    };
  }
}
