/*
 * sml_actor.asy - draw smart actor
 */

private int body = 0;
private int head = 1;
private int lhand1 = 2;
private int lhand2 = 3;
private int rhand1 = 4;
private int rhand2 = 5;
private int lleg1 = 6;
private int lleg2 = 7;
private int rleg1 = 8;
private int rleg2 = 9;


private struct xlead
{
  pair p;
  pair np(pair f)
  {
    return(f.x + p.x*cos(p.y), f.y+p.x*sin(p.y));
  }

  void operator init(pair p)
  {
    this.p = p;
  }
}

private guide  operator ..(guide g, xlead x)
{
  return g..x.np(point(g,length(g)));
}

private guide  operator --(guide g, xlead x)
{
  return g--x.np(point(g,length(g)));
}


private path[] actorpath(pair pos[])
{
  int n = pos.length;
  if(n <10)
    return new path []{};
  xlead xl[] = new xlead[]{};
  for(int i =0; i<n; ++i)
    xl.push(xlead(pos[i]));

  xlead neckxl = xlead((pos[head].x/3,pos[head].y));
  
  pair z1 = (0,0);
  pair z2 = xl[body].np(z1);
  pair z3 = neckxl.np(z2);
  pair z4 = xl[head].np(z2);
  path[] body_head = z1 ..z2..z3^^shift((z3+z4)/2)
    *scale(length(z4-z3)/2)*unitcircle;

  path lhand = z2..xl[lhand1]..xl[lhand2];
  path rhand = z2..xl[rhand1]..xl[rhand2];

  path lleg = z1..xl[lleg1]..xl[lleg2];
  path rleg = z1..xl[rleg1]..xl[rleg2];
  
  return body_head^^lhand^^rhand^^lleg^^rleg;  
}

private real randx(real begin,real end)
{
  real k = unitrand();
  return k*(end -begin) + begin;
}

srand(seconds());

//create a actor by name 
path[] rand_actor()
{  
  pair p1 = (randx(0.6,1),randx(pi/4,pi*3/4));
  pair p2 = (randx(0.8,1),randx(pi/4,pi*3/4));

  pair p3 = (randx(0.6,1),randx(pi*3/4,pi*5/4));
  pair p4 = (randx(0.3,1),randx(pi/2,pi*3/2));

  pair p5 = (randx(0.6,1),randx(-1*pi/4,pi/4));
  pair p6 = (randx(0.3,1),randx(-1*pi/2,pi/2));

  pair p7 = (randx(0.5,1),randx(pi,pi*3/2));
  pair p8 = (randx(0.8,1),randx(pi,pi*3/2));

  pair p9 = (randx(0.5,0.9),randx(-1*pi/2,0));
  pair p10 = (randx(0.6,1),randx(-1*pi/2,0));

  pair [] ps = new pair[]{p1,p2,p3,p4,p5,p6,p7,p8,p9,p10};
  
  return actorpath(ps);
  
}

path[] normal_actor()
{
  pair[] p = new pair[] {(0.8,pi/2),  //body
			 (0.8,pi/2),  //head
			 (0.5,0),     //left hand 1
			 (0.6,0),     //left hand 2
			 (0.5,pi),    //right hand 1
			 (0.6,pi),    //right hand 2
			 (0.8,-1*pi/4), //left leg 1
			 (0.8,-1*pi/4),  //left leg 2
			 (0.8,-3*pi/4),  //right leg 1
			 (0.8,-3*pi/4)}; //rirght leg 2
  return actorpath(p);
}



