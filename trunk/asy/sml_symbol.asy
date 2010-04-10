/*
 *sml_symbol.asy - another package for draw UML
 * form the second idea
 *
 * create by cuichaox@gmail.com
 * home: http://cuichaox.cublog.cn
 *
 */

struct T_SYM_SETTING
{
  real gxmagin = 6bp;
  real gymagin = 6bp;
  
  real cxmagin = 3bp;
  real cymagin = 3bp;

  real pxmagin = 8bp;
  real pymagin = 8bp;

  real notexmagin = 8bp;
  real noteymagin = 8bp;

  real nodedepth = 12pt;

  real minnw = 1.8cm;
  real ncorner = 3mm;

  real iballsize = 6bp;

  real comiconw = 14bp;
};
T_SYM_SETTING symbol_setting;

// Some basic data type.
private struct ruler
{
  real r;
  void operator init(real r){
    if(r < 0.0)
      this.r = 0.0;
    else if(r > 1.0)
      this.r = 1.0;
    else	  
      this.r =r;
  }
}

ruler LEFT = ruler(0.0);
ruler RIGHT = ruler(1.0);
ruler TOP = ruler(1.0);
ruler TOE = ruler(1.0);
ruler MID = ruler(0.5);



typedef real gapfun(... real w[]);
struct gapper
{
  real k =1.0;
  gapfun gf = null;
  void operator init(gapfun f, real k = 1.0)
  {
    this.gf =f;
    this.k = k;
  }
  
  real getv(... real w[])
  {
    return k* gf(...w);
  }  
}

private real avg(... real w[])
{
  return sum(w)/w.length;  
}

private real one(... real w[])
{
  return 1.0;
}

gapper operator cast (real r)
{
  return gapper(one,r);
}

public gapper AVG = gapper(avg);

gapper operator * (real r,gapper gap)
{
  gapper ret;
  ret.k = gap.k*r;
  ret.gf = gap.gf;  
  return ret;
}


// A Sturcture to hold symbol
struct symbol{
  frame f;
  path g = nullpath; //Bounding path
  symbol[] sub;
  bool drawed = false;
  bool docked = false;

  void trans(transform t){
    this.f = t*this.f;
    this.g = t*this.g;
    int n = sub.length;
    for(int i=0; i<n; ++i){
      sub[i].trans(t);
    }       
  }

  pair min(){
    if(this.g != nullpath)
      return min(this.g);
    return(0,0);
  }
  
  pair max(){
    if(this.g != nullpath)
      return max(this.g);
    return(0,0);
  }

  void move2c(){
    pair minp = this.min();
    pair maxp = this.max();
    pair c = (minp + maxp)/2;
    this.trans(shift(-1*c));        
  }

  void dotc()
  {
    pair minp = this.min();
    pair maxp = this.max();
    pair c = (minp + maxp)/2;
  }
  

  void delsub(){
    int n = sub.length;
    for(int i=0; i<n; ++i)
      sub[i].delsub();
    sub.delete();
  }
    

  void add(frame f){
    if(empty(this.f))
      return;
    if(this.drawed){
      abort("You can't dock a drwawed symbol. Copy it first.");
    }
    if(this.docked){
      abort("You can't dock a  symbol twice. Copy it first. ");
    } 
        
    add(f,this.f);
     this.docked = true;
  }

  void add(picture dest = currentpicture,
	   bool group = true,
	   filltype filltype = NoFill,
	   bool above = true)
  {
    if(empty(this.f))
      return;
    if(this.drawed){
      abort("You can't drawed one symbol twice. Copy it first.");
    }
    if(this.docked){
      abort("You can't drawd a docked symbol. Copy it firest.");
    }    
    
    add(dest,this.f,(0,0),group,filltype,above);
    this.drawed = true;
    
  }
	   
  void opterator(object o){
    this.f = o.f;
    this.g = o.g;
    this.sub = new symbol[];
    this.move2c();
  }

