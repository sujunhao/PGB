int _MINLEN=100; //the least _show number

float px;  //pre mouseX
boolean haveNoPx=true, rangechange=false;

int nextY = 0;

color [] col = {color(78,238,148), color(112,202,238), color(158,202,225), color(107,174,214), color(49,130,189), color(252,187,161), color(251,106,74), color(165,15,21)};

PFont f;

class Ball
{
  float x, y, r;
  float speedX, speedY;
  color c;
  boolean flag = true;
  Ball()
  {
      x = random(50, width-50);
      y = random(50, 300-50);
      r =  constrain(random(19.5, 40.5), 20, 40)/2;
      c =  color(random(255), random(255), random(255));
      speedX = constrain(random(-0.1, 10+0.1)-5, -5, 5);
      speedY = constrain(random(-0.1, 10+0.1)-5, -5, 5);
  }
  Ball(float tx, float ty, float tr, color tc)
  {
    x = tx; 
    y = ty;
    r = tr/2;
    c = tc;
    speedX = constrain(random(-0.1, 10+0.1)-5, -5, 5);
    speedY = constrain(random(-0.1, 10+0.1)-5, -5, 5);
  }
  
  void show()
  {
    noStroke();
    fill(c);
    ellipse(x, y, r*2, r*2);
  }
  
  void run()
  {
    show();
    if (!flag) return;
    if ((speedX >= 0 && x+r > width) || (speedX < 0 && x-r < 0))
    {
        speedX = -speedX;
        c =  color(random(255), random(255), random(255));
    }
    if ((speedY >=0 && y+r > 400) || (speedY <0 && y-r < 0))
    {
        speedY = -speedY;
        c =  color(random(255), random(255), random(255));
    }
    x += speedX;
    y += speedY;
   }
   
   void checkC(Ball b)
   {
     if (dist(x, y, b.x, b.y) < (r+b.r))
       flag = false;
   }
  
}


Ball[] bb;
int ballnum=2;


