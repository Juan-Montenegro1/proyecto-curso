import 'package:go_router/go_router.dart';
import 'package:registro_clases/views/categoria_fb/categoria_fb_form_view.dart';
import 'package:registro_clases/views/categoria_fb/categoria_fb_list_view.dart';
import 'package:registro_clases/views/ciclo_vida/ciclo_vida_screen.dart';
import 'package:registro_clases/views/home/home_screen.dart';
import 'package:registro_clases/views/paso_parametros/detalle_screen.dart';
import 'package:registro_clases/views/paso_parametros/paso_parametros_screen.dart';

import '../views/future/future_view.dart';
import '../views/isolate/isolate_view.dart';
import '../views/pokemons/pokemon_detail_view.dart';
import '../views/pokemons/pokemon_list_view.dart';
import '../views/meals/meal_list_view.dart';
import '../views/meals/meal_detail_view.dart';
import '../models/meal.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // !Ruta para el detalle con parámetros
    GoRoute(
      path:
          '/detalle/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
      builder: (context, state) {
        //*se capturan los parametros recibidos
        // declarando las variables parametro y metodo
        // es final porque no se van a modificar
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    //!Ruta para el ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      name: 'ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    //!Ruta para FUTURE
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),
    //!Ruta para ISOLATE
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),
    //!Ruta para listaado de pokemones
    GoRoute(
      path: '/pokemons',
      name: 'pokemons',
      builder: (context, state) => const PokemonListView(),
    ),
    //!Ruta para listaado de meals
    GoRoute(
      path: '/meals',
      name: 'meals',
      builder: (context, state) => const MealListView(),
    ),
    //!Ruta para detalle de meal
    GoRoute(
      path: '/meal/:id',
      name: 'meal_detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Meal) {
          return MealDetailView(meal: extra);
        }
        if (extra is Map && extra['meal'] is Meal) {
          return MealDetailView(meal: extra['meal'] as Meal);
        }
        throw Exception('Meal detail requires a Meal passed in extra');
      },
    ),
    //!Ruta para detalle de pokemones
    GoRoute(
      path: '/pokemon/:name', // se recibe el nombre del pokemon como parametro
      name: 'pokemon_detail',
      builder: (context, state) {
        final name =
            state.pathParameters['name']!; // se captura el nombre del pokemon.
        return PokemonDetailView(name: name);
      },
    ),
   //! Rutas para el manejo de Categorías (CRUD)  
    GoRoute( 
      path: '/categoriasFirebase', 
      name: 'categoriasFirebase', 
      builder: (_, __) => const CategoriaFbListView(), 
    ), 
    GoRoute( 
      path: '/categoriasfb/create', 
      name: 'categoriasfb.create', 
      builder: (context, state) => const CategoriaFbFormView(), 
    ), 
    GoRoute( 
      path: '/categoriasfb/edit/:id', 
      name: 'categorias.edit', 
      builder: (context, state) { 
        final id = state.pathParameters['id']!; 
        return CategoriaFbFormView(id: id); 
      }, 
    ), 
  ],
);
