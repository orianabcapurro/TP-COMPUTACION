# AGENTS.md

Guía para agentes (Kiro, Claude, Copilot, etc.) que trabajen sobre este repo. Leé esto antes de hacer cambios.

---

## Qué es este proyecto

**TP Computación — Ima Pico Generative.** Sketch de Processing (Java Mode) que genera una obra visual generativa e interactiva inspirada en la familia visual de las pinturas "Ima Pico / Q3".

- **Tecnología:** Processing 4 (Java Mode). Un único archivo `.pde`.
- **Entrega:** universitaria. El código debe ser claro, simple y defendible.
- **Estado actual:** versión estática "pixel-perfect" que replica una pintura de referencia. La generación aleatoria y la interactividad se reincorporarán después.
- **Idioma:** todo el código, variables, comentarios y documentos en español.

---

## Estructura del repo

```
TP-Computacion/
├── AGENTS.md                             ← este archivo
├── ima_pico_generative/
│   └── ima_pico_generative.pde           ← sketch principal (único archivo de código)
├── .kiro/
│   ├── specs/ima-pico-generative/        ← requirements.md + design.md
│   ├── skills/ima-pico-painter.md        ← guía operativa para pintar nuevas composiciones
│   └── steering/                         ← (vacío)
└── _ref_replicator/                      ← código p5.js de referencia (NO tocar, solo lectura)
```

La carpeta `ima_pico_generative/` debe llamarse **exactamente** igual que el archivo `.pde` que contiene; es requisito de Processing.

---

## Reglas no negociables

Estas reglas vienen de la consigna académica y del criterio del autor. Respetalas sin excepción.

1. **Un solo archivo `.pde`** salvo que Processing obligue a separar pestañas. Nada de arquitectura multi-archivo.
2. **Processing Java Mode** exclusivamente. No p5.js, no p5py, no Python mode.
3. **Sin recursos externos.** Cero imágenes, cero fuentes externas, cero videos. Todo procedural.
4. **Librerías permitidas:** solo la estándar de Processing. La librería `Sound` se permite únicamente para la entrada de micrófono, y solo si no rompe el sketch.
5. **Renderizado 2D.** No usar `P3D`, `lights()`, `camera()`, ni ningún efecto tridimensional.
6. **Estética plana.** Nada de gradientes, sombras, blur, transparencias. Colores sólidos.
7. **Sin generación aleatoria en la versión actual.** Estamos en modo pixel-perfect. La aleatorización se reintroduce cuando el usuario lo indique.
8. **No inventar formas fuera del vocabulario de la serie** (ver `.kiro/skills/ima-pico-painter.md`).

---

## Cómo trabajar con el usuario

El usuario prefiere:

- **Preguntar antes de asumir.** Si una forma, posición o color no está clara, preguntar con opciones concretas.
- **Implementar pieza por pieza** cuando estamos construyendo una composición nueva. No entregar todo junto de un tirón.
- **Planear antes de codear** cuando el cambio es grande o ambiguo. Primero el plan, después el código.
- **Respuestas cortas.** Directo al grano, sin preámbulos largos ni emojis.
- **Iteración visual.** El usuario prueba en Processing, manda captura, ajustamos.

---

## Convenciones de código

- **Ventana:** 600×600 (o el tamaño actual del sketch).
- **Marco blanco exterior** (`MARCO`, típicamente 22 px) alrededor del área dibujable.
- **Grid virtual 500×500** para todas las coordenadas. Se escalan al área interior con el factor `s`.
- **Colores en hex literal** (`#0C482E`) en modo RGB por defecto. Si se usa HSB, declararlo explícito y ser consistente.
- **Nombres en español** (`dibujarCuartoCirculoRosa`, `colorFondo`, etc.).
- **Orden de dibujo dentro de `draw()`:**
  1. `background(255)` — marco blanco
  2. `pushMatrix()` + `translate(MARCO, MARCO)`
  3. Fondo oscuro
  4. `clip()` al área interior
  5. Formas con borde blanco primero (zigzag, onda)
  6. Figuras geométricas simples
  7. Motivo firma al final
  8. `noClip()` + `popMatrix()`
- **`noLoop()`** en el sketch estático. Solo usar `draw()` en loop cuando haya interactividad o micrófono.

---

## Vocabulario de formas permitido

Ver detalle completo en `.kiro/skills/ima-pico-painter.md`. Resumen:

- Rectángulo (barra ancha o cuadrado)
- Píldora (rectángulo con esquinas redondeadas)
- Cuarto de círculo (`arc` con modo `PIE`)
- Triángulo
- Arcada (semicírculo sobre rectángulo)
- Zigzag cerrado con borde blanco grueso
- Onda cerrada con borde blanco grueso (bezier)
- Motivo 4 triángulos (cuadrado dividido por diagonales)

Nada más. Si el usuario pide una forma que no esté en esta lista, preguntar antes de implementar.

---

## Reglas compositivas

- **Figuras pegadas a bordes o entre sí.** Nunca flotando sueltas en el medio.
- **Nunca solapamiento total** de una figura sobre otra. Adosadas como un puzzle.
- **Formas orgánicas (zigzag/onda) siempre con borde blanco grueso**, siempre pegadas a un borde del lienzo, siempre solas (no tienen figuras pegadas a ellas).
- **Figuras geométricas simples nunca llevan stroke blanco** — esto arruina la familia visual.
- El fondo oscuro debe verse como "respiración" entre las figuras.

---

## Si el agente tiene que investigar

Orden de consulta:

1. **`.kiro/skills/ima-pico-painter.md`** — patrones de código probados y vocabulario de formas.
2. **`.kiro/specs/ima-pico-generative/requirements.md`** — requerimientos formales (17 requerimientos, invariantes verificables).
3. **`.kiro/specs/ima-pico-generative/design.md`** — diseño arquitectónico (aplica cuando se reintroduzca la parte generativa).
4. **`_ref_replicator/src/components/P5Canvas.tsx`** — código p5.js de referencia del replicador web, útil para extraer coordenadas y curvas. **Solo lectura.**

---

## Estado y próximos pasos

- [x] Versión pixel-perfect estática del cuadro de referencia
- [x] Skill `ima-pico-painter` con el vocabulario y patrones
- [ ] Reintroducir generación con semilla usando la composición actual como plantilla
- [ ] Volver a agregar controles de teclado (`R` regenera, `+`/`-` intensidad, `SPACE` cambia paleta, `D` debug)
- [ ] Modular grosor del borde blanco según intensidad
- [ ] Agregar micrófono con fallback automático si el entorno lo permite

Cuando el usuario pida "agregá aleatorización" o similar, usar la skill `ima-pico-painter` para mantener la coherencia con la familia visual.

---

## Qué NO hacer

- No reescribir todo el sketch sin preguntar.
- No mezclar p5.js con Processing.
- No generar imágenes con `loadImage()` ni descargar recursos.
- No usar colores random sin respetar la paleta de la serie.
- No dibujar figuras flotando en el centro del lienzo sin apoyo.
- No agregar stroke blanco a rectángulos, triángulos, círculos o arcadas.
- No incrementar la complejidad arquitectónica sin que el usuario lo pida. Esto es un TP universitario, no un sistema de producción.
