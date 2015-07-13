String _chromosome, _sequence;
int _cLength;
int _start, _end, _long;  //left first x and it index in _sequence
int _PIXLEN;//each ATCG pixels length
int _show; //show how many seq
int _MINLEN=100; //the least _show number


boolean flag=true, flag1=true;
int px;

boolean notTraceChange=false;

void setup()
{
  size(1100, 800);
  background(255);
  smooth();
  _chromosome="chr22";
  _sequence="GAGCCAAGATTGCACCACTGCACTCCAGCCTGGGCAACAGAGCAAGATTCCATCTAAAAAAAAAAAAAATTAAACAACAACAAAAAAAGTGAGCACATCATTTGTGGCGTCCAGGCACTACATCAGTGAACACAGTTGGTTTTGTGTCTGCCATGGCACTGTTAGTTCCATGGTGCGGGTTAGCAAGGTGCCTGTCCATGCCTAGTCTGAGATGAGTTCTGGCTAAGGTGCCACCAGACACTGTTTGGATGCTGCAATACTGCCTTCTGTTTGCAGGCCTTCTATGTCCCAAAATCTCAGGCCTGGGGAACTAAGCCTCCAACCTCCCGCTGCCCTTACAACTGGCTTTCGGAGAAGCCCCCCAAGAAAATAGAGACAAGGCAAGGTCTGGAGAGTTGGGTCCCATGGTGGGCAGATTCCCAGCACCCTGCTGTGTCTTGGGGAGCACGGGGATTCCCCACTTGAAACACAGAGCCCTGCCCTCCACCCCAGCAGCCGCCAGCCAGGTTGGAAGCCCCTAAATCCTGACCCCACGTGCAGAGTCTCACTACCGGGCACCCGCATGTGTAAAGACGTGAAGGGTGGAGAATCTTTGGAGGGAACACTGCTTCTCAGGGAGACACAATCTGGAATTCAAAGTTTCTAAATTGCATTTTCCTTTTTAAGGAAGTAGCAGATAATATTTGTAGAAAATGTACTGCACTGAGGAAAGTATACAGGAGAACGTGGAATTCATCTGTGTTCTCCAAGCCTGCTGTCACCAATGTAAATATTTTGGTGTGTTTCCTTCCAATCTCTTTTCTTTACGTGCTTTTAAGTTAAATGCGAATCATACTGTAAAAACGCCTGGCGTTCTGCTTCTTCACTGCTGGTGCGTCCTCATCTTCCACACGCTACAGTCTGAATGTGTTTCTCCAAAAGCGTGTGCTGGAGACGGAATCCCCAAAGCAACAGCGTGGGGAGGTGGGGGCTCTAGGAGGTGATGAGGCCTCCGCCCTCAGGAATGGGTCAATGCCATTATGGCAGGAGTGGGTTCCTCACTAAAGGACCA";
  _start=49999950;
  _end=50001000;
  _long=_end-_start; //have how mang seq
  _cLength=theLength;
  _show=1000; //_show=1000, 500, 200, 100
  _i=50;
  _PIXLEN=1000/_show;
}

void draw()
{
  if (theFlag) {myupdate();}
  
  
  if (_i<0 || (_i>_long-_show)) //if _i out of range
  {
      println(_i);
      notTraceChange=true;
      have_offset=false;
      if (_i<0) //left update
      {
          param2 = (int)((int)param2 + (int)_i);
          param3 = (int)((int)param3 + (int)_i);
          theAdd=true;
          update();
      }
      else
      {
          param2 = (int)((int)param2 + (int)_i);
          param3 = (int)((int)param3 + (int)_i);
          theAdd=true;
          update();
      }
    
      
  }


  drawPart1();  

  drawTraceLine();

  showI();

 
}

void myupdate()
{
  println('myupdate~~~~');
  _chromosome=theChromosome;
  _start=theStart;
  _end=theEnd;
  _long=_end-_start;
  if (_long<=1200)
  {
    _sequence=theSequence;
  }
  _cLength=theLength;

  theFlag=false;
  //_show=500; //_show=1000, 500, 200, 100
  _i=0;
  if (have_offset){_i=(int)offset;}

  notTraceChange = false;
  
    

  //_PIXLEN=1000/_show;
}



void showI()
{
  int x=100, y=100;
  fill(255);
  rect(x, y, 50, 15);
  fill(0);
  textSize(10);
  text(" _i= "+_i, x, y+13);         
}