void setup()
{
  size(1100, 1200);
  background(#FFEBCD);
  f = loadFont("Monospaced.plain-20.vlw");
  textFont(f, 10);
  smooth();
  frameRate(100);
  _show =1000;
  _PIXLEN = 1;
  notTraceChange = true;
  bb = new Ball[10];
  for (int i=0; i<ballnum; i++)
  { 
    bb[i] = new Ball();
  }
}


void draw()
{
  if (notTraceChange)//draw the loading wait animation
  {

    background(255);
    for (int i=0; i<ballnum; i++)
    {
      bb[i].run();
    }
    textSize(50);
    text("data are loading", 350, 200);
    return;
  }
  if (keyPressed)
  {
    keyP();
  }
  wantupdata()
  //if (wantupdata()) return;
  

  _PIXLEN = 1000.0/_show;
  drawPart1();  
  nextY=100;      //value part draw form y=100
  for (int i=0; i<theValueL.length; i++)
  {
    drawPart2(i);
  }

  while(theTrap.length != 0) theTrap.pop();  //delete theTrap array in order to update

  for (int i=0; i<theEsL.length; i++) //draw Es
  {
    drawPart3(i);
  }
  
  for (int i=0; i<theRsL.length; i++)
  {
    drawPart4(i); //theRs
  }

  drawPart5(); //draw theVs tag

  drawTrace();
  
  fill(#ffffe5);
  rect(0, nextY, width, height-nextY);
  //showInfo();
}

//test _i and update data and _i
boolean wantupdata()    
{
  if (!haveNoPx) return false;
  if (rangechange || theStart+_i+_show-1>theEnd)                              //if (_i<0 || (_i>theLong-_show)) //if _i out of range
  {
      //println(_i);
      if (_i>=0 && theStart+_i+_show-1<=theEnd && (theLong<=1500)) return false;
      notTraceChange=true;
      param2 = (int)((int)param2 + (int)_i);
      param3 = (int)((int)param2 + (int)_i + _show - 1);

      if (param2<1 && param3>theLength) //if query out of the chromosome length set border to 1 to theLength
      {
        _show=theLength;
        param2=1;
        param3=theLength;
      }
      else if (param3>theLength)
      {
        _show = theLength-(theStart+_i)+1;
        param3=theLength;
      }
      else if (param2<1)
      {
        _show=theStart+_i+_show;
        param2=1;
      }
      _i=0;
      theAdd=true;
      rangechange = false;
      update();
      return true;
  }
  return false;
}

void showInfo()
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

  if (notTraceChange) return;

  for (int i=0; i<theTrap.length; i++) //loof the Trap list in order to check whether mouse on it 
  {
    if ((mouseX>=theTrap[i].r[0] && mouseX<=theTrap[i].r[0]+theTrap[i].r[2])&&(mouseY>=theTrap[i].r[1] && mouseY<=theTrap[i].r[1]+theTrap[i].r[3]))
    {
      var x = theTrap[i].r[0], y = theTrap[i].r[1], w = theTrap[i].r[2], h = theTrap[i].r[3];
      stroke(0);
      strokeWeight(2);
      noFill();
      rect(x, y, w, h);
      
      var k1=theTrap[i].s.length*7;
      if (k1<100) k1=100;
      var k2=-k1;
      if (mouseX>1100-k1) k1=0;
        
      fill(255);
      stroke(1, 100);
      strokeWeight(1);
      rect(mouseX+k1+k2, y - 15, -k2, 15);
      fill(0);
      textSize(10);
      text(theTrap[i].s, mouseX+k2+k1+5, y-3);
    }
  }

  
  int len = theValueL.length;
  if ((100<mouseX && mouseX<1100) && (mouseY>0) && (mouseY<100+100*len))
  {
    if (mousePressed && haveNoPx) //if mouse press and can trace mouserelease  mark the mouseX and turn off trace
    {
      px = mouseX;
      haveNoPx=false;
    }
    //draw trace Vs
    drawVsTrace();

    stroke(0, 100);
    strokeWeight(0.5);
    line(mouseX, 0, mouseX, nextY);
    fill(255);
    if (mouseX<=1000)
    {
      rect(mouseX, 10, 100, 15);
      for (int i=0; i<len; i++)
      {
        rect(mouseX, 100*(i+1)+10, 100, 15);
      }
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(_PIXLEN)+_i+theStart), mouseX+5, 22.5);
      int pp=(int)((mouseX-100)/((width-100)/1500)+_i);
      if (_show<=1500)
        pp=(int)((mouseX-100)/(_PIXLEN)+_i);
      for (int i=0; i<len; i++)
      {
         text(theValueL[i].s[pp], mouseX+5, 100*(i+1)+22.5);
      }
    }
    else
    {
      rect(mouseX-100, 10, 100, 15);
      for (int i=0; i<len; i++)
      {
        rect(mouseX-100, 100*(i+1)+10, 100, 15);
      }
      fill(0);
      textSize(10);
      text((int)((mouseX-100)/(_PIXLEN)+_i+theStart), mouseX-100+5, 22.5);
      int pp=(int)((mouseX-100)/((width-100)/1500)+_i);
      if (_show<=1500)
        pp=(int)((mouseX-100)/(_PIXLEN)+_i);

      for (int i=0; i<len; i++)
      {
         text(theValueL[i].s[pp], mouseX-100+5, 100*(i+1)+22.5);
      }
    }
  }
}


//draw the variant info
void drawVsTrace()  
{
  //if (theVsL.length==0) return;
  //set iscolor hh, ww, len , rr, ll
  int f, t, rr, hh=10, len, yy;
  float ww, ll;

  if (_show<=1000)
  iscolor = true;
  
  ww = _PIXLEN;
  ll = theStart+_i;
  rr = theStart+_i+_show;

  
  yy = 100 - hh -1;
  
  for (int z = 0; z < theVsL.length; z++)
  {
    for (int i = 0; i < theVsL[z].theVs.length; ++i) {
        f = theVsL[z].theVs[i].f;
        t = theVsL[z].theVs[i].t;
        if (f>=ll)
        {
          if (t>rr) t = rr;
          for (int j=f; j<=t; j++)
          {
            xx = _PIXLEN*(f-ll)+100;
            if ((mouseX>=xx && mouseX<=xx+ww) && (mouseY>=yy) && (mouseY<=yy+hh))
            {
              String s = "f :" + f + " | t: "+ t+ " | trackId: "+theVsL[z].id + " | Id: " + theVsL[z].theVs[i].id + " | Y: " +
              theVsL[z].theVs[i].y + " | B: " + 
              theVsL[z].theVs[i].b;

              var x = f, y = yy, w = 100, h = hh;
              stroke(0);
              strokeWeight(2);
              noFill();
              rect(x, y, w, h);
              
              var k1=s.length*7;
              if (k1<100) k1=100;
              var k2=-k1;
              if (mouseX>1100-k1) k1=0;
                
              fill(255);
              stroke(1, 100);
              strokeWeight(1);
              rect(mouseX+k1+k2, y - 15, -k2, 15);
              fill(0);
              textSize(10);
              text(s, mouseX+k2+k1+5, y-3);
              //console.log(s);
            }
          }
        }   
      }

  }
      
}


