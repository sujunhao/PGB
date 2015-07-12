void setup(){
  size(500, 500);
  background(255);
  smooth();
}

void draw(){
  
}

void mousePressed(){
   fill((int)(random(255)), (int)(random(255)), (int)(random(255)));
   int k = (int)(random(width/2));
   ellipse(mouseX, mouseY, k, k);
}
