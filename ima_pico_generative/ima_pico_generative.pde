// ============================================================
// IMA PICO GENERATIVE — Réplica con paletas, intensidad y mutación
// Processing Java Mode — TP Computación
// ============================================================
// Controles:
//   UP/DOWN o +/-  →  intensidad [0,1]
//   SPACE          →  ciclar paleta
//   R              →  mutar una forma al azar (acumulativo)
//   X              →  resetear todas las mutaciones
//   D              →  toggle debug overlay
// ============================================================

final int LADO = 600;
final int MARCO = 22;
final float GRID = 500.0;
float s;

// --- SISTEMA DE PALETAS ---
final int NUM_PALETAS = 4;
final int COLORES_POR_PALETA = 14;
color[][] paletas = new color[NUM_PALETAS][COLORES_POR_PALETA];
int indicePaleta = 0;

// --- INTENSIDAD ---
float intensidad = 0.0;
final float PASO_INTENSIDAD = 0.05;
final float GROSOR_BORDE_MIN = 12.0;
final float GROSOR_BORDE_MAX = 32.0;
final float AMPL_ZIGZAG_MIN = 1.0;
final float AMPL_ZIGZAG_MAX = 1.8;
final float AMPL_ONDA_MIN   = 1.0;
final float AMPL_ONDA_MAX   = 1.4;
final float ZIGZAG_EJE_X = -30;
final float ONDA_EJE_X   = 510;
final float FACTOR_SAT_MIN = 0.85;
final float FACTOR_SAT_MAX = 1.15;
final float FACTOR_BR_MIN  = 0.95;
final float FACTOR_BR_MAX  = 1.10;
final float MOTIVO_LADO_MIN = 70;
final float MOTIVO_LADO_MAX = 110;

// Slots de paleta
final int SLOT_FONDO          = 0;
final int SLOT_ZIGZAG         = 1;
final int SLOT_ONDA           = 2;
final int SLOT_CUARTO_CIRCULO = 3;
final int SLOT_BARRA_AMARILLA = 4;
final int SLOT_RECT_AZUL      = 5;
final int SLOT_TRIANGULO      = 6;
final int SLOT_ARCADA         = 7;
final int SLOT_CUADRADO_ROJO  = 8;
final int SLOT_PILDORA        = 9;
final int SLOT_MOTIVO_SUP     = 10;
final int SLOT_MOTIVO_DER     = 11;
final int SLOT_MOTIVO_INF     = 12;
final int SLOT_MOTIVO_IZQ     = 13;

// --- MUTACIÓN ---
final int NUM_FORMAS = 10;
// índices de formas (coinciden con el orden de dibujo)
final int F_ZIGZAG         = 0;
final int F_ONDA           = 1;
final int F_CUARTO_CIRCULO = 2;
final int F_BARRA_AMARILLA = 3;
final int F_RECT_AZUL      = 4;
final int F_TRIANGULO      = 5;
final int F_ARCADA         = 6;
final int F_CUADRADO_ROJO  = 7;
final int F_PILDORA        = 8;
final int F_MOTIVO         = 9;

final int VARIANTES_POR_FORMA = 4;
int[] variantes = new int[NUM_FORMAS];      // 0 = default para cada forma
int[] flashFrames = new int[NUM_FORMAS];    // contador de flash por forma
final int FLASH_DURACION = 20;
final int MAX_INTENTOS_MUTACION = 10;

// --- DEBUG ---
boolean modoDebug = false;

// ============================================================
void setup() {
  size(600, 600);
  s = (LADO - 2 * MARCO) / GRID;
  inicializarPaletas();
  // loop() está activo por defecto — lo necesitamos para los flashes
}