//if key press change _i and _show
void keyP()
{
  if (notTraceChange) return;
  //define keypresses up down right left
   if (key == CODED) {
    if (keyCode == RIGHT) {
      if(theStart+_i+_show<theLength)
        _i = _i+1;
    } else if (keyCode == LEFT) {
      if (theStart>0)
        _i = _i-1;
    } else if(keyCode ==UP){
      float k = _PIXLEN;
     _show *= 2;
      _PIXLEN=1000/_show;
      _i = (int)(_i+(mouseX-100)*(1.0/k-1.0/_PIXLEN));
    }
    else if (keyCode==DOWN){
      float k = _PIXLEN;
      if (_show<=200)
      {
        _show=100;
      }
      else{
      _show /= 2;       
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


//use _i, _show, _PIXLEN
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
              text('A', x+2, y+9);
              break;
            case str('T'):  
              fill(133,122,185);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('T', x+2, y+9);
              break;
             case str('C'):  
              fill(236,95,75);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('C', x+2, y+9);
              break;
            case str('G'):  
              fill(122,197,131);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('G', x+2, y+9);
              break;
            default:
              fill(0,0,0);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('N', x+2, y+9);
              
              break;              
        }
        ii++;
        if ((int)x%100==0)
        {
          stroke(0);
          strokeWeight(0.5);
          line(x, y-10, x, y);
          fill(0);
          textSize(6);
          text(_i+theStart+((x-100)/10), x+3, y);
        }
        
        
        x +=k;
    }
  }
  else if (theLong<=1500 && _show<=1500)
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
              text('A', x+2, y+9);
              break;
            case 1:  
              fill(133,122,185);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('T', x+2, y+9);
              break;
             case 2:  
              fill(236,95,75);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('C',x+2, y+9);
              break;
            case 3:  
              fill(122,197,131);
              rect(x, y, k, k);
              fill(0);
              textSize(k);
              text('G',x+2, y+9);
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
          textSize(6);
          text((int)(_i+theStart+((x-100)/k)), x+3, y-t);
        }
        if ((int)x%50==0 && (int)x%100!=0)
        {
          line(x, y+k+t, x, y+10+k+t);
          fill(0);
          textSize(6);
          text(str(_i+theStart+((x-100)/k)), x+3, y+k+t+10);
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
          textSize(0.5);
          textLeading(0.5);
          text((int)(_i+theStart+((x-100)/_PIXLEN)), x+3, y);
        }
        if ((int)x%50==0 && (int)x%100!=0)
        {
          line(x, y, x, y+10);
          fill(0);
          textSize(6);
          text((int)(_i+theStart+((x-100)/_PIXLEN)), x+3, y+10);
        }
        x += 50;
    }
  }
  //line(width/10, height/8/2, width, height/8/2);
  textSize(15);
  fill(50);
  text(theChromosome, 5, width/10/2);

  if (_show>1500)
  {
    text(theStart, 105, 15);
    text(theEnd, 1020, 15);
  }
}

