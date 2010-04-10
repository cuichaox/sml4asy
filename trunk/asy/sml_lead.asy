/**
 * edge.asy
 * - by cuichaox@gmail.com
 *
 */

typedef pair sfun(pair p,real [] para);
typedef pair dfun(pair f,pair t,real [] para);

struct plead
{
  real [] para;
  sfun sf;
  void operator init(sfun sf ...real [] para){
    this.para = copy(para);    
    this.sf =sf;
  }
  pair cal(pair p){
    return sf(p,para);
  }  
}

guide operator..(guide g,plead l)
{  
  return g..l.cal(point(g,length(g)));
}

guide operator::(guide g,plead l)
{ 
  return g::l.cal(point(g,length(g)));
}

guide operator--(guide g,plead l)
{  
  return g--l.cal(point(g,length(g)));  
}

guide operator---(guide g,plead l)
{ 
  return g---l.cal(point(g,length(g)));
}


struct hold
{
  guide cal(pair p)
  {
    write("Warning: you should not call me . by hold.get()");
    return nullpath;
  }
}
struct mlead
{
  dfun df = null;
  guide pg = nullpath;
  real[] para = null;
  interpolate op = null;
  
  void operator init(dfun df ...real[] para)
  {
    this.op = op;
    this.df = df;
    this.para= copy(para);
  }
  
  guide cal(pair p)
  {
    return op(this.pg,df(point(pg,length(pg)),p,para));
  }
 
  hold tohold(interpolate op,guide pg)
  {
    this.pg = pg;
    this.op = op;
    hold x;
    x.cal =this.cal;
    return x; 
  }
}

struct nlead
{
  sfun sf = null;
  guide pg = nullpath;
  hold ph = null;
  real[] para;
  interpolate op;
  void operator init(sfun sf ...real [] para){
    this.sf =sf;
    this.para = copy(para);        
  }

  void operator init(sfun sf ...real [] para){
    this.sf =sf;
    this.para = copy(para);        
  }
  
  guide cal(pair p)
  {
    pair x = sf(p,para);
    
    if(!alias(ph,null)){
      this.pg = ph.cal(x);      
    }

    if(alias(this.pg,nullpath)){
      return x;
    }
    return op(this.pg,x);    
  }

  hold tohold(interpolate op,guide pg)
  {
    this.pg = pg;
    this.op = op;
    hold x;
    x.cal =this.cal;
    return x;    
  }
  
  hold tohold(interpolate op,hold ph)
  {
    this.ph = ph;
    this.op = op;
    hold x;
    x.cal = this.cal;
    return x;
  }
}

hold operator cast(nlead nl)
{
  return nl.tohold(operator--,nullpath);
}
 

// begin guide op nlead
hold operator..(guide g,nlead nl)
{
  return nl.tohold(operator..,g);
}

hold operator::(guide g, nlead nl)
{
  return nl.tohold(operator::,g);
}

hold operator--(guide g, nlead nl)
{
  return nl.tohold(operator--,g);
}

hold operator---(guide g, nlead nl)
{
  return nl.tohold(operator---,g);
}
//end guide op nlead

//begin guide op mlead
hold operator..(guide g,mlead ml)
{
  return ml.tohold(operator..,g);
}

hold operator::(guide g, mlead ml)
{
  return ml.tohold(operator::,g);
}

hold operator--(guide g, mlead ml)
{
  return ml.tohold(operator--,g);
}

hold operator---(guide g, mlead ml)
{
  return ml.tohold(operator---,g);
}
//end guide op mlead;

//begin hold op nlead
hold operator..(hold h,nlead nl)
{
  return nl.tohold(operator..,h);
}

hold operator::(hold h,nlead nl)
{
  return nl.tohold(operator::,h);
}

hold operator--(hold h,nlead nl)
{
  return nl.tohold(operator--,h);
}

hold operator---(hold h,nlead nl)
{
  return nl.tohold(operator---,h);
}
//end hold op mlead

// begian hold op guide
guide operator..(hold h,guide g)
{
  return h.cal(point(g,0))..g;
}

guide operator::(hold h,guide g)
{
  return h.cal(point(g,0))::g;
}

guide operator--(hold h,guide g)
{
  return h.cal(point(g,0))--g;
}

guide operator---(hold h,guide g)
{
  return h.cal(point(g,0))---g;
}
//end hold op guide

 
private pair rel(pair p, real[] para)
{
  int i = para.length;
  for(; i<2; ++i)
    para.push(0);
  return (p.x+para[0], p.y+para[1]); 
}

private pair lside(pair f, pair t, real[] para)
{
  if(para.length == 0)
    para.push(6pt);
  pair z = ((f+t)/2 + scale(para[0])*rotate(degrees(t-f)-90)*(1,0));
  return z;
}

private pair hfLpoint(pair f,pair t)
{
  return (t.x, f.y);
}

private pair hfLpoint(pair f,pair t,real[] para)
{
  return (t.x, f.y);
}

private pair vfLpoint(pair f,pair t,real[] para)
{
  return (f.x,t.y);
}

// predefined lead
plead pwalk(real x, real y)
{
  return plead(rel,x,y);
}
plead pw(real x, real y) = pwalk;

plead pxwalk(real x)
{
  return pwalk(x,0);
}
plead pxw(real x) = pxwalk;

plead pywalk(real y)
{
  return pwalk(0,y);
}
plead pyw(real y) = pywalk;

nlead nwalk(real x, real y)
{
  return nlead(rel,x,y);
}
nlead nw(real x, real y) = nwalk;

nlead nxwalk(real x)
{
  return nwalk(x,0);
}
nlead nxw(real x) = nxwalk;

nlead nywalk(real y)
{
  return nwalk(0,y);
}
nlead nyw(real y) = nywalk;

mlead leftside(real s = 12pt)
{
  return mlead(lside,s);
}
mlead ls(real s) = leftside;

mlead leftside = leftside();
mlead ls = leftside;
mlead rightside = leftside(-12pt);
mlead rs = rightside;

mlead hv = mlead(hfLpoint);
mlead vh = mlead(vfLpoint);

