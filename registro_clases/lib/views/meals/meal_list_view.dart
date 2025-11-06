import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import 'package:go_router/go_router.dart';
import '../../models/meal.dart';
import '../../services/meal_service.dart';

class MealListView extends StatefulWidget {
  const MealListView({super.key});

  @override
  State<MealListView> createState() => _MealListViewState();
}

class _MealListViewState extends State<MealListView> {
  final MealService _service = MealService();
  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchCtrl = TextEditingController(text: 'a');

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
  if (foundation.kDebugMode) foundation.debugPrint('MealListView: iniciando búsqueda para "${_searchCtrl.text.trim()}"');
    try {
      final results = await _service.searchMeals(query: _searchCtrl.text.trim());
  if (foundation.kDebugMode) foundation.debugPrint('MealListView: resultados obtenidos: ${results.length}');
      if (!mounted) return;
      setState(() {
        _meals = results;
        _isLoading = false;
      });
    } catch (e) {
  if (foundation.kDebugMode) foundation.debugPrint('MealListView: excepción en búsqueda: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      // Mostrar snackbar con mensaje amigable
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos: ${e.toString()}'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Meals - TheMealDB',
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(labelText: 'Buscar por nombre'),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _search, child: const Text('Buscar')),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Expanded(
                child: Center(child: Text('Error: $_error')),
              )
            else
              Expanded(
                child: _meals.isEmpty
                    ? const Center(child: Text('No se encontraron resultados'))
                    : ListView.builder(
                        itemCount: _meals.length,
                        itemBuilder: (context, index) {
                          final m = _meals[index];
                          return ListTile(
                            leading: m.thumbnail != null
                                ? Image.network(m.thumbnail!, width: 64, height: 64, fit: BoxFit.cover)
                                : const SizedBox(width: 64, height: 64),
                            title: Text(m.name),
                            subtitle: Text('${m.category ?? ''} • ${m.area ?? ''}'),
                            onTap: () {
                              // Navegar a detalle pasando el Meal como extra
                              context.go('/meal/${m.id}', extra: m);
                            },
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