// ============================================================
// PALETAS
// ============================================================
void inicializarPaletas() {
  paletas[0][SLOT_FONDO]          = #0C482E;
  paletas[0][SLOT_ZIGZAG]         = #602143;
  paletas[0][SLOT_ONDA]           = #88B914;
  paletas[0][SLOT_CUARTO_CIRCULO] = #D63583;
  paletas[0][SLOT_BARRA_AMARILLA] = #F0B000;
  paletas[0][SLOT_RECT_AZUL]      = #1C3D92;
  paletas[0][SLOT_TRIANGULO]      = #2FA7D1;
  paletas[0][SLOT_ARCADA]         = #BA81B9;
  paletas[0][SLOT_CUADRADO_ROJO]  = #D12731;
  paletas[0][SLOT_PILDORA]        = #279E39;
  paletas[0][SLOT_MOTIVO_SUP]     = #00A4B2;
  paletas[0][SLOT_MOTIVO_DER]     = #1D1D1B;
  paletas[0][SLOT_MOTIVO_INF]     = #FBDF15;
  paletas[0][SLOT_MOTIVO_IZQ]     = #F15C29;
  
  paletas[1][SLOT_FONDO]          = #2B1A4C;
  paletas[1][SLOT_ZIGZAG]         = #D63583;
  paletas[1][SLOT_ONDA]           = #2FA7D1;
  paletas[1][SLOT_CUARTO_CIRCULO] = #F0B000;
  paletas[1][SLOT_BARRA_AMARILLA] = #88B914;
  paletas[1][SLOT_RECT_AZUL]      = #00A4B2;
  paletas[1][SLOT_TRIANGULO]      = #BA81B9;
  paletas[1][SLOT_ARCADA]         = #F15C29;
  paletas[1][SLOT_CUADRADO_ROJO]  = #1C3D92;
  paletas[1][SLOT_PILDORA]        = #FBDF15;
  paletas[1][SLOT_MOTIVO_SUP]     = #D12731;
  paletas[1][SLOT_MOTIVO_DER]     = #1D1D1B;
  paletas[1][SLOT_MOTIVO_INF]     = #88B914;
  paletas[1][SLOT_MOTIVO_IZQ]     = #D63583;
  
  paletas[2][SLOT_FONDO]          = #0F1E4D;
  paletas[2][SLOT_ZIGZAG]         = #F15C29;
  paletas[2][SLOT_ONDA]           = #FBDF15;
  paletas[2][SLOT_CUARTO_CIRCULO] = #00A4B2;
  paletas[2][SLOT_BARRA_AMARILLA] = #D63583;
  paletas[2][SLOT_RECT_AZUL]      = #D12731;
  paletas[2][SLOT_TRIANGULO]      = #F0B000;
  paletas[2][SLOT_ARCADA]         = #88B914;
  paletas[2][SLOT_CUADRADO_ROJO]  = #BA81B9;
  paletas[2][SLOT_PILDORA]        = #2FA7D1;
  paletas[2][SLOT_MOTIVO_SUP]     = #88B914;
  paletas[2][SLOT_MOTIVO_DER]     = #1D1D1B;
  paletas[2][SLOT_MOTIVO_INF]     = #D63583;
  paletas[2][SLOT_MOTIVO_IZQ]     = #F0B000;
  
  paletas[3][SLOT_FONDO]          = #103A2E;
  paletas[3][SLOT_ZIGZAG]         = #1C3D92;
  paletas[3][SLOT_ONDA]           = #F0B000;
  paletas[3][SLOT_CUARTO_CIRCULO] = #00A4B2;
  paletas[3][SLOT_BARRA_AMARILLA] = #D63583;
  paletas[3][SLOT_RECT_AZUL]      = #F15C29;
  paletas[3][SLOT_TRIANGULO]      = #BA81B9;
  paletas[3][SLOT_ARCADA]         = #FBDF15;
  paletas[3][SLOT_CUADRADO_ROJO]  = #D63583;
  paletas[3][SLOT_PILDORA]        = #88B914;
  paletas[3][SLOT_MOTIVO_SUP]     = #D12731;
  paletas[3][SLOT_MOTIVO_DER]     = #1D1D1B;
  paletas[3][SLOT_MOTIVO_INF]     = #2FA7D1;
  paletas[3][SLOT_MOTIVO_IZQ]     = #F0B000;
}

