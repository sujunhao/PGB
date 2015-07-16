float _PIXLEN;//each ATCG pixels length
int _show; //show how many seq
int _MINLEN=100; //the least _show number
int _i = 0; //first node index in require sequence

float px;  //pre mouseX
boolean haveNoPx=true, rangechange=false;

int nextY = 0;

void setup()
{
  size(1100, 2000);
  background(#FFEBCD);
  smooth();

  _show =1000;
  _PIXLEN = 1;
}


void draw()
{
  background(255);
    
  wantupdata();


  drawPart1();  
  drawPart2();
  nextY = 200;
  drawPart3();
  drawPart4(); //theRs

  drawTrace();
  
  showI();
}

void wantupdata()    //test _i and update data and _i
{
  if (!haveNoPx) return;
  if (rangechange)                              //if (_i<0 || (_i>theLong-_show)) //if _i out of range
  {
      println(_i);
      notTraceChange=true;
      param2 = (int)((int)param2 + (int)_i);
      param3 = (int)((int)param2 + (int)_i + _show);
      _i=0;
      theAdd=true;
      rangechange = false;
      update();
  }
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
void drawTrace()
{ 
  for (int i=0; i<theTrap.length; i++)
  {
    if ((mouseX>=theTrap[i].r[0] && mouseX<=theTrap[i].r[0]+theTrap[i].r[2])&&(mouseY>=theTrap[i].r[1] && mouseY<=theTrap[i].r[1]+theTrap[i].r[3]))
    {
      var x = theTrap[i].r[0], y = theTrap[i].r[1], w = theTrap[i].r[2], h = theTrap[i].r[3];
      var k=-100;
      if (mouseX<1000) k=100;
        
      rect(mouseX-100+k, y - 15, 100, 15);
      stroke(0, 100);
      strokeWeight(1);
      fill(255);
      textSize(10);
      text(theTrap[i].s, mouseX-100+5, 22.5);
    }
  }
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
      text((int)((mouseX-100)/(_PIXLEN)+_i+theStart), mouseX+5, 22.5);
      text(theV[(int)((mouseX-100)/(_PIXLEN)+_i)], mouseX+5, 122.5);
    }
    else
    {
      rect(mouseX-100, 10, 100, 15);
      rect(mouseX-100, 110, 100, 15);
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(_PIXLEN)+_i+theStart), mouseX-100+5, 22.5);
      text(theV[(int)((mouseX-100)/(_PIXLEN)+_i)], mouseX-100+5, 122.5);
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
      float k = _PIXLEN;
      switch(_show)
      {
          case 100:
            _show = 200;
             break;
           case 200:
            _show = 500;
             break;
           case 500:
            _show = 1000;
             break;
           default:
            if (_show>=1000)
            {
              _show *= 2;
            }
            break;         
      }
      _PIXLEN=1000/_show;
      _i = (int)(_i+(mouseX-100)*(1.0/k-1.0/_PIXLEN));
    }
    else if (keyCode==DOWN){
      float k = _PIXLEN;
      switch(_show)
      {
          case 1000:
            _show = 500;
             break;
           case 500:
            _show = 200;
             break;
           case 200:
            _show = 100;
             break;
           default:
            if (_show>1000 && _show<=2000)
            {
              _show = 1000;
            }
            else if(_show>2000)
            {
              _show /= 2;
            }

            break;         
      }
      _PIXLEN = 1000.0/_show;
      _i = (int)(_i+(mouseX-100)*(1.0/k-1.0/_PIXLEN));
    }
   }

   rangechange = true;
}


void mouseReleased()
{
  if(notTraceChange) return;
  _i = (int)(_i+(px-mouseX)/(_PIXLEN));
  haveNoPx=true;
  rangechange = true;
}


void mouseWheel(MouseEvent event) 
{
  if (notTraceChange) return;
  float e = (int)event.getCount();
  _i+=e;
  rangechange = true;
}
//_i, _show, _PIXLEN
void drawPart1()
{
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, 0, 1100, 100); //part_1
  rect(0, 0, 100, 100);


  if (theLong<=1500 && _show==_MINLEN)//make sure have sequence string and want to show each atcg
  {
    float x=100, y=100/2-5, k=_PIXLEN;
    float ii=_i;
    for (int i=0; i<_show; i++)
    {
        noStroke();
        switch(theSequence[ii])
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
        if ((int)x%100==0)
        {
          stroke(0);
          strokeWeight(0.5);
          line(x, y-10, x, y);
          fill(0);
          textSize(10);
          text(_i+theStart+((x-100)/10), x+3, y);
        }
        
        
        x +=k;
    }
  }
  else if (theLong<=1500 && _show<=1000)
  {
    float x=100, y=0, k=10, t=10-k;
    int ii = _i;
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
    y=100/2-5;
    for (int i=0; i<_show; i++)
    {
        noStroke();
        switch(theSequence[ii])
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
        if ((int)x%100==0)
        {

          line(x, y-10-t, x, y-t);
          fill(0);
          textSize(10);
          text((int)(_i+theStart+((x-100)/k)), x+3, y-t);
        }
        if ((int)x%50==0 && (int)x%100!=0)
        {
          line(x, y+k+t, x, y+10+k+t);
          fill(0);
          textSize(10);
          text((int)(_i+theStart+((x-100)/k)), x+3, y+k+t+10);
        }
        
        
        x +=k;
    }
  }
  else
  {
    line(100, 50, 1100, 50);
    float x=100, y=50, k=10;
    //draw left up info             
    while(x<=1100)
    {
        stroke(0);
        strokeWeight(0.5);
        if ((int)x%100==0)
        {

          line(x, y-10, x, y);
          fill(0);
          textSize(10);
          text(_i+theStart+((x-100)/k), x+3, y);
        }
        if ((int)x%50==0 && (int)x%100!=0)
        {
          line(x, y, x, y+10);
          fill(0);
          textSize(10);
          text(_i+theStart+((x-100)/k), x+3, y+10);
        }
        x += 50;
    }
  }
  //line(width/10, height/8/2, width, height/8/2);
  textSize(15);
  fill(50);
  text(theChromosome, 5, width/10/2);
}

