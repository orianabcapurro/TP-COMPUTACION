// ============================================================
// IMA PICO GENERATIVE — Port a p5.js (para GitHub Pages)
// Replica la lógica del sketch de Processing Java Mode.
// Fuente oficial: ima_pico_generative/ima_pico_generative.pde
// ============================================================

const LADO = 600;
const MARCO = 22;
const GRID = 500.0;
let s;

// --- PALETAS ---
const NUM_PALETAS = 4;
const COLORES_POR_PALETA = 14;
const paletas = Array.from({ length: NUM_PALETAS }, () => new Array(COLORES_POR_PALETA));
let indicePaleta = 0;

// Slots
const SLOT_FONDO          = 0;
const SLOT_ZIGZAG         = 1;
const SLOT_ONDA           = 2;
const SLOT_CUARTO_CIRCULO = 3;
const SLOT_BARRA_AMARILLA = 4;
const SLOT_RECT_AZUL      = 5;
const SLOT_TRIANGULO      = 6;
const SLOT_ARCADA         = 7;
const SLOT_CUADRADO_ROJO  = 8;
const SLOT_PILDORA        = 9;
const SLOT_MOTIVO_SUP     = 10;
const SLOT_MOTIVO_DER     = 11;
const SLOT_MOTIVO_INF     = 12;
const SLOT_MOTIVO_IZQ     = 13;

// --- INTENSIDAD ---
let intensidad = 0.0;
const PASO_INTENSIDAD = 0.05;
const GROSOR_BORDE_MIN = 12.0;
const GROSOR_BORDE_MAX = 32.0;
const AMPL_ZIGZAG_MIN = 1.0;
const AMPL_ZIGZAG_MAX = 1.8;
const AMPL_ONDA_MIN   = 1.0;
const AMPL_ONDA_MAX   = 1.4;
const ZIGZAG_EJE_X = -30;
const ONDA_EJE_X   = 510;
const FACTOR_SAT_MIN = 0.85;
const FACTOR_SAT_MAX = 1.15;
const FACTOR_BR_MIN  = 0.95;
const FACTOR_BR_MAX  = 1.10;
const MOTIVO_LADO_MIN = 70;
const MOTIVO_LADO_MAX = 110;

// --- MUTACIÓN ---
const NUM_FORMAS = 10;
const F_ZIGZAG = 0, F_ONDA = 1, F_CUARTO_CIRCULO = 2, F_BARRA_AMARILLA = 3,
      F_RECT_AZUL = 4, F_TRIANGULO = 5, F_ARCADA = 6, F_CUADRADO_ROJO = 7,
      F_PILDORA = 8, F_MOTIVO = 9;

const VARIANTES_POR_FORMA = 4;
const variantes = new Array(NUM_FORMAS).fill(0);
const flashFrames = new Array(NUM_FORMAS).fill(0);
const FLASH_DURACION = 20;

let modoDebug = false;

// ============================================================
function setup() {
  const canvas = createCanvas(LADO, LADO);
  canvas.parent("canvas-container");
  s = (LADO - 2 * MARCO) / GRID;
  inicializarPaletas();
}