//the move line
void drawTraceLine()
{ 
  if (notTraceChange) return;
  if ((100<mouseX && mouseX<1100) && (mouseY>0) && (mouseY<100))
  {
    if (mousePressed && flag)
    {
      px = mouseX;
      flag=false;
    }
    stroke(0, 100);
    strokeWeight(1);
    line(mouseX, 0, mouseX, 100);
    fill(255);
    if (mouseX<1000)
    {
      rect(mouseX, 10, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(int)(_PIXLEN)+_i+_start), mouseX+5, 22.5);
    }
    else
    {
      rect(mouseX-100, 10, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(int)(_PIXLEN)+_i+_start), mouseX-100+5, 22.5);
    }
  }
}
void keyPressed()
{
  if (notTraceChange) return;
  //define keypresses up down right left
   if (key == CODED) {
    if (keyCode == RIGHT) {
      _i = _i+1;
    } else if (keyCode == LEFT) {
      _i = _i-1;
    } else if(keyCode ==UP){
      int k = _PIXLEN;
      switch(_show)
      {
          case 100:
            _show = 200;
            _PIXLEN=1000/_show;
             break;
           case 200:
            _show = 500;
            _PIXLEN=1000/_show;
             break;
           case 500:
            _show = 1000;
            _PIXLEN=1000/_show;
             break;
           default:
            break;         
      }
      _i = (int)(_i+(mouseX-100)*(1.0/k-1.0/_PIXLEN));
    }
    else if (keyCode==DOWN){
      int k = _PIXLEN;
      switch(_show)
      {
          case 1000:
            _show = 500;
            _PIXLEN=1000/_show;
             break;
           case 500:
            _show = 200;
            _PIXLEN=1000/_show;
             break;
           case 200:
            _show = 100;
            _PIXLEN=1000/_show;
             break;
           default:
            break;         
      }
      _i = (int)(_i+(mouseX-100)*(1.0/k-1.0/_PIXLEN));
    }
   }
}


void mouseReleased()
{
  if(notTraceChange) return;
  _i = (int)(_i+(px-mouseX)/(int)(_PIXLEN));
  flag=true;
}


void mouseWheel(MouseEvent event) 
{
  if (notTraceChange) return;
  float e = (int)event.getCount();
  _i+=e;
}





//_i, _show, _PIXLEN
void drawPart1()
{
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, 0, 1100, height/8); //part_1
  rect(0, 0, 100, height/8);


  if (_show==_MINLEN)//draw each atcg
  {
    int x=100, y=height/8/2-5, k=_PIXLEN, ii=_i;
    for (int i=0; i<_show; i++)
    {
        noStroke();
        switch(_sequence.charAt(ii))
        {
            case str('A'):  
              fill(249,245,56);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('A', x, y+9);
              break;
            case str('T'):  
              fill(133,122,185);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('T', x, y+9);
              break;
             case str('C'):  
              fill(236,95,75);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('C', x, y+9);
              break;
            case str('G'):  
              fill(122,197,131);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('G', x, y+9);
              break;
            default:
              fill(0,0,0);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('N', x, y+9);
              
              break;              
        }
        ii++;
        if (x%100==0)
        {
          stroke(0);
          strokeWeight(0.5);
          line(x, y-10, x, y);
          fill(0);
          textSize(10);
          text(_i+_start+((x-100)/10), x+3, y);
        }
        
        
        x +=k;
    }
  }
  else if (_show<=1000)
  {
    int x=100, y=0, k=10, ii=_i, t=10-k;
    //draw left up info
    noStroke();
    for (int i = 0; i < 4; ++i) {
      switch(i)
        {
            case 0:  
              fill(249,245,56);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('A', x+1, y+9);
              break;
            case 1:  
              fill(133,122,185);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('T', x+1, y+9);
              break;
             case 2:  
              fill(236,95,75);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('C', x, y+9);
              break;
            case 3:  
              fill(122,197,131);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('G', x, y+9);
              break;
            default:
              fill(0, 0, 0);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('N', x, y+9);
              
              break;              
        }
        x+=k;
    }
                    
              
    k=_PIXLEN;
    t=10-k;
    x=100;
    y=height/8/2-5;
    for (int i=0; i<_show; i++)
    {
        noStroke();
        switch(_sequence.charAt(ii))
        {
            case str('A'):  
              fill(249,245,56);
              rect(x, y-t, k, k+2*t);
              break;
            case str('T'):  
              fill(133,122,185);
              rect(x, y-t, k, k+2*t);
              break;
             case str('C'):  
              fill(236,95,75);
              rect(x, y-t, k, k+2*t);
              break;
            case str('G'):  
              fill(122,197,131);
              rect(x, y-t, k, k+2*t);
              break;
            default:
              fill(0,0,0);
              rect(x, y-t, k, k+2*t);
              
              break;              
        }
        ii++;
        stroke(0);
        strokeWeight(0.5);
        if (x%100==0)
        {

          line(x, y-10-t, x, y-t);
          fill(0);
          textSize(10);
          text(_i+_start+((x-100)/k), x+3, y-t);
        }
        if (x%50==0 && x%100!=0)
        {
          line(x, y+k+t, x, y+10+k+t);
          fill(0);
          textSize(10);
          text(_i+_start+((x-100)/k), x+3, y+k+t+10);
        }
        
        
        x +=k;
    }
  }
  //line(width/10, height/8/2, width, height/8/2);
  textSize(15);
  fill(50);
  text(_chromosome, 5, width/10/2);
}

