String _chromosome, _sequence;
int _cLength;
int _start, _end, _long, _XX, _i;  //left first x and it index in _sequence
int _PIXLEN;//each ATCG pixels length
int _show; //show how many seq
int _MINLEN=100; //the least _show number


boolean flag=true, flag1=true;
int px;

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
  _show=500; //_show=1000, 500, 200, 100
  _i=50;
  _XX=_start+_i;
  _PIXLEN=1000/_show;
}

void draw()
{
  if (theFlag) {myupdate();}
  
  //println(_i);

  if (_i<0 || (_i>_long-_show)) //if _i out of range
  {
    println(_i);
    if (_i<0)
    {
      //println(111);
      if (_start>50)
      {
        param2 = param2-51;
        param3 = param3-51;
        theAdd=true;
        theFlag=true;
        update();
        return;
      }
      else if (_start>=0) {
        param2=0;
        param3=param3-_start;
        _i=_start;
        theAdd=true;
        theFlag=true;
        is_want_i_change=false;
        update();
        return;
      }
      else{
        return;
      }

    }
    else
    {
      if (_cLength-_end>50)
      {
        param2 = (int)(param2)+50;
        param3 = (int)param3+(int)50;
        theAdd=true;
        update();
        the_iChange=false;
        theFlag=true;
        return;
      }
      else if (_end<=_cLength) {//if seq upper no enough -> have bug
        param2=(int)param2+int((int)_cLength-param3);
        _i=_start+(int)_cLength-param3;
        param3=_cLength;
        theAdd=true;
        theFlag=true;
        is_want_i_change=false;
        update();
        return;
      }
      else{
        return;
      }
    }
  }


  drawPart1();  

  drawTraceLine();

  showI();

 
}

void myupdate()
{
  _chromosome=theChromosome;
  _sequence=theSequence;
  _start=theStart;
  _end=theEnd;
  _cLength=theLength;
  _long=_end-_start;
  theFlag=false;
  //_show=500; //_show=1000, 500, 200, 100
  if (is_want_i_change){
    if (the_iChange){_i=50; the_iChange=false;}
    else {_i=0;}
    is_want_i_change=true;
  }

  _XX=_start+_i;
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
      text((int)((mouseX-100)/(int)(_PIXLEN)+_XX), mouseX+5, 22.5);
    }
    else
    {
      rect(mouseX-100, 10, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(int)(_PIXLEN)+_XX), mouseX-100+5, 22.5);
    }
  }
}
void keyPressed()
{
  //define keypresses up down right left
   if (key == CODED) {
    if (keyCode == RIGHT) {
      _i = _i+1;
      _XX = _start+_i;
    } else if (keyCode == LEFT) {
      _i = _i-1;
      _XX = _start+_i;
    } else if(keyCode ==UP){
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
    }
    else if (keyCode==DOWN){
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
    }
   }
}
void mouseReleased()
{
   _i = (int)(_i+(px-mouseX)/(int)(_PIXLEN));
   _XX=_i+_start;
  flag=true;
}

void mouseWheel(MouseEvent event) 
{
  float e = (int)event.getCount();
  _i+=e;
  _XX = _i+_start;
}


void drawPart1()
{
  stroke(0);
  strokeWeight(0.5);
  fill(#00FF00); //color of part_1
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
          text(_XX+((x-100)/10), x+3, y);
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
              text('A', x, y+9);
              break;
            case 1:  
              fill(133,122,185);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('T', x, y+9);
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
          text(_XX+((x-100)/k), x+3, y-t);
        }
        if (x%50==0 && x%100!=0)
        {
          line(x, y+k+t, x, y+10+k+t);
          fill(0);
          textSize(10);
          text(_XX+((x-100)/k), x+3, y+k+t+10);
        }
        
        
        x +=k;
    }
  }
  //line(width/10, height/8/2, width, height/8/2);
  textSize(15);
  fill(50);
  text(_chromosome, 5, width/10/2);
}