// ============================================================
function inicializarPaletas() {
  paletas[0][SLOT_FONDO]          = "#0C482E";
  paletas[0][SLOT_ZIGZAG]         = "#602143";
  paletas[0][SLOT_ONDA]           = "#88B914";
  paletas[0][SLOT_CUARTO_CIRCULO] = "#D63583";
  paletas[0][SLOT_BARRA_AMARILLA] = "#F0B000";
  paletas[0][SLOT_RECT_AZUL]      = "#1C3D92";
  paletas[0][SLOT_TRIANGULO]      = "#2FA7D1";
  paletas[0][SLOT_ARCADA]         = "#BA81B9";
  paletas[0][SLOT_CUADRADO_ROJO]  = "#D12731";
  paletas[0][SLOT_PILDORA]        = "#279E39";
  paletas[0][SLOT_MOTIVO_SUP]     = "#00A4B2";
  paletas[0][SLOT_MOTIVO_DER]     = "#1D1D1B";
  paletas[0][SLOT_MOTIVO_INF]     = "#FBDF15";
  paletas[0][SLOT_MOTIVO_IZQ]     = "#F15C29";

  paletas[1][SLOT_FONDO]          = "#2B1A4C";
  paletas[1][SLOT_ZIGZAG]         = "#D63583";
  paletas[1][SLOT_ONDA]           = "#2FA7D1";
  paletas[1][SLOT_CUARTO_CIRCULO] = "#F0B000";
  paletas[1][SLOT_BARRA_AMARILLA] = "#88B914";
  paletas[1][SLOT_RECT_AZUL]      = "#00A4B2";
  paletas[1][SLOT_TRIANGULO]      = "#BA81B9";
  paletas[1][SLOT_ARCADA]         = "#F15C29";
  paletas[1][SLOT_CUADRADO_ROJO]  = "#1C3D92";
  paletas[1][SLOT_PILDORA]        = "#FBDF15";
  paletas[1][SLOT_MOTIVO_SUP]     = "#D12731";
  paletas[1][SLOT_MOTIVO_DER]     = "#1D1D1B";
  paletas[1][SLOT_MOTIVO_INF]     = "#88B914";
  paletas[1][SLOT_MOTIVO_IZQ]     = "#D63583";

  paletas[2][SLOT_FONDO]          = "#0F1E4D";
  paletas[2][SLOT_ZIGZAG]         = "#F15C29";
  paletas[2][SLOT_ONDA]           = "#FBDF15";
  paletas[2][SLOT_CUARTO_CIRCULO] = "#00A4B2";
  paletas[2][SLOT_BARRA_AMARILLA] = "#D63583";
  paletas[2][SLOT_RECT_AZUL]      = "#D12731";
  paletas[2][SLOT_TRIANGULO]      = "#F0B000";
  paletas[2][SLOT_ARCADA]         = "#88B914";
  paletas[2][SLOT_CUADRADO_ROJO]  = "#BA81B9";
  paletas[2][SLOT_PILDORA]        = "#2FA7D1";
  paletas[2][SLOT_MOTIVO_SUP]     = "#88B914";
  paletas[2][SLOT_MOTIVO_DER]     = "#1D1D1B";
  paletas[2][SLOT_MOTIVO_INF]     = "#D63583";
  paletas[2][SLOT_MOTIVO_IZQ]     = "#F0B000";

  paletas[3][SLOT_FONDO]          = "#103A2E";
  paletas[3][SLOT_ZIGZAG]         = "#1C3D92";
  paletas[3][SLOT_ONDA]           = "#F0B000";
  paletas[3][SLOT_CUARTO_CIRCULO] = "#00A4B2";
  paletas[3][SLOT_BARRA_AMARILLA] = "#D63583";
  paletas[3][SLOT_RECT_AZUL]      = "#F15C29";
  paletas[3][SLOT_TRIANGULO]      = "#BA81B9";
  paletas[3][SLOT_ARCADA]         = "#FBDF15";
  paletas[3][SLOT_CUADRADO_ROJO]  = "#D63583";
  paletas[3][SLOT_PILDORA]        = "#88B914";
  paletas[3][SLOT_MOTIVO_SUP]     = "#D12731";
  paletas[3][SLOT_MOTIVO_DER]     = "#1D1D1B";
  paletas[3][SLOT_MOTIVO_INF]     = "#2FA7D1";
  paletas[3][SLOT_MOTIVO_IZQ]     = "#F0B000";
}

function colorDePaleta(slot) {
  return ajustarColor(paletas[indicePaleta][slot]);
}

function grosorBordeBlanco() { return lerp(GROSOR_BORDE_MIN, GROSOR_BORDE_MAX, intensidad); }
function amplitudZigzag()    { return lerp(AMPL_ZIGZAG_MIN,  AMPL_ZIGZAG_MAX,  intensidad); }
function amplitudOnda()      { return lerp(AMPL_ONDA_MIN,    AMPL_ONDA_MAX,    intensidad); }
function ladoMotivo()        { return lerp(MOTIVO_LADO_MIN,  MOTIVO_LADO_MAX,  intensidad); }

function amplificar(valor, eje, factor) {
  return eje + (valor - eje) * factor;
}

function ajustarColor(c) {
  const fSat = lerp(FACTOR_SAT_MIN, FACTOR_SAT_MAX, intensidad);
  const fBr  = lerp(FACTOR_BR_MIN,  FACTOR_BR_MAX,  intensidad);
  push();
  colorMode(HSB, 360, 100, 100);
  const col = color(c);
  const h  = hue(col);
  const sa = constrain(saturation(col) * fSat, 0, 100);
  const br = constrain(brightness(col) * fBr,  0, 100);
  const resultado = color(h, sa, br);
  pop();
  return resultado;
}

