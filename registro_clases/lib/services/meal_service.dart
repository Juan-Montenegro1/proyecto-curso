import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealService {
  // Base URL for TheMealDB
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  // Search meals by name. Throws on non-200 or network/timeouts.
  Future<List<Meal>> searchMeals({String query = 'a'}) async {
    final url = Uri.parse('$_base/search.php?s=$query');
    try {
      final resp = await http.get(url).timeout(const Duration(seconds: 8));
      if (resp.statusCode != 200) {
        throw HttpException('Error fetching meals: ${resp.statusCode}');
      }
      final Map<String, dynamic> data = json.decode(resp.body);
      final mealsList = data['meals'];
      if (mealsList == null) return [];
      return (mealsList as List).map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
    } on TimeoutException {
      throw Exception('La petición tardó demasiado. Intenta nuevamente.');
    } on SocketException catch (e) {
      throw Exception('Problema de red: ${e.message}');
    } on HttpException catch (e) {
      throw Exception(e.message);
    } on FormatException {
      throw Exception('Respuesta inválida del servidor');
    }
  }
}
