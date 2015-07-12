void setup(){
  size(500, 500);
  background(255);
  fill(0);
  smooth();
}
int z = (int)(random(500/2));
int k=z/2;
int a = 1;
void draw(){
  background(255);
  ellipse(k, k, z, z);
  if (a == 1)
  {
    k++;
  }
  else
  {
    k--;
  } 
  if (k==z/2) a=1;
  if (k==500-z/2) a=0;
}