void drawPart2()
{
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, 100, 1100, 100); //part_1
  rect(0, 100, 100, 100);

  line(100, 150, 1100, 150);

  float x=100, y=50+100, k=_PIXLEN, t;
  for (int i=0; i<_show; i++)
  {
      float t = map(abs(theV[_i+i]), 0, maxV, 0, 50);
      noStroke();
      fill(#00BFFF);
      if (theV[_i+i]>=0)
      {
        rect(x, y-t, k, t); 
      }
      else
      {
        rect(x, 150, k, t);
      }
      x += k;
  }
  

  
  //line(width/10, height/8/2, width, height/8/2);
  textSize(10);
  fill(100);
  text(theValueId, 0, 150, 90, 60);
}

void drawPart3()
{
  float k, wy=200, ly = nextY;
  if (theEs.length<=6) wy  = 100;

  k = wy/(theEs.length); //the gene can fill height
  float o = max((k-10)/2, k/5);
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, ly, 1100, wy); //part_1
  rect(0, ly, 100, wy);

  noStroke();
  for (var i=0; i<theEs.length; i++)
  {

    textSize(k-2*o);
    fill(100);
    text(theEs[i].id, 0, ly+(i+1)*k-o);
    if (theEs[i].t <= theStart+_i) continue;
    if (theEs[i].f >= theStart+_i+_show) continue;
    
    String mark = "<";
    if (theEs[i].s == 1) mark = ">";

    for (var j=0; j<theEs[i].S.length; j++)
    {
      var f = theEs[i].S[j].f, t = theEs[i].S[j].t;
      if (f<theStart+_i) f = theStart+_i;
      if (t>theStart+_i+_show) t=theStart+_i+_show;

      switch(theEs[i].S[j].y) //XLD 012
      {
          case 0:
              fill(#ADFF2F);
              rect(100+abs(f-theStart-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              if (abs(t-f)*_PIXLEN>k-2*o)
              drawDir(mark, 100+abs(f-theStart-_i)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(i+1)*k-o, k, o);
              break;
          case 1:
              fill(#778899);
              rect(100+abs(f-theStart-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              break;
          case 2:
              fill(#FFA500);
              rect(100+abs(f-theStart-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
              if (abs(t-f)*_PIXLEN>k-2*o)
              drawDir(mark, 100+abs(f-theStart-_i)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(i+1)*k-o, k, o);
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
  nextY += wy;
}

void drawDir(String s, float x1, float x2, float y, int k, int o)
{
  fill(0);
  textSize(k-2*o);
  text(s, x1, y);
  text(s, x2-(k-2*o), y);
}


void drawPart4()
{


  while(theTrap.length != 0) theTrap.pop();

  color [] col = {color(78,238,148), color(112,202,238)};

  float k, wy=theRs.length*15, ly = nextY;

  k = wy/(theRs.length); //the gene can fill height
  float o = max((k-10)/2, k/5);

  stroke(0);        //set the content box
  strokeWeight(0.5);
  fill(#FFEBCD); 
  rect(0, ly, 1100, wy); 
  rect(0, ly, 100, wy);

  noStroke();
  for (int i=0; i<theRs.length; i++)
  {

    textSize(k-2*o);
    fill(100);
    text(theRs[i].id, 0, ly+(i+1)*k-o);
    for (int j=0; j<theRs[i].f.length; j++)
    {
        int f = theRs[i].f[j], t = theRs[i].t[j];
        if (t <= theStart+_i) continue;
        if (f >= theStart+_i+_show) continue;
        
        if (f<theStart+_i) f = theStart+_i;
        if (t>theStart+_i+_show) t=theStart+_i+_show;

        String mark = "<";
        if (theRs[i].s == 1) mark = ">";

        fill(col[j%2]);
        rect(100+abs(f-theStart-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
        
        var rr = new Array(100+abs(f-theStart-_i)*_PIXLEN, ly+k*i+o, abs(t-f+1)*_PIXLEN, k-2*o);
        var p = new Trap();
        p.r = rr;
        p.s = theRs[i].id;
        theTrap.push(p);

        if (abs(t-f)*_PIXLEN>k-2*o)
        drawDir(mark, 100+abs(f-theStart-_i)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(i+1)*k-o, k, o);

    }
    
  }
  nextY += wy;
}