// ============================================================
function draw() {
  background(255);

  push();
  translate(MARCO, MARCO);

  noStroke();
  fill(colorDePaleta(SLOT_FONDO));
  rect(0, 0, GRID * s, GRID * s);

  drawingContext.save();
  drawingContext.beginPath();
  drawingContext.rect(0, 0, GRID * s, GRID * s);
  drawingContext.clip();

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

  drawingContext.restore();

  for (let i = 0; i < NUM_FORMAS; i++) {
    if (flashFrames[i] > 0) flashFrames[i]--;
  }

  pop();

  if (modoDebug) dibujarDebug();
}

function aplicarFlash(idxForma, x, y, w, h) {
  if (flashFrames[idxForma] <= 0) return;
  const alpha = map(flashFrames[idxForma], 0, FLASH_DURACION, 0, 200);
  push();
  noStroke();
  fill(255, alpha);
  rect(x, y, w, h);
  pop();
}

// ============================================================
// 1. ZIGZAG
// ============================================================
function dibujarFormaZigzag() {
  const v = variantes[F_ZIGZAG];
  let zz, ejeX;

  switch (v) {
    case 1:
      zz = [[-30, 230], [110, 300], [30, 350], [130, 400], [40, 450], [200, 530]];
      ejeX = -30; break;
    case 2:
      zz = [[530, 250], [375, 365], [460, 430], [290, 530]];
      ejeX = 530; break;
    case 3:
      zz = [[-30, 230], [180, 340], [30, 400], [250, 530]];
      ejeX = -30; break;
    default:
      zz = [[-30, 250], [125, 365], [40, 430], [210, 530]];
      ejeX = -30;
  }

  const a = amplitudZigzag();
  const p = zz.map(pt => [amplificar(pt[0], ejeX, a), pt[1]]);

  fill(colorDePaleta(SLOT_ZIGZAG));
  noStroke();
  beginShape();
  for (const pt of p) vertex(pt[0] * s, pt[1] * s);
  vertex(ejeX * s, 530 * s);
  endShape(CLOSE);

  stroke("#FBFCFC");
  strokeWeight(grosorBordeBlanco() * s);
  noFill();
  strokeCap(SQUARE);
  strokeJoin(MITER);
  beginShape();
  for (const pt of p) vertex(pt[0] * s, pt[1] * s);
  endShape();
  noStroke();

  aplicarFlash(F_ZIGZAG, (min(ejeX, 290)) * s, 220 * s, 320 * s, 320 * s);
}

// ============================================================
// 2. ONDA
// ============================================================
function dibujarFormaOnda() {
  const v = variantes[F_ONDA];
  const a = amplitudOnda();
  let xs, ejeX, espejada = false;

  switch (v) {
    case 1:
      xs = [320, 470, 470, 320, 190, 560, 450, 510, 510];
      ejeX = 510; break;
    case 2:
      xs = [175, 60, 60, 175, 290, -30, 55, 20, 0];
      ejeX = 0; espejada = true; break;
    case 3:
      xs = [380, 470, 470, 380, 280, 520, 450, 480, 510];
      ejeX = 510; break;
    default:
      xs = [335, 450, 450, 335, 220, 530, 455, 490, 510];
      ejeX = 510;
  }

  const ax = xs.map(x => amplificar(x, ejeX, a));

  fill(colorDePaleta(SLOT_ONDA));
  noStroke();
  beginShape();
  vertex(ax[0] * s, -10 * s);
  bezierVertex(ax[1] * s,  45 * s, ax[2] * s,  65 * s, ax[3] * s, 115 * s);
  bezierVertex(ax[4] * s, 160 * s, ax[5] * s, 175 * s, ax[6] * s, 255 * s);
  bezierVertex(ax[7] * s, 330 * s, ax[8] * s, 370 * s, ejeX   * s, 400 * s);
  vertex(ejeX * s, -10 * s);
  endShape(CLOSE);

  stroke("#FBFCFC");
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

  const flashX = espejada ? 0 : 200;
  aplicarFlash(F_ONDA, flashX * s, 0, 310 * s, 410 * s);
}

// ============================================================
// 3. CUARTO DE CÍRCULO
// ============================================================
function dibujarCuartoCirculoRosa() {
  const v = variantes[F_CUARTO_CIRCULO];
  const d = 210 * s;
  let cx = 0, cy = 0, startAng = 0, stopAng = HALF_PI;

  switch (v) {
    case 1: cx = GRID * s; cy = 0;        startAng = HALF_PI;      stopAng = PI; break;
    case 2: cx = 0;        cy = GRID * s; startAng = -HALF_PI;     stopAng = 0;  break;
    case 3: cx = GRID * s; cy = GRID * s; startAng = PI;           stopAng = PI + HALF_PI; break;
    default: cx = 0; cy = 0; startAng = 0; stopAng = HALF_PI;
  }

  fill(colorDePaleta(SLOT_CUARTO_CIRCULO));
  noStroke();
  arc(cx, cy, d, d, startAng, stopAng, PIE);

  aplicarFlash(F_CUARTO_CIRCULO, cx - d/2, cy - d/2, d, d);
}

