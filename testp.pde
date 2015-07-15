String _chromosome, _sequence;
int _cLength;
int _start, _end, _long;  //left first x and it index in _sequence
int _PIXLEN;//each ATCG pixels length
int _show; //show how many seq
int _MINLEN=100; //the least _show number

int _i = 10;

boolean haveNoPx=true, flag1=true;
int px;

boolean notTraceChange=false;

int they = 0;

void setup()
{
  size(1100, 800);
  background(#FFEBCD);
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
  background(255);
  if (theFlag) {myupdate();}
  
  
  if (haveNoPx)
  if (_i<0 || (_i>_long-_show)) //if _i out of range
  {
      println(_i);
      notTraceChange=true;
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
  drawPart2();
  they = 200;
  drawPart3();

  drawTraceLine();

  showI();

  textSize(10);
  text("zk", 0, 800);
  rect(30, 790, 20, 10);

 
}

void myupdate()
{
  println('myupdate~~~~');
  _chromosome=theChromosome;
  _start=theStart;
  _end=theEnd;
  _long=_end-_start;
  if (_long<=1500)
  {
    _sequence=theSequence;
  }
  _cLength=theLength;

  theFlag=false;
  //_show=500; //_show=1000, 500, 200, 100
  _i=0;
  notTraceChange = false;
  
    

  //_PIXLEN=1000/_show;
}



void showI()
{
  int x=100, y=100-16;
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
  if ((100<mouseX && mouseX<1100) && (mouseY>0) && (mouseY<200))
  {
    if (mousePressed && haveNoPx) //if mouse press and can trace mouserelease  mark the mouseX and turn off trace
    {
      px = mouseX;
      haveNoPx=false;
    }
    stroke(0, 100);
    strokeWeight(1);
    line(mouseX, 0, mouseX, 200);
    fill(255);
    if (mouseX<1000)
    {
      rect(mouseX, 10, 100, 15);
      rect(mouseX, 110, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(int)(_PIXLEN)+_i+_start), mouseX+5, 22.5);
      text(theV[(int)((mouseX-100)/(int)(_PIXLEN)+_i)], mouseX+5, 122.5);
    }
    else
    {
      rect(mouseX-100, 10, 100, 15);
      rect(mouseX-100, 110, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(int)(_PIXLEN)+_i+_start), mouseX-100+5, 22.5);
      text(theV[(int)((mouseX-100)/(int)(_PIXLEN)+_i)], mouseX-100+5, 122.5);
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
  haveNoPx=true;
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


  if (_long<=1500 && _show==_MINLEN)//draw each atcg
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
  else if (_long<=1500 && _show<=1000)
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
  else
  {
    line(100, 50, 1100, 50);
    int x=100, y=50, k=10;
    //draw left up info             
    while(x<=1100)
    {
        stroke(0);
        strokeWeight(0.5);
        if (x%100==0)
        {

          line(x, y-10, x, y);
          fill(0);
          textSize(10);
          text(_i+_start+((x-100)/k), x+3, y);
        }
        if (x%50==0 && x%100!=0)
        {
          line(x, y, x, y+10);
          fill(0);
          textSize(10);
          text(_i+_start+((x-100)/k), x+3, y+10);
        }
        x += 50;
    }
  }
  //line(width/10, height/8/2, width, height/8/2);
  textSize(15);
  fill(50);
  text(_chromosome, 5, width/10/2);
}

void drawPart2()
{
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, 100, 1100, 100); //part_1
  rect(0, 100, 100, 100);

  line(100, 150, 1100, 150);

  int x=100, y=50+100, k=_PIXLEN,  tk = 50, ii=_i, t;
  for (int i=0; i<_show; i++)
  {
      float t = map(abs(theV[ii]), 0, maxV, 0, 50);
      noStroke();
      fill(#00BFFF);
      if (theV[ii]>=0)
      {
        rect(x, y-t, k, t); 
      }
      else
      {
        rect(x, 150, k, t);
      }
           
      ii+=1;  
      x +=k;
  }
  

  
  //line(width/10, height/8/2, width, height/8/2);
  textSize(10);
  fill(100);
  text(theValueId, 0, 150, 90, 60);
}

void drawPart3()
{
  int k, wy=200, ly = they;
  if (theEs.length<=6) wy  = 100;

  k = wy/(theEs.length); //the gene can fill height
  float o = max((k-10)/2, k/5);
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, ly, 1100, wy); //part_1
  rect(0, ly, 100, wy);

  for (var i=0; i<theEs.length; i++)
  {

    textSize(k-2*o);
    fill(100);
    text(theEs[i].id, 0, ly+(i+1)*k-o);
    if (theEs[i].t <= _start+_i) continue;
    if (theEs[i].f >= _start+_i+_show) continue;
    
    String mark = "<";
    if (theEs[i].s == 1) mark = "<";

    for (var j=0; j<theEs[i].S.length; j++)
    {
      var f = theEs[i].S[j].f, t = theEs[i].S[j].t;
      if (f<_start+_i) f = _start+_i;
      if (t>_start+_i+_show) t=_start+_i+_show;

      switch(theEs[i].S[j].y) //XLD 012
      {
          case 0:
              fill(#ADFF2F);
              rect(100+abs(f-_start-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              if (abs(t-f)*_PIXLEN>k-2*o)
              drawDir(mark, 100+abs(f-_start-_i)*_PIXLEN, 100+abs(t-_start-_i)*_PIXLEN, ly+(i+1)*k-o, k, o);
              break;
          case 1:
              fill(#778899);
              rect(100+abs(f-_start-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              break;
          case 2:
              fill(#FFA500);
              rect(100+abs(f-_start-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              if (abs(t-f)*_PIXLEN>k-2*o)
              drawDir(mark, 100+abs(f-_start-_i)*_PIXLEN, 100+abs(t-_start-_i)*_PIXLEN, ly+(i+1)*k-o, k, o);
              break;
          default:
              break;
      }
    }

    
  }

  

  
  

  
  //line(width/10, height/8/2, width, height/8/2);
  // textSize(10);
  // fill(100);
  // text(theValueId, 0, 150, 90, 60);
  they += wy;
}

void drawDir(String s, float x1, float x2, float y, int k, int o)
{
  fill(0);
  textSize(k-2*o);
  text(s, x1, y);
  text(s, x2-(k-2*o), y);
}