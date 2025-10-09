Cuándo usar Future, async/await, Timer e Isolate.

Future
-----------------------------------------------------------------------------------
Qué es:

Un Future representa una tarea asíncrona que devolverá un resultado en el futuro.
Se usa para operaciones que toman tiempo, como leer un archivo, hacer una petición HTTP o esperar un cálculo.

Cuándo usarlo:

Cuando la tarea no bloquea la interfaz y no consume mucho CPU, pero tarda un poco en devolver el resultado.


async / await
-----------------------------------------------------------------------------------
Qué es:

Son palabras clave que hacen que el código asíncrono parezca síncrono, es decir, más legible.

async → indica que la función devolverá un Future.

await → pausa la ejecución hasta que el Future termine.

Cuándo usarlo:

Cuando necesitas esperar el resultado de una tarea antes de continuar.


Timer
-----------------------------------------------------------------------------------
Qué es:

Timer sirve para ejecutar código después de un tiempo determinado o de forma periódica (por ejemplo, cada segundo).

Cuándo usarlo:

Cuando necesitas cronómetros, repeticiones o acciones temporizadas.


Isolate
-----------------------------------------------------------------------------------
Qué es:

Un Isolate es un hilo de ejecución independiente en Dart.
Sirve para tareas que consumen mucho CPU (por ejemplo, cálculos grandes o compresión de archivos), para no bloquear la interfaz gráfica.

Cuándo usarlo:

Cuando el proceso es pesado (intensos en CPU) y puede congelar la UI si se ejecuta en el hilo principal.
----------------------------------------------------------------------------------------------------------------
DIAGRAMA, LISTA DE PANTALLAS Y FLUJOS
-----------------------------------------------------------------------------------
<img width="2296" height="1540" alt="image" src="https://github.com/user-attachments/assets/350fce91-4032-4df1-8a33-db9c29aabfc8" />


TALLER HTTP
------------------------------------------------------------
API usada
------------------------------------------------------------
API: TheMealDB (gratuita, pública).

Endpoint principal usado en la demo (búsqueda por nombre):
GET https://www.themealdb.com/api/json/v1/1/search.php?s={query}
Ejemplo: https://www.themealdb.com/api/json/v1/1/search.php?s=a

Endpoint útil para detalle por id:
GET https://www.themealdb.com/api/json/v1/1/lookup.php?i={id}
Ejemplo (fragmento reducido de la respuesta JSON de search.php?s=a):

{

  "meals": [
  
    {
    
      "idMeal": "52771",
      
      "strMeal": "Spicy Arrabiata Penne",
      
      "strCategory": "Vegetarian",
      
      "strArea": "Italian",
      
      "strInstructions": "Bring a large pot of water to a boil...",
      
      "strMealThumb": "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg",
      
      "...": "..."
      
    },
    
    {
      "idMeal": "52772",
      
      "strMeal": "Teriyaki Chicken",
      
      "...": "..."
      
    }
    
  ]
  
}

Arquitectura del proyecto
-------------------------------------------------
Estructura relevante:

lib/models/

meal.dart — modelo Meal con Meal.fromJson(...).

lib/services/

meal_service.dart — lógica HTTP (GET) hacia TheMealDB, con timeout y manejo de excepciones.

lib/views/

meal_list_view.dart — pantalla listado (búsqueda, estados: cargando/éxito/error, ListView)

meals/meal_detail_view.dart — pantalla detalle (imagen + texto)

Otras vistas ya existentes: /future, /isolate, /pokemons, etc

lib/widgets/

base_view.dart — scaffold 

custom_drawer.dart — Drawer para navegación

lib/routes/

app_router.dart — definición de rutas con go_router.


Rutas definidas con go_router
-----------------------------------------------------
Las rutas importantes en app_router.dart:


Builder: HomeScreen()

Parámetros: ninguno.

/paso_parametros

Builder: PasoParametrosScreen().

/detalle/:parametro/:metodo

Builder: DetalleScreen(parametro, metodoNavegacion)

Parámetros de ruta: parametro y metodo (path params).

/ciclo_vida

Builder: CicloVidaScreen().

/future (name: future)

Builder: FutureView().

/isolate (name: isolate)

Builder: IsolateView().

/pokemons (name: pokemons)

Builder: PokemonListView().

/pokemon/:name (name: pokemon_detail)

Builder: PokemonDetailView(name)

Path param: name.

/meals (name: meals)

Builder: MealListView()

Comportamiento: pantalla de listado / búsqueda. No path params.

/meal/:id (name: meal_detail)

Builder: MealDetailView(meal: ...)

Path param: id (se incluye en la URL para trazabilidad)

Nota: para deep links sería buena práctica usar lookup.php?i={id} en MealDetailView si extra no está presente.