// ============================================================
// 4. BARRA AMARILLA
// ============================================================
function dibujarBarraAmarilla() {
  const v = variantes[F_BARRA_AMARILLA];
  let x, y, w, h;
  switch (v) {
    case 1: x = 0;   y = 300; w = 35; h = 85; break;
    case 2: x = 415; y = 142; w = 85; h = 35; break;
    case 3: x = 60;  y = 465; w = 85; h = 35; break;
    default: x = 0; y = 142; w = 85; h = 35;
  }
  fill(colorDePaleta(SLOT_BARRA_AMARILLA));
  noStroke();
  rect(x * s, y * s, w * s, h * s);
  aplicarFlash(F_BARRA_AMARILLA, x * s, y * s, w * s, h * s);
}

// ============================================================
// 5. RECT AZUL
// ============================================================
function dibujarRectanguloAzul() {
  const v = variantes[F_RECT_AZUL];
  let x, y, w, h;
  switch (v) {
    case 1: x = 0;   y = 0; w = 140; h = 95;  break;
    case 2: x = 330; y = 0; w = 170; h = 95;  break;
    case 3: x = 405; y = 0; w = 95;  h = 190; break;
    default: x = 105; y = 0; w = 190; h = 95;
  }
  fill(colorDePaleta(SLOT_RECT_AZUL));
  noStroke();
  rect(x * s, y * s, w * s, h * s);
  aplicarFlash(F_RECT_AZUL, x * s, y * s, w * s, h * s);
}

// ============================================================
// 6. TRIÁNGULO CELESTE
// ============================================================
function dibujarTrianguloCeleste() {
  const v = variantes[F_TRIANGULO];
  let x1, y1, x2, y2, x3, y3;
  switch (v) {
    case 1: x1 = 105; y1 = 250; x2 = 295; y2 = 250; x3 = 200; y3 = 95;  break;
    case 2: x1 = 295; y1 = 95;  x2 = 295; y2 = 250; x3 = 105; y3 = 170; break;
    case 3: x1 = 105; y1 = 95;  x2 = 105; y2 = 250; x3 = 295; y3 = 170; break;
    default: x1 = 105; y1 = 95; x2 = 295; y2 = 95; x3 = 200; y3 = 250;
  }
  fill(colorDePaleta(SLOT_TRIANGULO));
  noStroke();
  triangle(x1 * s, y1 * s, x2 * s, y2 * s, x3 * s, y3 * s);
  aplicarFlash(F_TRIANGULO, 105 * s, 95 * s, 190 * s, 160 * s);
}

// ============================================================
// 7. ARCADA LAVANDA
// ============================================================
function dibujarArcadaLavanda() {
  const v = variantes[F_ARCADA];
  let cx = 330, cy = 350, d = 185, rectAltoBase = 50;

  fill(colorDePaleta(SLOT_ARCADA));
  noStroke();

  switch (v) {
    case 1:
      arc(cx * s, cy * s, d * s, d * s, 0, PI, PIE);
      rect((cx - d/2) * s, (cy - rectAltoBase) * s, d * s, rectAltoBase * s);
      break;
    case 2:
      arc(cx * s, cy * s, (d * 0.6) * s, (d * 0.6) * s, PI, TWO_PI, PIE);
      rect((cx - d*0.3) * s, cy * s, (d * 0.6) * s, rectAltoBase * s);
      break;
    case 3:
      cx = 160;
      arc(cx * s, cy * s, d * s, d * s, PI, TWO_PI, PIE);
      rect((cx - d/2) * s, cy * s, d * s, rectAltoBase * s);
      break;
    default:
      arc(cx * s, cy * s, d * s, d * s, PI, TWO_PI, PIE);
      rect((cx - d/2) * s, cy * s, d * s, rectAltoBase * s);
  }

  aplicarFlash(F_ARCADA, 60 * s, 250 * s, 380 * s, 160 * s);
}