   void operator init(frame f) {
    this.f=f;
    this.g=box(min(f),max(f));
    this.sub = new symbol[];
    this.move2c();
  }

  void operator init(Label L) {
    L.out(this.f);
    this.g=box(min(f),max(f));
    this.sub = new symbol[];
    this.move2c();
  }
  
}

symbol copy(symbol s,bool andsub = false)
{
  symbol ret;
  ret.g = s.g;
  bool docked = s.docked;
  bool drawed = s.drawed;
  s.add(ret.f);  
  if(andsub){
    int n = s.sub.length;
    for(int i =0; i<n; ++i){
      ret.sub.push(copy(s.sub[i]));
    }
  }
  s.docked = docked;
  s.drawed = drawed;
  
  ret.drawed = false;
  ret.docked = false;
  return ret;
    
}

object operator cast(symbol s)
{
  object ret;
  ret.f = s.f;
  ret.g = s.g;
  return ret;
}

symbol operator cast(string s)
{
  return symbol(s);
}


symbol blank ;
symbol hdock(gapper gap = AVG,
	     ruler r = TOE
	     ... symbol[] insect)
{
  symbol ret;
  
  int n = insect.length;
  if(n < 1)
    return ret;
  real h[] = new real[];
  real w[] = new real[];
  h.cyclic = true;
  w.cyclic = true;
  
  for( int i=0; i<n; ++i){
    pair s = insect[i].max() - insect[i].min();

    h.push(s.y);
    w.push(s.x);
  }
  

  real xgap = gap.getv(...w);
  pair z = (0,0);

  for(int i=0; i<n; ++i){
    pair o = insect[i].min();
    o += (w[i]/2,h[i]*r.r);
    insect[i].trans(shift(z)*shift(-1*o));
    ret.sub.push(insect[i]);
    insect[i].add(ret.f);
    z += (xgap + (w[i]+w[i+1])/2,0);    
  }

  ret.move2c();
  
  ret.g = box(min(ret.f),max(ret.f));
  
  return ret;    
}

symbol dock(gapper gap = AVG,
	    ruler r = TOE,
	    real angle = 0.0
	    ... symbol[] insect)
{
  int n = insect.length;
  for(int i=0; i<n; ++i)
    insect[i].trans(rotate(-1 * angle));
  symbol ret = hdock(gap,r ... insect);
  ret.trans(rotate(angle));
  return ret;
}

symbol vdock(gapper gap = AVG,
	     ruler r = TOE
	     ... symbol[] insect)
{
  return dock(gap,r,-90 ... insect);
}

// make a grid  
private symbol mkvgrid(symbol[] insect,
		       int[] aligns,
		       real xmagin = symbol_setting.gxmagin,
		       real ymagin = symbol_setting.gymagin)
{
  symbol ret;
  pair z =(0,0);
  int xaligns[] =copy(aligns);

  xaligns.cyclic=true;
  if(xaligns.length == 0)
    xaligns.push(0);

  
  real h[] = new real[];
  real w[] = new real[];

  int n = insect.length;
  for(int i=0; i<n; ++i){
    pair s = (0,0);
    if(!empty(insect[i].f))
      s = insect[i].max()-insect[i].min();
    h.push(s.y);
    w.push(s.x);
  }
  real gw = max(w) + 2*xmagin;
  real gh = sum(h) + 2*ymagin*n;
  ret.g = box((0,0),(gw,gh));
  
  draw(ret.f,ret.g);
  real rh = gh;
  for(int i=0; i<n-1; ++i){
    rh -= h[i]+2*ymagin;
    draw(ret.f,(0,rh)--(gw,rh));
  }

  rh = gh;
  
  for(int i =0; i<n; ++i){
    real px = gw/2.0;
    if(xaligns[i] < 0 )
      px -= (gw - w[i])/2.0;
    else if(xaligns[i] > 0)
      px += (gw - w[i])/2.0;
    
    real py = rh - ymagin - h[i]/2.0;
    rh -= h[i]+2*ymagin;
    insect[i].trans(shift(px,py));
    insect[i].add(ret.f);
  }
  ret.sub = insect;
  
  
  ret.move2c();
  return ret;  
}       

