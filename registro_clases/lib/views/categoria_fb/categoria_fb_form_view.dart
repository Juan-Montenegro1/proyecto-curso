import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/categoria_fb.dart';
import '../../services/categoria_service.dart';

class CategoriaFbFormView extends StatefulWidget {
  final String? id;

  const CategoriaFbFormView({super.key, this.id});

  @override
  State<CategoriaFbFormView> createState() => _CategoriaFbFormViewState();
}

class _CategoriaFbFormViewState extends State<CategoriaFbFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _paginaWebController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _nitController = TextEditingController();
  bool _camposInicializados = false;

  Future<void> _guardar({String? id}) async {
    if (_formKey.currentState!.validate()) {
      try {
        final categoria = CategoriaFb(
          id: id ?? '',
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          direccion: _direccionController.text.trim(),
          paginaWeb: _paginaWebController.text.trim(),
          telefono: _telefonoController.text.trim(),
          nit: _nitController.text.trim(),
        );

        if (widget.id == null) {
          await CategoriaService.addCategoria(categoria);
        } else {
          await CategoriaService.updateCategoria(categoria);
        }

        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.id == null
                    ? 'Universidad creada exitosamente'
                    : 'Universidad actualizada exitosamente',
              ),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _inicializarCampos(CategoriaFb categoria) {
    if (_camposInicializados) return;
    _nombreController.text = categoria.nombre;
    _descripcionController.text = categoria.descripcion;
    _direccionController.text = categoria.direccion;
    _paginaWebController.text = categoria.paginaWeb;
    _telefonoController.text = categoria.telefono;
    _nitController.text = categoria.nit;
    _camposInicializados = true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _paginaWebController.dispose();
    _telefonoController.dispose();
    _nitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esNuevo = widget.id == null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Crear Universidad' : 'Editar Universidad'),
      ),
      body: esNuevo
          ? _buildFormulario(context, id: null)
          : StreamBuilder<CategoriaFb?>(
              stream: CategoriaService.watchCategoriaById(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar universidad',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_off_outlined,
                          size: 60,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Universidad no encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                final categoria = snapshot.data!;
                _inicializarCampos(categoria);
                return _buildFormulario(context, id: categoria.id);
              },
            ),
    );
  }

  Widget _buildFormulario(BuildContext context, {required String? id}) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determinar el ancho máximo según el tamaño del dispositivo
    final double maxWidth = screenWidth > 1200
        ? 800 // Desktop grande
        : screenWidth > 800
        ? 600 // Tablet/Desktop pequeño
        : double.infinity; // Móvil

    // Padding adaptativo
    final double horizontalPadding = screenWidth > 600 ? 24 : 16;
    final double cardPadding = screenWidth > 600 ? 24 : 16;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card con el formulario
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información básica',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            hintText: 'Ingresa el nombre de la universidad',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es requerido';
                            }
                            if (value.trim().length < 3) {
                              return 'El nombre debe tener al menos 3 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descripcionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Ingresa una descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La descripción es requerida';
                            }
                            if (value.trim().length < 10) {
                              return 'La descripción debe tener al menos 10 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _direccionController,
                          decoration: InputDecoration(
                            labelText: 'Dirección',
                            hintText: 'Ingresa la dirección',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _paginaWebController,
                          decoration: InputDecoration(
                            labelText: 'Página Web',
                            hintText: 'https://ejemplo.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            hintText: 'Número de contacto',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nitController,
                          decoration: InputDecoration(
                            labelText: 'NIT',
                            hintText: 'Número de identificación fiscal',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () => _guardar(id: id),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
