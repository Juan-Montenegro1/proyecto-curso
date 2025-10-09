import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import '../../models/meal.dart';

class MealDetailView extends StatelessWidget {
  final Meal meal;
  const MealDetailView({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: meal.name,
      showBackButton: true,
      backRoute: '/meals',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (meal.thumbnail != null)
              Image.network(meal.thumbnail!),
            const SizedBox(height: 12),
            Text(
              meal.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Categoría: ${meal.category ?? 'N/A'}'),
            Text('Área: ${meal.area ?? 'N/A'}'),
            const SizedBox(height: 12),
            Text(meal.instructions ?? 'Sin instrucciones', textAlign: TextAlign.left),
          ],
        ),
      ),
    );
  }
}
