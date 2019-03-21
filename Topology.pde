import peasy.*;

boolean firstFrame = true;

float scale = 50;
int planeWidth = 50;
int[][] plane = new int[planeWidth][planeWidth];
PVector position = new PVector(scale * planeWidth/2, scale * planeWidth/2);

boolean keyControls[] = {false, false, false, false};

PVector mouseLast;
float angle = 0;
float angle2 = PI/8;

void setup() {
  size(1280, 640, P3D);
  colorMode(HSB, 255);
  for (int y = -planeWidth/2; y < planeWidth/2; y++) {
    for (int x = -planeWidth/2; x < planeWidth/2; x++) {
      plane[x + planeWidth/2][y + planeWidth/2] = 100;
    }
  }
}

void draw() {
  if (firstFrame) {
    firstFrame = false;
    angle = 0;
    angle2 = PI/8;
  }
  background(150, 255, 255);
  camera(position.x, position.y, -100, 
    position.x + 10*sin(angle), position.y + 10*cos(angle), -100 + 10*sin(angle2), 
    0, 0, 1);
  
  drawPlanes();
  
  if (keyControls[0]) {
    position.y += 3 * cos(angle);
    position.x += 3 * sin(angle);
  }
  if (keyControls[1]) {
    position.y -= 3 * cos(angle);
    position.x -= 3 * sin(angle);
  }
  if (keyControls[2]) {
    position.x -= 3 * cos(angle);
    position.y += 3 * sin(angle);
  }
  if (keyControls[3]) {
    position.x += 3 * cos(angle);
    position.y -= 3 * sin(angle);
  }
  if (position.x > planeWidth * scale || position.x < 0){
    position.x = abs(position.x - planeWidth * scale);
  }
  if (position.y > planeWidth * scale || position.y < 0) {
    position.y = abs(position.y - planeWidth * scale);
  }
}

void drawPlanes(){
  noStroke();
  println("Planes");
  int startx = 0;
  int starty = 0;
  int xpos = (int)(position.x/scale + 3 * sin(angle))%planeWidth;
  int ypos = (int)(position.y/scale + 3 * cos(angle))%planeWidth;
  for(int k = 1; k <= 9; k++){
    for (int y = 0; y < planeWidth; y++) {
      for (int x = 0; x < planeWidth; x++) {
        float distance = dist(position.x/scale,position.y/scale,x + planeWidth*(startx - 1),y + planeWidth*(starty - 1));
        fill(plane[x][y], 255, x==xpos && y==ypos?100:160 + abs(x+y)%2 * 40,500/pow(1.001,distance*distance));
        rect(x * scale + (startx - 1) * scale * planeWidth,  y * scale + (starty - 1) * scale * planeWidth, scale, scale);
      }
    }
    startx = (startx+1)%3;
    starty = k/3;
  }
}

void keyPressed() {
  if (keyCode == ENTER) {

    int xpos = (int)(position.x/scale + 3 * sin(angle))%planeWidth;
    int ypos = (int)(position.y/scale + 3 * cos(angle))%planeWidth;

    println("X:"+xpos);
    println("Y:"+ypos);
    plane[xpos][ypos] = (plane[xpos][ypos] + 64)%256;
  } else if (keyCode == SHIFT) {
    angle = 0;
    angle2 = 0;
  } else if (keyCode == UP || key == 'w') {
    keyControls[0] = true;
  } else if (keyCode == DOWN || key == 's') {
    keyControls[1] = true;
  } else if (keyCode == LEFT || key == 'a') {
    keyControls[2] = true;
  } else if (keyCode == RIGHT || key == 'd') {
    keyControls[3] = true;
  }
}

void keyReleased(){
  if (keyCode == UP || key == 'w') {
    keyControls[0] = false;
  } else if (keyCode == DOWN || key == 's') {
    keyControls[1] = false;
  } else if (keyCode == LEFT || key == 'a') {
    keyControls[2] = false;
  } else if (keyCode == RIGHT || key == 'd') {
    keyControls[3] = false;
  }
}

void mouseMoved() {
  angle +=  PI/128 * (mouseX - pmouseX);
  if (angle2 >= -PI/2 || PI/128 * (mouseY - pmouseY) > 0) {
    if (angle2 <= PI/2 || PI/128 * (mouseY - pmouseY) < 0) {
      angle2 += PI/128 * (mouseY - pmouseY);
    }
  }
}