color colorDePaleta(int slot) {
  return ajustarColor(paletas[indicePaleta][slot]);
}

float grosorBordeBlanco() { return lerp(GROSOR_BORDE_MIN, GROSOR_BORDE_MAX, intensidad); }
float amplitudZigzag()    { return lerp(AMPL_ZIGZAG_MIN,  AMPL_ZIGZAG_MAX,  intensidad); }
float amplitudOnda()      { return lerp(AMPL_ONDA_MIN,    AMPL_ONDA_MAX,    intensidad); }
float ladoMotivo()        { return lerp(MOTIVO_LADO_MIN,  MOTIVO_LADO_MAX,  intensidad); }

float amplificar(float valor, float eje, float factor) {
  return eje + (valor - eje) * factor;
}

color ajustarColor(color c) {
  float fSat = lerp(FACTOR_SAT_MIN, FACTOR_SAT_MAX, intensidad);
  float fBr  = lerp(FACTOR_BR_MIN,  FACTOR_BR_MAX,  intensidad);
  pushStyle();
  colorMode(HSB, 360, 100, 100);
  float h  = hue(c);
  float sa = constrain(saturation(c) * fSat, 0, 100);
  float br = constrain(brightness(c)  * fBr,  0, 100);
  color resultado = color(h, sa, br);
  popStyle();
  return resultado;
}

// ============================================================
// DRAW
// ============================================================
void draw() {
  background(255);
  
  pushMatrix();
  translate(MARCO, MARCO);
  
  noStroke();
  fill(colorDePaleta(SLOT_FONDO));
  rect(0, 0, GRID * s, GRID * s);
  
  clip(0, 0, (int)(GRID * s), (int)(GRID * s));
  
  dibujarFormaZigzag();
  dibujarFormaOnda();
  dibujarCuartoCirculoRosa();
  dibujarBarraAmarilla();
  dibujarRectanguloAzul();
  dibujarTrianguloCeleste();
  dibujarArcadaLavanda();
  dibujarCuadradoRojo();
  dibujarPildoraVerde();
  dibujarMotivo();
  
  // Decrementar flashes
  for (int i = 0; i < NUM_FORMAS; i++) {
    if (flashFrames[i] > 0) flashFrames[i]--;
  }
  
  noClip();
  popMatrix();
  
  if (modoDebug) dibujarDebug();
}

// Aplica flash blanco sobre la forma recién mutada.
// Se llama después de dibujar la forma.
void aplicarFlash(int idxForma, float x, float y, float w, float h) {
  if (flashFrames[idxForma] <= 0) return;
  float alpha = map(flashFrames[idxForma], 0, FLASH_DURACION, 0, 200);
  pushStyle();
  noStroke();
  fill(255, alpha);
  rect(x, y, w, h);
  popStyle();
}

