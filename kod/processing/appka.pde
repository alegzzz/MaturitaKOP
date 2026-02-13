import processing.serial.*;

Serial port;
String angle="", distance="", data="";
float pixsDistance;
int iAngle, iDistance, index1=0;


color radarColor = color(98, 245, 31);   
color objectColor = color(255, 10, 10);
boolean showMenu = true;
boolean useMetric = true; 
float fadeAmount = 20;    

void setup() {
  size(1920, 1080);
  smooth();
  port = new Serial(this, "COM3", 9600);
  port.bufferUntil('.');
}


int langIndex = 0; 
String[] langNames = {"EN", "SK", "FR", "ES", "RU"};
String[][] translations = {
  // EN
  {"Angle", "Distance", "Out of Range", "Units", "Radar Theme",
  "Target Color", "Language", "Trail", "Green", "Blue", "White",
  "Pink", "Orange", "Red", "Yellow", "Metric", "Imperial", "Short", 
  "Long", "Press 'M' to Toggle Menu"},
  // SK
  {"Uhol", "Vzdialenosť", "Mimo dosahu", "Jednotky", "Farba radaru", 
  "Farba cieľa", "Jazyk", "Stopa", "Zelená", "Modrá", "Biela", "Ružová",
  "Oranžová", "Červená", "Žltá", "Metrické", "Imperiálne", "Krátka", "Dlhá",
  "Stlačte 'M' pre Menu"},
  // FR
  {"Angle", "Distance", "Hors de portée", "Unités", "Thème Radar", "Couleur Cible",
  "Langue", "Trace", "Vert", "Bleu", "Blanc", "Rose", "Orange", "Rouge", "Jaune",
  "Métrique", "Impérial", "Courte", "Longue", "Appuyez sur 'M' pour le Menu"},
  // ES
  {"Ángulo", "Distancia", "Fuera de rango", "Unidades", "Color del Radar",
  "Color de Objetivo", "Idioma", "Rastro", "Verde", "Azul", "Blanco", "Rosa",
  "Naranja", "Rojo", "Amarillo", "Métrico", "Imperial", "Corto", "Largo", 
  "Presione 'M' para el Menú"},
  // RU
  {"Угол", "Расстояние", "Вне зоны", "Единицы", "Тема радара", "Цвет цели", "Язык",
  "След", "Зеленый", "Синий", "Белый", "Розовый", "Оранжевый", "Красный", "Желтый",
  "Метрическая", "Имперская", "Короткий", "Длинный", "Нажмите 'M' для меню"}
};

void serialEvent (Serial port) { 
  data = port.readStringUntil('.');
  if (data != null) {
    data = data.substring(0, data.length()-1);
    index1 = data.indexOf(",");
    if (index1 > -1) {
      angle= data.substring(0, index1);
      distance= data.substring(index1+1, data.length());
      iAngle = int(angle);
      iDistance = int(distance);
    }
  }
}

void draw() {
  noStroke();
  fill(0, fadeAmount);  
  rect(0, 0, width, height-height*0.065);  

  drawRadar();  
  drawLine();
  drawObject();
  drawText();
  drawMenu();
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.074);
  noFill();
  strokeWeight(2);
  stroke(radarColor);

  arc(0, 0, (width-width*0.0625), (width-width*0.0625), PI, TWO_PI);
  arc(0, 0, (width-width*0.27), (width-width*0.27), PI, TWO_PI);
  arc(0, 0, (width-width*0.479), (width-width*0.479), PI, TWO_PI);
  arc(0, 0, (width-width*0.687), (width-width*0.687), PI, TWO_PI);

  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.074);
  strokeWeight(9);
  stroke(objectColor);
  pixsDistance = iDistance*((height-height*0.1666)*0.025);
  if (iDistance < 40) {
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), (width-width*0.505)*cos(radians(iAngle)), -(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(radarColor);
  translate(width/2, height-height*0.074);
  line(0, 0, (height-height*0.12)*cos(radians(iAngle)), -(height-height*0.12)*sin(radians(iAngle)));
  popMatrix();
}

void drawText() { 
  pushMatrix();
  fill(0); noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(radarColor);
  
  String unitLabel = useMetric ? "cm" : "in";
  float displayDistance = useMetric ? iDistance : iDistance * 0.3937;
  
  textSize(25);
  text(useMetric ? "10cm" : "4in", width-width*0.3854, height-height*0.0833);
  text(useMetric ? "20cm" : "8in", width-width*0.281, height-height*0.0833);
  text(useMetric ? "30cm" : "12in", width-width*0.177, height-height*0.0833);
  text(useMetric ? "40cm" : "16in", width-width*0.0729, height-height*0.0833);
  
  textSize(40);
  text(translations[langIndex][0] + ": " + iAngle + "°", width-width*0.48, height-height*0.0277);
  
  String distStr = (iDistance < 40) ? nf(displayDistance, 0, 1) + " " + unitLabel : translations[langIndex][2];
  text(translations[langIndex][1] + ": " + distStr, width-width*0.31, height-height*0.0277);
  popMatrix();
}