// ============================================================
// 8. CUADRADO ROJO
// ============================================================
function dibujarCuadradoRojo() {
  const v = variantes[F_CUADRADO_ROJO];
  const x = 270, y = 400, w = 152, h = 100;

  fill(colorDePaleta(SLOT_CUADRADO_ROJO));
  noStroke();

  switch (v) {
    case 1:
      triangle(x * s, (y+h) * s, (x+w) * s, (y+h) * s, (x+w/2) * s, y * s);
      break;
    case 2:
      arc((x + w/2) * s, (y + h) * s, w * s, h*2 * s, PI, TWO_PI, PIE);
      break;
    case 3:
      rect((x + 25) * s, (y - 40) * s, (w - 50) * s, (h + 40) * s);
      break;
    default:
      rect(x * s, y * s, w * s, h * s);
  }

  aplicarFlash(F_CUADRADO_ROJO, x * s, (y - 40) * s, w * s, (h + 40) * s);
}

// ============================================================
// 9. PÍLDORA VERDE
// ============================================================
function dibujarPildoraVerde() {
  const v = variantes[F_PILDORA];
  let x, y, w, h, r;
  switch (v) {
    case 1: x = 205; y = 340; w = 45;  h = 130; r = 22; break;
    case 2: x = 175; y = 390; w = 110; h = 45;  r = 22; break;
    case 3: x = 195; y = 365; w = 95;  h = 95;  r = 40; break;
    default: x = 205; y = 375; w = 75; h = 75;  r = 35;
  }
  fill(colorDePaleta(SLOT_PILDORA));
  noStroke();
  rect(x * s, y * s, w * s, h * s, r * s);
  aplicarFlash(F_PILDORA, x * s, y * s, w * s, h * s);
}

// ============================================================
// 10. MOTIVO 4 TRIÁNGULOS
// ============================================================
function dibujarMotivo() {
  const v = variantes[F_MOTIVO];
  const lado = ladoMotivo();
  const half = lado / 2.0;
  let cx, cy;
  switch (v) {
    case 1: cx = half;         cy = 500 - half;  break;
    case 2: cx = 500 - half;   cy = half;        break;
    case 3: cx = half;         cy = half;        break;
    default: cx = 500 - half;  cy = 500 - half;
  }

  const x1 = (cx - half) * s;
  const y1 = (cy - half) * s;
  const x2 = (cx + half) * s;
  const y2 = (cy + half) * s;
  const mx = cx * s;
  const my = cy * s;

  noStroke();
  fill(colorDePaleta(SLOT_MOTIVO_SUP));  triangle(x1, y1, x2, y1, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_DER));  triangle(x2, y1, x2, y2, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_INF));  triangle(x2, y2, x1, y2, mx, my);
  fill(colorDePaleta(SLOT_MOTIVO_IZQ));  triangle(x1, y2, x1, y1, mx, my);

  aplicarFlash(F_MOTIVO, x1, y1, lado * s, lado * s);
}

// ============================================================
// MUTACIÓN
// ============================================================
function mutarUnaForma() {
  const forma = floor(random(NUM_FORMAS));
  const varActual = variantes[forma];
  let varNueva = floor(random(VARIANTES_POR_FORMA));
  if (varNueva === varActual) {
    varNueva = (varNueva + 1) % VARIANTES_POR_FORMA;
  }
  variantes[forma] = varNueva;
  flashFrames[forma] = FLASH_DURACION;
}

function resetearMutaciones() {
  for (let i = 0; i < NUM_FORMAS; i++) {
    variantes[i] = 0;
    flashFrames[i] = FLASH_DURACION;
  }
}

// ============================================================
// CONTROLES
// ============================================================
function keyPressed() {
  if (key === ' ') {
    indicePaleta = (indicePaleta + 1) % NUM_PALETAS;
  }
  if (key === '+' || key === '=' || keyCode === UP_ARROW) {
    intensidad = min(1.0, intensidad + PASO_INTENSIDAD);
  }
  if (key === '-' || keyCode === DOWN_ARROW) {
    intensidad = max(0.0, intensidad - PASO_INTENSIDAD);
  }
  if (key === 'r' || key === 'R') {
    mutarUnaForma();
  }
  if (key === 'x' || key === 'X') {
    resetearMutaciones();
  }
  if (key === 'd' || key === 'D') {
    modoDebug = !modoDebug;
  }
  // Evita que el scroll haga jump con las flechas
  if (keyCode === UP_ARROW || keyCode === DOWN_ARROW) return false;
}

// ============================================================
// DEBUG
// ============================================================
function dibujarDebug() {
  push();
  noStroke();
  fill(0, 180);
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
  text("[" + variantes.join(" ") + "]", 20, 120);
  text("UP/DOWN=intensidad  SPACE=paleta", 20, 150);
  text("R=mutar forma  X=reset  D=debug", 20, 166);
  text("FPS: " + nf(frameRate(), 2, 1), 20, 200);
  pop();
}