// ============================================================
// 1. ZIGZAG — 4 variantes
// ============================================================
void dibujarFormaZigzag() {
  int v = variantes[F_ZIGZAG];
  float[][] zz;
  float ejeX;
  
  switch (v) {
    case 1:
      // 5 dientes, mismo borde izquierdo, más denso
      zz = new float[][]{
        {-30, 230}, {110, 300}, {30, 350}, {130, 400}, {40, 450}, {200, 530}
      };
      ejeX = -30;
      break;
    case 2:
      // espejo horizontal: pegado al borde derecho
      zz = new float[][]{
        {530, 250}, {375, 365}, {460, 430}, {290, 530}
      };
      ejeX = 530;
      break;
    case 3:
      // dientes más profundos (más agresivos)
      zz = new float[][]{
        {-30, 230}, {180, 340}, {30, 400}, {250, 530}
      };
      ejeX = -30;
      break;
    default:
      zz = new float[][]{
        {-30, 250}, {125, 365}, {40, 430}, {210, 530}
      };
      ejeX = -30;
  }
  
  float a = amplitudZigzag();
  float[][] p = new float[zz.length][2];
  for (int i = 0; i < zz.length; i++) {
    p[i][0] = amplificar(zz[i][0], ejeX, a);
    p[i][1] = zz[i][1];
  }
  
  fill(colorDePaleta(SLOT_ZIGZAG));
  noStroke();
  beginShape();
  for (int i = 0; i < p.length; i++) vertex(p[i][0] * s, p[i][1] * s);
  vertex(ejeX * s, 530 * s);
  endShape(CLOSE);
  
  stroke(#FBFCFC);
  strokeWeight(grosorBordeBlanco() * s);
  noFill();
  strokeCap(SQUARE);
  strokeJoin(MITER);
  beginShape();
  for (int i = 0; i < p.length; i++) vertex(p[i][0] * s, p[i][1] * s);
  endShape();
  noStroke();
  
  aplicarFlash(F_ZIGZAG, (min(ejeX, 290)) * s, 220 * s, 320 * s, 320 * s);
}

// ============================================================
// 2. ONDA — 4 variantes
// ============================================================
void dibujarFormaOnda() {
  int v = variantes[F_ONDA];
  float a = amplitudOnda();
  float ejeX;
  float[] xs;   // 9 valores X de los vértices/controles bezier
  boolean espejada = false;
  
  switch (v) {
    case 1:
      // ondas más anchas (misma esquina)
      xs = new float[]{320, 470, 470, 320, 190, 560, 450, 510, 510};
      ejeX = 510;
      break;
    case 2:
      // espejo: borde izquierdo en vez de derecho
      xs = new float[]{175, 60, 60, 175, 290, -30, 55, 20, 0};
      ejeX = 0;
      espejada = true;
      break;
    case 3:
      // ondas más compactas
      xs = new float[]{380, 470, 470, 380, 280, 520, 450, 480, 510};
      ejeX = 510;
      break;
    default:
      xs = new float[]{335, 450, 450, 335, 220, 530, 455, 490, 510};
      ejeX = 510;
  }
  
  float[] ax = new float[9];
  for (int i = 0; i < 9; i++) ax[i] = amplificar(xs[i], ejeX, a);
  
  fill(colorDePaleta(SLOT_ONDA));
  noStroke();
  beginShape();
  vertex(ax[0] * s, -10 * s);
  bezierVertex(ax[1] * s,  45 * s, ax[2] * s,  65 * s, ax[3] * s, 115 * s);
  bezierVertex(ax[4] * s, 160 * s, ax[5] * s, 175 * s, ax[6] * s, 255 * s);
  bezierVertex(ax[7] * s, 330 * s, ax[8] * s, 370 * s, ejeX   * s, 400 * s);
  vertex(ejeX * s, -10 * s);
  endShape(CLOSE);
  
  stroke(#FBFCFC);
  strokeWeight(grosorBordeBlanco() * s);
  noFill();
  strokeCap(SQUARE);
  strokeJoin(ROUND);
  beginShape();
  vertex(ax[0] * s, -10 * s);
  bezierVertex(ax[1] * s,  45 * s, ax[2] * s,  65 * s, ax[3] * s, 115 * s);
  bezierVertex(ax[4] * s, 160 * s, ax[5] * s, 175 * s, ax[6] * s, 255 * s);
  bezierVertex(ax[7] * s, 330 * s, ax[8] * s, 370 * s, ejeX   * s, 400 * s);
  endShape();
  noStroke();
  
  float flashX = espejada ? 0 : 200;
  aplicarFlash(F_ONDA, flashX * s, 0, 310 * s, 410 * s);
}

// ============================================================
// 3. CUARTO DE CÍRCULO — 4 variantes (una por esquina)
// ============================================================
void dibujarCuartoCirculoRosa() {
  int v = variantes[F_CUARTO_CIRCULO];
  float d = 210 * s;
  float cx = 0, cy = 0;
  float start = 0, stop = HALF_PI;
  
  switch (v) {
    case 1: // esquina sup-derecha
      cx = GRID * s; cy = 0;
      start = HALF_PI; stop = PI;
      break;
    case 2: // esquina inf-izquierda
      cx = 0; cy = GRID * s;
      start = -HALF_PI; stop = 0;
      break;
    case 3: // esquina inf-derecha
      cx = GRID * s; cy = GRID * s;
      start = PI; stop = PI + HALF_PI;
      break;
    default: // sup-izquierda (original)
      cx = 0; cy = 0;
      start = 0; stop = HALF_PI;
  }
  
  fill(colorDePaleta(SLOT_CUARTO_CIRCULO));
  noStroke();
  arc(cx, cy, d, d, start, stop);
  
  aplicarFlash(F_CUARTO_CIRCULO, cx - d/2, cy - d/2, d, d);
}

// ============================================================
// 4. BARRA AMARILLA — 4 variantes
// ============================================================
void dibujarBarraAmarilla() {
  int v = variantes[F_BARRA_AMARILLA];
  float x, y, w, h;
  
  switch (v) {
    case 1: // vertical izquierda
      x = 0; y = 300; w = 35; h = 85;
      break;
    case 2: // horizontal derecha
      x = 415; y = 142; w = 85; h = 35;
      break;
    case 3: // en el borde inferior (horizontal)
      x = 60; y = 465; w = 85; h = 35;
      break;
    default: // original
      x = 0; y = 142; w = 85; h = 35;
  }
  
  fill(colorDePaleta(SLOT_BARRA_AMARILLA));
  noStroke();
  rect(x * s, y * s, w * s, h * s);
  
  aplicarFlash(F_BARRA_AMARILLA, x * s, y * s, w * s, h * s);
}

// ============================================================
// 5. RECT AZUL — 4 variantes
// ============================================================
void dibujarRectanguloAzul() {
  int v = variantes[F_RECT_AZUL];
  float x, y, w, h;
  
  switch (v) {
    case 1: // arriba-izquierda, más angosto
      x = 0; y = 0; w = 140; h = 95;
      break;
    case 2: // arriba-derecha
      x = 330; y = 0; w = 170; h = 95;
      break;
    case 3: // pegado al borde derecho (vertical)
      x = 405; y = 0; w = 95; h = 190;
      break;
    default: // original
      x = 105; y = 0; w = 190; h = 95;
  }
  
  fill(colorDePaleta(SLOT_RECT_AZUL));
  noStroke();
  rect(x * s, y * s, w * s, h * s);
  
  aplicarFlash(F_RECT_AZUL, x * s, y * s, w * s, h * s);
}

// ============================================================
// 6. TRIÁNGULO CELESTE — 4 variantes (rotaciones)
// ============================================================
void dibujarTrianguloCeleste() {
  int v = variantes[F_TRIANGULO];
  float x1, y1, x2, y2, x3, y3;
  
  switch (v) {
    case 1: // punta arriba (apoyado en y=250)
      x1 = 105; y1 = 250; x2 = 295; y2 = 250; x3 = 200; y3 = 95;
      break;
    case 2: // punta izquierda
      x1 = 295; y1 = 95; x2 = 295; y2 = 250; x3 = 105; y3 = 170;
      break;
    case 3: // punta derecha
      x1 = 105; y1 = 95; x2 = 105; y2 = 250; x3 = 295; y3 = 170;
      break;
    default: // original (punta abajo)
      x1 = 105; y1 = 95; x2 = 295; y2 = 95; x3 = 200; y3 = 250;
  }
  
  fill(colorDePaleta(SLOT_TRIANGULO));
  noStroke();
  triangle(x1 * s, y1 * s, x2 * s, y2 * s, x3 * s, y3 * s);
  
  aplicarFlash(F_TRIANGULO, 105 * s, 95 * s, 190 * s, 160 * s);
}

// ============================================================
// 7. ARCADA LAVANDA — 4 variantes
// ============================================================
void dibujarArcadaLavanda() {
  int v = variantes[F_ARCADA];
  float cx = 330, cy = 350, d = 185, rectAltoBase = 50;
  
  fill(colorDePaleta(SLOT_ARCADA));
  noStroke();
  
  switch (v) {
    case 1: // cúpula abajo (invertida)
      arc(cx * s, cy * s, d * s, d * s, 0, PI);
      rect((cx - d/2) * s, (cy - rectAltoBase) * s, d * s, rectAltoBase * s);
      break;
    case 2: // más angosta
      arc(cx * s, cy * s, (d * 0.6) * s, (d * 0.6) * s, PI, TWO_PI);
      rect((cx - d*0.3) * s, cy * s, (d * 0.6) * s, rectAltoBase * s);
      break;
    case 3: // ubicada a la izquierda
      cx = 160;
      arc(cx * s, cy * s, d * s, d * s, PI, TWO_PI);
      rect((cx - d/2) * s, cy * s, d * s, rectAltoBase * s);
      break;
    default: // original
      arc(cx * s, cy * s, d * s, d * s, PI, TWO_PI);
      rect((cx - d/2) * s, cy * s, d * s, rectAltoBase * s);
  }
  
  aplicarFlash(F_ARCADA, 60 * s, 250 * s, 380 * s, 160 * s);
}

// ============================================================
// 8. CUADRADO ROJO — 4 variantes
// ============================================================
void dibujarCuadradoRojo() {
  int v = variantes[F_CUADRADO_ROJO];
  float x = 270, y = 400, w = 152, h = 100;
  
  fill(colorDePaleta(SLOT_CUADRADO_ROJO));
  noStroke();
  
  switch (v) {
    case 1: // triángulo equivalente (punta arriba)
      triangle(x * s, (y+h) * s, (x+w) * s, (y+h) * s, (x+w/2) * s, y * s);
      break;
    case 2: // semicírculo apoyado abajo
      arc((x + w/2) * s, (y + h) * s, w * s, h*2 * s, PI, TWO_PI);
      break;
    case 3: // más alto y angosto
      rect((x + 25) * s, (y - 40) * s, (w - 50) * s, (h + 40) * s);
      break;
    default: // original
      rect(x * s, y * s, w * s, h * s);
  }
  
  aplicarFlash(F_CUADRADO_ROJO, x * s, (y - 40) * s, w * s, (h + 40) * s);
}

// ============================================================
// 9. PÍLDORA VERDE — 4 variantes
// ============================================================
void dibujarPildoraVerde() {
  int v = variantes[F_PILDORA];
  float x, y, w, h, r;
  
  switch (v) {
    case 1: // vertical más larga
      x = 205; y = 340; w = 45; h = 130; r = 22;
      break;
    case 2: // horizontal chica
      x = 175; y = 390; w = 110; h = 45; r = 22;
      break;
    case 3: // más grande cuadrada redondeada
      x = 195; y = 365; w = 95; h = 95; r = 40;
      break;
    default: // original
      x = 205; y = 375; w = 75; h = 75; r = 35;
  }
  
  fill(colorDePaleta(SLOT_PILDORA));
  noStroke();
  rect(x * s, y * s, w * s, h * s, r * s);
  
  aplicarFlash(F_PILDORA, x * s, y * s, w * s, h * s);
}

// ============================================================
// 10. MOTIVO — 4 variantes (una por esquina)
// ============================================================
void dibujarMotivo() {
  int v = variantes[F_MOTIVO];
  float lado = ladoMotivo();
  float half = lado / 2.0;
  float cx, cy;
  
  switch (v) {
    case 1: // esquina inf-izquierda
      cx = half; cy = 500 - half;
      break;
    case 2: // esquina sup-derecha
      cx = 500 - half; cy = half;
      break;
    case 3: // esquina sup-izquierda
      cx = half; cy = half;
      break;
    default: // inf-derecha (original)
      cx = 500 - half; cy = 500 - half;
  }
  
  float x1 = (cx - half) * s;
  float y1 = (cy - half) * s;
  float x2 = (cx + half) * s;
  float y2 = (cy + half) * s;
  float mx = cx * s;
  float my = cy * s;
  
  noStroke();
  fill(colorDePaleta(SLOT_MOTIVO_SUP));  triangle(x1, y1, x2, y1, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_DER));  triangle(x2, y1, x2, y2, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_INF));  triangle(x2, y2, x1, y2, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_IZQ));  triangle(x1, y2, x1, y1, mx, my);
  
  aplicarFlash(F_MOTIVO, x1, y1, lado * s, lado * s);
}