// make a class
symbol mkclass(symbol name,          //name
	       symbol attrs = blank, //attributes
	       symbol opers = blank) //operations
{
  
  symbol ret = mkvgrid(new symbol []{name, attrs, opers},
		       new int []{0,-1,-1},
		       symbol_setting.cxmagin,
		       symbol_setting.cymagin);
  ret.delsub();
  return ret;
}

// make a class name part
symbol mkcname(string name,                  // main name
	       string stero = "",            // sterotype
	       bool abst = false)     // is a abstract class
{
  string xname;
   if(abst)
     xname = "\it " + name;
   else
     xname = "\bf " + name;

   if(length(stero) != 0){
     string xstero = " \small $\ll$" + stero +"$\gg$";
     return vdock(0.05,MID,symbol(xstero),symbol(xname));
   }   
   return symbol(xname);
}

symbol mkclass(string name)
{
  return mkclass(mkcname(name));
}

//make a class attributes part
symbol mkattrs(... string[] attrs)
{
  symbol attr_symbols[] = new symbol[];
  int n = attrs.length;
  for(int i =0; i<n; ++i)
    attr_symbols.push(symbol(attrs[i]));
  return vdock(0.05,LEFT ... attr_symbols);
}

//make a class operation part
symbol mkopers(... string[] attrs) = mkattrs;

//make a object symbol
symbol mkobj(string name,         //object name
	     symbol attrs = blank) //object attributes value list
{
  symbol head = symbol("\underline{" + name + "}");
  return mkvgrid(new symbol [] {head,attrs}, new int []{0,-1});
}


//make a package symbol
symbol mkpack(symbol c = null,string name = " ")
{
  symbol ret;   
  string xname = "\bf "+name;
  symbol head = symbol(xname);
  symbol body = c;
  if(alias(body,null)){
    body = head;
    head = symbol(" ");
    }
  else{
    ret.sub.push(c);
  }

  pair hw = head.max() - head.min();
  hw = hw + (symbol_setting.pxmagin,symbol_setting.pymagin);
  pair bw = body.max() - body.min();
  bw = bw + 2*(symbol_setting.pxmagin,symbol_setting.pymagin);

  real bwx = (bw.x > 3*hw.x)? bw.x : 3*hw.x;
  real bwy = (bw.y > 3*hw.y)? bw.y : 3*hw.y;

  real hwx = (hw.x > bw.x/3)? hw.x : bw.x/3;
  real hwy = hw.y;

  draw(ret.f,(0,0)--(bwx,0)--(bwx,bwy)--(0,bwy)--cycle);
  body.trans(shift(bwx/2.0,bwy/2.0));
  body.add(ret.f);

  draw(ret.f,(0,bwy)--(0,bwy+hwy)--(hwx,bwy+hwy)--(hwx,bwy));
  head.trans(shift(hwx/2,bwy+hwy/2));
  head.add(ret.f);
  ret.g = (0,0)--(bwx,0)--(bwx,bwy)--(hwx,bwy)--(hwx,bwy+hwy)--(0,bwy+hwy)--cycle;
  ret.move2c();
  
  return ret;
}

//make a box symbol
symbol mkbox(symbol c)
{
  symbol ret;
  ret.sub.push(c);
  c.add(ret.f);
  ret.g = box(ret.f,c.f,symbol_setting.gxmagin,symbol_setting.gymagin);
  return ret;
}

symbol mkrbox(symbol c)
{
  symbol ret;
  ret.sub.push(c);
  c.add(ret.f);
  ret.g = roundbox(ret.f,c.f,symbol_setting.gxmagin,symbol_setting.gymagin);
  return ret;
}

