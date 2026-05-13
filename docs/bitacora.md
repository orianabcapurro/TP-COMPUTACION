TP1 — Bitácora de proceso con IA 2026
Comisión: Lisandro
Estudiantes: Gómez, Bello, Hansen, Capurro, Celi

---

Entrada #1 — 11/5 — Replicación inicial de la pintura de referencia

Objetivo
Obtener una primera versión en código de la pintura de referencia de Ima Pico, para entender qué tan bien la IA podía interpretar la composición a partir de una imagen.

Prompt
"Este es todo el texto completo replica esta imagen exacta en processing, que sea prácticamente idéntica"

Evaluación y corrección
La IA generó una estructura general reconocible: fondo verde oscuro, el cuarto de círculo rosa, la barra azul, el triángulo celeste, la píldora lavanda y el bloque rojo. Sin embargo, las proporciones estaban desajustadas y varios colores eran aproximaciones. Las formas orgánicas (zigzag y onda) aparecían como líneas sueltas sin relación con las figuras que bordean. El resultado era útil como punto de partida pero no como réplica fiel.

Aprendizaje
La IA puede captar la estructura general de una composición a partir de una imagen, pero los detalles de posición y color requieren corrección manual. Conviene arrancar con una versión gruesa y refinar por partes.

---

Entrada #2 — 11/5 — Las líneas blancas no son decorativas

Objetivo
Corregir el error conceptual más importante de la primera versión: la IA interpretó las líneas blancas como elementos decorativos independientes, cuando en realidad son los bordes de las formas orgánicas (zigzag = borde de la forma granate, onda = borde de la forma verde lima).

Prompt
"Las líneas blancas no son aleatorias, son los bordes de los objetos con forma partículas, el de 3 picos y el de 3 ondas, mirá bien la imagen y replicalo exacto"

Evaluación y corrección
Después de aclarar esto, la IA redefinió la lógica correctamente: las coordenadas del stroke blanco y del fill de cada forma orgánica pasaron a ser las mismas. El resultado mejoró notablemente. Quedaba pendiente afinar las curvas de la onda, que todavía no reproducían bien las tres inflexiones del original.

Aprendizaje
Cuando la IA malinterpreta la estructura de una imagen, no alcanza con pedir "más fiel" — hay que explicar explícitamente la relación entre los elementos. En este caso, nombrar que la línea es el borde de una forma fue lo que desbloqueó la corrección.

---

Entrada #3 — 11/5 — Corrección del cuarto de círculo rosa

Objetivo
Corregir la unión entre el cuarto de círculo rosa (esquina superior izquierda) y el rectángulo azul, que en varias versiones anteriores quedaba con superposición o con un hueco visible entre las dos formas.

Prompt
"Arriba a la izquierda la forma del círculo rosa cortado y pegado al rectángulo azul está mal, corregilo y hacelo exactamente igual"

Evaluación y corrección
El problema era que la IA estaba usando arc() con un centro desplazado del origen, lo que generaba desalineación. La corrección fue anclar el arco en (0, 0) con modo PIE, de forma que el cuarto de círculo nazca exactamente en la esquina y su borde recto quede alineado con el rectángulo azul. Una vez aplicado, las dos formas quedaron adosadas sin espacio ni solapamiento, como en el original.

Aprendizaje
Para formas que deben pegarse a un borde del canvas, el punto de anclaje importa tanto como el radio. Usar PIE con centro en la esquina es la forma correcta de hacer un cuarto de círculo que arranque desde el vértice.

---

Entrada #4 — 11/5 — Ajuste de presentación web

Objetivo
Hacer que la obra se vea bien en el navegador: que el canvas ocupe un lugar central y grande, con los bordes blancos del cuadro visibles, sin elementos de UI que distraigan.

Prompts
"Que la web solo muestre el p5.js en grande, solo eso, que ocupe un cuadrado entero en la web así lo veo en grande"

"Se ve demasiado cerca y se rompió un poco la figura, dale espacio y achicalo un poco así se ven los bordes blancos de todo el cuadrado en la web"

Evaluación y corrección
La primera versión "en grande" cortaba los bordes de la figura porque el canvas ocupaba el 100% de la ventana sin margen. Se ajustó para que el canvas tenga un tamaño máximo con padding, de modo que el marco blanco exterior sea siempre visible. Se eliminó todo el texto y la UI extra que no aportaba nada a la presentación de la obra.

Aprendizaje
El tamaño del canvas y el layout de la página son decisiones separadas. Un canvas muy grande sin margen puede hacer que la obra se vea peor que uno más chico bien enmarcado.

---

Entrada #5 — 11/5 — Conversión a sistema generativo

Objetivo
Transformar la réplica estática en un sistema generativo que mantenga el vocabulario visual de la serie Ima Pico pero permita variación controlada, siguiendo los lineamientos del TP1.

Prompt
"Ahora hace una versión acorde a este trabajo"
(se adjuntó el PDF del TP1 con el análisis formal)

Evaluación y corrección
El sistema resultante respeta el vocabulario de formas del original y agrega variación en tres dimensiones: cada forma tiene 4 variantes posibles de posición o geometría, hay 4 paletas de color que rotan con SPACE, y un parámetro de intensidad (+/-) modula el grosor del borde blanco, la amplitud del zigzag y la onda, y el tamaño del motivo de 4 triángulos. La tecla R muta una forma aleatoria con un flash visual que indica el cambio. El resultado es coherente con la serie: las composiciones generadas se ven como variaciones plausibles de la obra original, no como algo genérico.

Aprendizaje
Pasar de una réplica a un sistema generativo es más fácil cuando la réplica está bien estructurada: si cada forma tiene sus coordenadas claras y separadas, agregar variantes es solo cuestión de definir casos alternativos. El trabajo de fidelidad de las etapas anteriores hizo que esta etapa fuera directa.

---

Entrada #6 — 11/5 — Limpieza y orden del código

Objetivo
Ordenar el código y los comentarios del sketch, que habían quedado inconsistentes después de mezclar partes escritas manualmente con partes generadas por la IA.

Prompt
"Ordená el código y los comentarios para que esté más prolijo"

Evaluación y corrección
Como una parte del código la habíamos escrito nosotras y otra la había generado la IA, el resultado final tenía inconsistencias: algunos bloques tenían comentarios, otros no, y el estilo no era uniforme. La IA unificó el formato, acomodó el orden de las funciones y con el mismo criterio en todo el archivo. El resultado fue más fácil de leer.

Aprendizaje
Cuando se mezcla código propio con código generado por IA, es útil hacer una pasada de limpieza al final para unificar el estilo. Es más fácil hacerlo como un paso separado que ir corrigiendo sobre la marcha.