void drawPart2(int j)
{
  stroke(0);
  strokeWeight(0.5);
  fill(#FFEBCD); //color of part_1
  rect(0, nextY, 1100, 100); //part_1
  rect(0, nextY, 100, 100);

  line(100, nextY+50, 1100, nextY+50);

  float x=100, y=50+nextY, k=_PIXLEN, t, __show=_show, _k=k;
  int __i=_i;
  if (_show>1500)
  {
    __show = 1500;
    _k=1000.0/1500;
    __i=0;
  }
  for (int i=0; i<__show; i++)
  {
      float vv = theValueL[j].s[_i+i];
      float t = map(abs(vv), 0, maxV[j], 0, 50);
      noStroke();
      if (t<50/3)
      fill(col[(j%2)*3+2]);
      else if(t<50/3*2)
      fill(col[(j%2)*3+3]);
      else
      fill(col[(j%2)*3+4]);
      if (vv>=0)
      {
        rect(x, y-t, _k, t); 
      }
      else
      {
        rect(x, 150, _k, t);
      }
      x += _k;
  }
  

  
  //line(width/10, height/8/2, width, height/8/2);
  noStroke();
  textSize(10);
  textAlign(RIGHT)
  fill(100);
  text(theValueL[j].id, 5, nextY+100/2, 80, 40);

  nextY+=100;
}


void drawDir(String s, float x1, float x2, float y, int k, int o)
{
  fill(0);
  textSize(k-2*o);
  text(s, x1, y);
  text(s, x2-(k-2*o), y);
}


void drawPart3(int z)
{
  //while(level.length!=0) level.pop(); //tmp just to keep level info to define how to draw
  level = [];
  int l = theTrap.length;  
  for (int i=0; i<theEsL[z].theEs.length; i++)   //how many Es tags
  {

    int f = theEsL[z].theEs[i].f, t = theEsL[z].theEs[i].t;
    if (t <= theStart+_i) continue;
    if (f >= theStart+_i+_show) continue;
      
    if (f<theStart+_i) f = theStart+_i;
    if (t>=theStart+_i+_show) t=theStart+_i+_show-1;
      
    float tf = 100+abs(f-theStart-_i+1)*_PIXLEN, tw = abs(t-f+1)*_PIXLEN;

    var w = new LevelNode();
    w.c=theEsL[z].theEs[i].s;

    int getl=0;
    for (int m=0; m<level.length; m++)
    {
      int pp=1;
      for (int n=0; n<level[m].length; n++)
      {
        int p = level[m][n].n+l;
        int ff = theTrap[p].r[0], ww = theTrap[p].r[2];
        if ((tf<=ff)&&(ff<=tf+tw) || (tf<=ff+ww)&&(ff+ww<=tf+tw) || ((ff<=tf)&&(tf<=ff+ww)) || ((ff<=tf+tw)&&(tf+tw<=ff+ww)))
        {
          pp = 0;
          break;
        }
      }
      if (pp==1)
      {
        w.n = i;
        level[m].push(w);
        getl=1;
        break;
      }
    }

    if (getl==0)
    {
      k = CreateArray();
      w.n = i;
      k.push(w);
      level.push(k);
    }
      
    var rr = new Array(tf, 0, tw, 0);
    var p = new Trap();
    p.r = rr;
    p.s = theEsL[z].theEs[i].id;
    theTrap.push(p);   
  }

  float wy=(level.length)*15, ly = nextY, k=15;
  if (wy<100) wy=100;
  if (level.length>=300/15)
  {
    k = 300/level.length;
    wy = 300;
  }
  float o = max((k-10)/2, k/5);
  stroke(0);        //set the content box
  strokeWeight(0.5);
  fill(#FFEBCD); 
  rect(0, ly, 1100, wy); 
  rect(0, ly, 100, wy);

  //show ID
  noStroke();
  textSize(10);
  textAlign(RIGHT)
  fill(100);
  text(theEsL[z].id, 5, ly+wy/2, 80, 40);

  fill(#ADFF2F);
  rect(0+5, ly, 10, 10);
  fill(#778899);
  rect(10+5, ly, 10, 10);
  fill(#FFA500);
  rect(20+5, ly, 10, 10);
  fill(0);
  textSize(5);
  //textAlign(CENTER);
  text("X", 5, ly+5, 10, 10); 
  text("L", 15, ly+5, 10, 10);  
  text("D", 25, ly+5, 10, 10);   
  
  for(int m=0; m<level.length; m++)
  {
    for (int n=0; n<level[m].length; n++)
    {
      int i=level[m][n].n;

      ii = m;

      String mark = "<";
      if (level[m][n].c==1){
        mark = ">";
      }

      theTrap[i+l].r[1]=ly+k*ii+o;
      theTrap[i+l].r[3]= k-2*o;

      stroke(25);
      strokeWeight(0.5);
      
      
      for (var j=0; j<theEsL[z].theEs[i].S.length; j++)
      {
        int f = theEsL[z].theEs[i].S[j].f;
        int t = theEsL[z].theEs[i].S[j].t;
        if (t <= theStart+_i) continue;
        if (f >= theStart+_i+_show) continue;

        if (f<theStart+_i) f = theStart+_i;
        if (t>=theStart+_i+_show) t=theStart+_i+_show-1;
        switch(theEsL[z].theEs[i].S[j].y) //XLD 012
        {
            case 0:
                fill(#ADFF2F);
                rect(100+abs(f-theStart-_i+1)*_PIXLEN, ly+k*ii+o, abs(t-f+1)*_PIXLEN, k-2*o);
                if (abs(t-f)*_PIXLEN>k-2*o)
                drawDir(mark, 100+abs(f-theStart-_i+1)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(ii+1)*k-o, k, o);
                break;
            case 1:
                fill(#778899);
                rect(100+abs(f-theStart-_i+1)*_PIXLEN, ly+k*ii+o, abs(t-f+1)*_PIXLEN, k-2*o);
                break;
            case 2:
                fill(#FFA500);
                rect(100+abs(f-theStart-_i+1)*_PIXLEN, ly+k*ii+o, abs(t-f+1)*_PIXLEN, k-2*o);
                if (abs(t-f)*_PIXLEN>k-2*o)
                drawDir(mark, 100+abs(f-theStart-_i+1)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(ii+1)*k-o, k, o);
                break;
            default:
                fill(255, 255);
                break;

        }
      }


      if (theEsL[z].theEs[i].S.length==0) //when no return type inside a gene show as a X sequence 
      {
        int f = theEsL[z].theEs[i].f;
        int t = theEsL[z].theEs[i].t;
        if (t <= theStart+_i) continue;
        if (f >= theStart+_i+_show) continue;

        if (f<theStart+_i) f = theStart+_i;
        if (t>=theStart+_i+_show) t=theStart+_i+_show-1;
        fill(#ADFF2F);
        rect(100+abs(f-theStart-_i+1)*_PIXLEN, ly+k*ii+o, abs(t-f+1)*_PIXLEN, k-2*o);
        if (abs(t-f)*_PIXLEN>k-2*o)
        drawDir(mark, 100+abs(f-theStart-_i+1)*_PIXLEN, 100+abs(t-theStart-_i)*_PIXLEN, ly+(ii+1)*k-o, k, o);
      }
    }
  }
  nextY += wy;
}
  

void drawPart4(int z)
{
  //while(level.length!=0) level.pop();
  level = [];
  int l = theTrap.length;
  for (int i=0; i<theRsL[z].theRs.length; i++)   //how many Rs tags
  {
    for (int j=0; j<theRsL[z].theRs[i].f.length; j++)
    {
        int f = theRsL[z].theRs[i].f[j], t = theRsL[z].theRs[i].t[j];
        if (t <= theStart+_i) continue;
        if (f >= theStart+_i+_show) continue;
        
        if (f<theStart+_i) f = theStart+_i;
        if (t>=theStart+_i+_show) t=theStart+_i+_show-1;
        
        float tf = 100+abs(f-theStart-_i+1)*_PIXLEN, tw = abs(t-f+1)*_PIXLEN;

        var w = new LevelNode();
        w.c=theRsL[z].theRs[i].s;

        int getl=0;
        for (int m=0; m<level.length; m++)
        {
          int pp=1;
          for (int n=0; n<level[m].length; n++)
          {
            int p = level[m][n].n+l;
            int ff = theTrap[p].r[0], ww = theTrap[p].r[2];
            if ((tf<=ff)&&(ff<=tf+tw) || (tf<=ff+ww)&&(ff+ww<=tf+tw) || ((ff<=tf)&&(tf<=ff+ww)) || ((ff<=tf+tw)&&(tf+tw<=ff+ww)))
            {
              pp = 0;
              break;
            }
          }
          if (pp==1)
          {
            w.n = theTrap.length-l;
            level[m].push(w);
            getl=1;
            break;
          }
        }

        if (getl==0)
        {
          k = CreateArray();
          w.n = theTrap.length-l;
          k.push(w);
          level.push(k);
        }
        
        var rr = new Array(tf, 0, tw, 0);
        var p = new Trap();
        p.r = rr;
        p.s = theRsL[z].theRs[i].id;
        theTrap.push(p);
    }
    
  }

  float wy=(level.length)*15, ly = nextY, k=15;
  if (wy<100) wy=100;
  if (level.length>(height-ly)/15)
  {
    k = (height-ly)/level.length;
    wy = height-ly;
  }
  float o = max((k-10)/2, k/5);
  stroke(0);        //set the content box
  strokeWeight(0.5);
  fill(#FFEBCD); 
  rect(0, ly, 1100, wy); 
  rect(0, ly, 100, wy);

  //show ID
  noStroke();
  textSize(10);
  textAlign(RIGHT)
  fill(100);
  text(theRsL[z].id, 5, ly+wy/2, 80, 40);

  noStroke();
  strokeWeight(0);
  for(int m=0; m<level.length; m++)
  {
    for (int n=0; n<level[m].length; n++)
    {
      int i=level[m][n].n+l;
      float tf = theTrap[i].r[0], tw = theTrap[i].r[2];
      ii = m;

      String mark = "<";
      fill(col[0]);
      if (level[m][n].c==1){
        mark = ">";
        fill(col[1]);
      }

      stroke(25);
      strokeWeight(0.5);
      rect(tf, ly+k*ii+o, tw, k-2*o);
      theTrap[i].r[1]=ly+k*ii+o;
      theTrap[i].r[3]= k-2*o;
      if (abs(tw)-2*o<=0 || k<=10) continue;
      drawDir(mark, tf, tf+tw, ly+(ii+1)*k-o, k, o);

    }
  }
  nextY += wy;
}



void drawPart5()
{
  if (theVsL.length==0) return;
  //set iscolor hh, ww, len , rr, ll
  boolean iscolor;
  int f, t, rr, hh=10, len, yy;
  String c;
  float ww, ll;

  if (_show<=1000)
  iscolor = true;
  
  ww = _PIXLEN;
  ll = theStart+_i;
  rr = theStart+_i+_show;

  
  yy = 100 - hh -1;
  
  strokeWeight(1);
  stroke(100, 0, 0, 100);
  for (int z = 0; z < theVsL.length; z++)
  {
    for (int i = 0; i < theVsL[z].theVs.length; ++i) {
        f = theVsL[z].theVs[i].f;
        t = theVsL[z].theVs[i].t;
        if (f>=ll)
        {
          if (t>rr) t = rr;
          for (int j=f; j<=t; j++)
          {
            xx = _PIXLEN*(f-ll)+100;
            if (iscolor)
            {
              //fill color and draw rect
              switch(theVsL[z].theVs[i].b)
              {
                case str('A'):  
                  fill(249,245,56);
                  rect(xx, yy, ww, hh);
                  fill(0);
                  textSize(ww);
                  text('A', xx+1, 100-hh+9);
                  break;
                case str('T'):  
                  fill(133,122,185);
                  rect(xx, yy, ww, hh);
                  fill(0);
                  textSize(ww);
                  text('T', xx+1, 100-hh+9);
                  break;
                 case str('C'):  
                  fill(236,95,75);
                  rect(xx, yy, ww, hh);
                  fill(0);
                  textSize(ww);
                  text('C', xx+1, 100-hh+9);
                  break;
                case str('G'):  
                  fill(122,197,131);
                  rect(xx, yy, ww, hh);
                  fill(0);
                  textSize(ww);
                  text('G', xx+1, 100-hh+9);
                  break;
                default:
                  fill(0, 0, 0);
                  rect(xx,yy, ww, hh);
                  fill(0);
                  textSize(ww);
                  text(c, xx+1, 100-hh+9);
                  
                  break;    
              }

            }
            else
            {
              fill(100, 0, 0);
              rect(xx, yy, ww, hh);
              //draw a tri with transparent
            }
          }
        }
          
      }

  }
      
}