void drawMenu() {
  fill(255);
  textSize(15);
  text(translations[langIndex][19], 20, 30);
  
  if (!showMenu) return;

  fill(20, 240); 
  stroke(radarColor);
  strokeWeight(2);
  rect(10, 50, 260, 620, 10);
  
  fill(255); textSize(18); 
  
  text(translations[langIndex][4], 30, 80);
  drawColorButton(30, 100, color(98, 245, 31), translations[langIndex][8]);  
  drawColorButton(130, 100, color(31, 150, 245), translations[langIndex][9]); 
  drawColorButton(30, 135, color(255, 255, 255), translations[langIndex][10]); 
  drawColorButton(130, 135, color(255, 20, 147), translations[langIndex][11]); 
  drawColorButton(30, 170, color(255, 150, 0), translations[langIndex][12]);   

  text(translations[langIndex][5], 30, 225);
  drawColorButton(30, 240, color(255, 10, 10), translations[langIndex][13]);  
  drawColorButton(130, 240, color(255, 255, 0), translations[langIndex][14]); 
  drawColorButton(30, 275, color(0, 255, 0), translations[langIndex][8]);     
  drawColorButton(130, 275, color(0, 200, 255), translations[langIndex][9]);   

  text(translations[langIndex][3], 30, 335);
  drawTextButton(30, 350, 90, 30, translations[langIndex][15], useMetric);
  drawTextButton(140, 350, 90, 30, translations[langIndex][16], !useMetric);
  
  text(translations[langIndex][7], 30, 420);
  drawTextButton(30, 435, 90, 30, translations[langIndex][17], fadeAmount == 60);
  drawTextButton(140, 435, 90, 30, translations[langIndex][18], fadeAmount == 10);

  text(translations[langIndex][6], 30, 500);
  for(int i=0; i<langNames.length; i++) {
    int row = i / 3;
    int col = i % 3;
    drawTextButton(30 + (col*80), 520 + (row*40), 70, 30, langNames[i], langIndex == i);
  }
}

void drawColorButton(int x, int y, color c, String label) {
  stroke(255);
  fill(c);
  rect(x, y, 25, 25, 5);
  fill(200);
  textSize(14);
  text(label, x + 35, y + 18);
}

void drawTextButton(int x, int y, int w, int h, String label, boolean active) {
  stroke(active ? radarColor : 100);
  fill(active ? 50 : 20);
  rect(x, y, w, h, 5);
  fill(active ? 255 : 150);
  textAlign(CENTER, CENTER);
  textSize(12);
  text(label, x + w/2, y + h/2);
  textAlign(LEFT, BASELINE); 
}

void mousePressed() {
  if (!showMenu) return;
  
  if (mouseX > 30 && mouseX < 120) {
    if (mouseY > 100 && mouseY < 125) radarColor = color(98, 245, 31);
    if (mouseY > 135 && mouseY < 160) radarColor = color(255, 255, 255);
    if (mouseY > 170 && mouseY < 195) radarColor = color(255, 150, 0);
  }
  if (mouseX > 130 && mouseX < 220) {
    if (mouseY > 100 && mouseY < 125) radarColor = color(31, 150, 245);
    if (mouseY > 135 && mouseY < 160) radarColor = color(255, 20, 147);
  }
  
  if (mouseY > 240 && mouseY < 265) {
    if (mouseX > 30 && mouseX < 120) objectColor = color(255, 10, 10);
    if (mouseX > 130 && mouseX < 220) objectColor = color(255, 255, 0);
  }
  if (mouseY > 275 && mouseY < 300) {
    if (mouseX > 30 && mouseX < 120) objectColor = color(0, 255, 0);
    if (mouseX > 130 && mouseX < 220) objectColor = color(0, 200, 255);
  }
  
  if (mouseY > 350 && mouseY < 380) {
    if (mouseX > 30 && mouseX < 120) useMetric = true;
    if (mouseX > 140 && mouseX < 230) useMetric = false;
  }
  
  if (mouseY > 435 && mouseY < 465) {
    if (mouseX > 30 && mouseX < 120) fadeAmount = 60; 
    if (mouseX > 140 && mouseX < 230) fadeAmount = 10; 
  }

  if (mouseY > 520 && mouseY < 600) {
    for(int i=0; i<langNames.length; i++) {
      int row = i / 3;
      int col = i % 3;
      int x = 30 + (col*80);
      int y = 520 + (row*40);
      if(mouseX > x && mouseX < x+70 && mouseY > y && mouseY < y+30) {
        langIndex = i;
      }
    }
  }
}

void keyPressed() {
  if (key == 'm' || key == 'M') {
    showMenu = !showMenu;
    if (!showMenu) {
      fill(0); 
      noStroke();
      rect(0, 0, 300, 700); 
    }
  }

  if (key == CODED) {
    if (keyCode == LEFT) {
      port.write('a');
    } else if (keyCode == RIGHT) {
      port.write('d');
    }
  } else {
    if (key == 'a' || key == 'A') {
      port.write('a');
    } else if (key == 'd' || key == 'D') {
      port.write('d');
    } else if (key == 's' || key == 'S') {
      port.write('m');
    }
  }
}
