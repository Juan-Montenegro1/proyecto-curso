import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealService {
  // Base URL for TheMealDB
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  // Search meals by name. Throws on non-200 or network/timeouts.
  Future<List<Meal>> searchMeals({String query = 'a'}) async {
    final url = Uri.parse('$_base/search.php?s=$query');
  debugPrint('MealService: iniciando búsqueda para query="$query" -> $url');
    try {
      final resp = await http.get(url).timeout(const Duration(seconds: 8));
  debugPrint('MealService: respuesta recibida (status ${resp.statusCode})');
      if (resp.statusCode != 200) {
        throw HttpException('Error fetching meals: ${resp.statusCode}');
      }
      final Map<String, dynamic> data = json.decode(resp.body);
      final mealsList = data['meals'];
  debugPrint('MealService: parseando respuesta JSON');
      if (mealsList == null) return [];
  final list = mealsList as List;
  debugPrint('MealService: encontrados ${list.length} resultados');
  return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
    } on TimeoutException {
      debugPrint('MealService: TimeoutException');
      throw Exception('La petición tardó demasiado. Intenta nuevamente.');
    } on SocketException catch (e) {
      debugPrint('MealService: SocketException: ${e.message}');
      throw Exception('Problema de red: ${e.message}');
    } on HttpException catch (e) {
      debugPrint('MealService: HttpException: ${e.message}');
      throw Exception(e.message);
    } on FormatException {
      debugPrint('MealService: FormatException al parsear JSON');
      throw Exception('Respuesta inválida del servidor');
    }
  }
}