symbol mkellipse(symbol c)
{
  symbol ret;
  ret.sub.push(c);
  c.add(ret.f);
  ret.g =ellipse(ret.f,c.f,symbol_setting.gxmagin,symbol_setting.gymagin);
  return ret;
}

symbol mkcase(string desc)
{
  symbol ret = mkellipse(symbol(desc));
  ret.delsub();
  return ret;
}

//make a note symbol
symbol mknote(string s,real w = symbol_setting.minnw)
{
  w = (w > symbol_setting.minnw)? w: symbol_setting.minnw;
  real tw = w - symbol_setting.ncorner - symbol_setting.notexmagin;
  string text = minipage(s,tw);
  symbol ret = symbol(text);

  pair a = (ret.min() - (symbol_setting.notexmagin,symbol_setting.noteymagin));
  pair c =ret.max();
  pair c1 = c + (symbol_setting.ncorner,0);
  pair c2 = c + (0,symbol_setting.ncorner);
  ret.g = a--(c1.x,a.y)--c1--c2--(a.x,c2.y)--cycle;
  draw(ret.f,ret.g);
  draw(ret.f,c1--c--c2);

  return ret;  
}

symbol mkcircle(symbol c)
{
  symbol ret;
  ret.sub.push(c);
  c.add(ret.f);
  real x = length(ret.max() - ret.min())/2 + symbol_setting.gxmagin;
  ret.g = scale(x)*unitcircle;
  draw(ret.f,ret.g);
  return ret;  
}

include "sml_actor.asy";

symbol mkactor(string name="",bool rand = false,real size = 12pt)
{
  path[] x = null;
  if(rand){
    x = scale(size)*rand_actor();
  }else {
    x = scale(size)*normal_actor();
  }
  
  symbol actor;
  draw(actor.f,x);
  actor.g = box(actor.min(),actor.max());

  if(length(name) == 0)
    return actor;

  symbol ret;
  ret = vdock(3pt,MID,actor,symbol(name));
  ret.delsub();
  return ret;
}

symbol mknode(symbol c)
{
  symbol ret;
  c.add(ret.f);

  pair A = c.min();
  pair C = c.max();

  A = A -(symbol_setting.gxmagin,symbol_setting.gymagin);
  C = C +(symbol_setting.gxmagin,symbol_setting.gymagin);

  pair B = (A.x,C.y);
  pair D = (C.x,A.y);

  real t = symbol_setting.nodedepth;
  pair B1 = B + (t,t);
  pair C1 = C + (t,t);
  pair D1 = D + (t,t);

  ret.g = A--B--B1--C1--D1--D--cycle;
  draw(ret.f,ret.g);
  draw(ret.f,D--C--B^^C--C1);
   
  return ret;
}

symbol mkiball(string name, pair label_dir = S)
{
  symbol ret;
  ret.g = scale(symbol_setting.iballsize)*unitcircle;
  draw(ret.f,ret.g);
  real gmargin = length((symbol_setting.gxmagin,symbol_setting.gymagin));
  pair label_pos = dir(S)*(symbol_setting.iballsize + gmargin);
  
  label(ret.f,Label(name),label_pos);
  return ret;    
}

symbol mkcomicon()
{
  symbol ret;
  real bw = symbol_setting.comiconw*4/5;
  path body1 = (0,bw*4/5)--(0,bw)--(bw,bw)--(bw,0)--(0,0)--(0,bw/5);
  path body2 = (0,bw*2/5)--(0,bw*3/5);
  path t1 = box((-1*bw/5,bw/5),(bw/5,bw*2/5));
  path t2 = box((-1bw/5,bw*3/5),(bw/5,bw*4/5));
  draw(ret.f, body1^^body2^^t1^^t2);
  ret.g = box(min(ret.f),max(ret.f));
  ret.move2c();
  return ret;
  
}

symbol mkcom(string name, string stero ="")
{  
  symbol left= mkcname(name,stero);
  symbol right = mkcomicon();
  symbol ret = mkbox(hdock(1bp,TOP,left,right));
  ret.delsub();
  return ret;  
}