// ============================================================
// MUTACIÓN — tecla R
// ============================================================
void mutarUnaForma() {
  int intentos = 0;
  while (intentos < MAX_INTENTOS_MUTACION) {
    int forma = int(random(NUM_FORMAS));
    int varActual = variantes[forma];
    int varNueva = int(random(VARIANTES_POR_FORMA));
    
    // asegurarse de que la variante sea distinta
    if (varNueva == varActual) {
      varNueva = (varNueva + 1) % VARIANTES_POR_FORMA;
    }
    
    variantes[forma] = varNueva;
    flashFrames[forma] = FLASH_DURACION;
    return;
  }
}

void resetearMutaciones() {
  for (int i = 0; i < NUM_FORMAS; i++) {
    variantes[i] = 0;
    flashFrames[i] = FLASH_DURACION;
  }
}

// ============================================================
// CONTROLES
// ============================================================
void keyPressed() {
  if (key == ' ') {
    indicePaleta = (indicePaleta + 1) % NUM_PALETAS;
  }
  if (key == '+' || key == '=' || keyCode == UP) {
    intensidad = min(1.0, intensidad + PASO_INTENSIDAD);
  }
  if (key == '-' || keyCode == DOWN) {
    intensidad = max(0.0, intensidad - PASO_INTENSIDAD);
  }
  if (key == 'r' || key == 'R') {
    mutarUnaForma();
  }
  if (key == 'x' || key == 'X') {
    resetearMutaciones();
  }
  if (key == 'd' || key == 'D') {
    modoDebug = !modoDebug;
  }
}

// ============================================================
// DEBUG
// ============================================================
void dibujarDebug() {
  noStroke();
  fill(0, 0, 0, 180);
  rect(10, 10, 330, 220);
  fill(255);
  textSize(12);
  textAlign(LEFT, TOP);
  text("=== DEBUG ===", 20, 18);
  text("Paleta: " + indicePaleta + " / " + (NUM_PALETAS - 1), 20, 36);
  text("Intensidad: " + nf(intensidad, 1, 2), 20, 52);
  text("Grosor borde: " + nf(grosorBordeBlanco(), 1, 1), 20, 68);
  text("Lado motivo: " + nf(ladoMotivo(), 1, 1), 20, 84);
  text("Variantes:", 20, 104);
  String linea = "";
  for (int i = 0; i < NUM_FORMAS; i++) {
    linea += variantes[i];
    if (i < NUM_FORMAS - 1) linea += " ";
  }
  text("[" + linea + "]", 20, 120);
  text("UP/DOWN=intensidad  SPACE=paleta", 20, 150);
  text("R=mutar forma  X=reset  D=debug", 20, 166);
  text("FPS: " + nf(frameRate, 2, 1), 20, 200);
}
