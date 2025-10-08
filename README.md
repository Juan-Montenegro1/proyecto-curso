Cuándo usar Future, async/await, Timer e Isolate.

Future
Qué es:

Un Future representa una tarea asíncrona que devolverá un resultado en el futuro.
Se usa para operaciones que toman tiempo, como leer un archivo, hacer una petición HTTP o esperar un cálculo.

Cuándo usarlo:

Cuando la tarea no bloquea la interfaz y no consume mucho CPU, pero tarda un poco en devolver el resultado.

-----------------------------------------------------------------------------------
async / await
Qué es:

Son palabras clave que hacen que el código asíncrono parezca síncrono, es decir, más legible.

async → indica que la función devolverá un Future.

await → pausa la ejecución hasta que el Future termine.

Cuándo usarlo:

Cuando necesitas esperar el resultado de una tarea antes de continuar.
-----------------------------------------------------------------------------------

Timer
Qué es:

Timer sirve para ejecutar código después de un tiempo determinado o de forma periódica (por ejemplo, cada segundo).

Cuándo usarlo:

Cuando necesitas cronómetros, repeticiones o acciones temporizadas.

-----------------------------------------------------------------------------------
Isolate
Qué es:

Un Isolate es un hilo de ejecución independiente en Dart.
Sirve para tareas que consumen mucho CPU (por ejemplo, cálculos grandes o compresión de archivos), para no bloquear la interfaz gráfica.

Cuándo usarlo:

Cuando el proceso es pesado (intensos en CPU) y puede congelar la UI si se ejecuta en el hilo principal.
----------------------------------------------------------------------------------------------------------------
DIAGRAMA, LISTA DE PANTALLAS Y FLUJOS
<img width="2296" height="1540" alt="image" src="https://github.com/user-attachments/assets/350fce91-4032-4df1-8a33-db9c29aabfc8" />
