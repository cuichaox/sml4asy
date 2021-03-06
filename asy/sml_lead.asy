/**
 * edge.asy
 * - by cuichaox@gmail.com
 *
 */

typedef pair sfun(pair p,real [] para);
typedef pair dfun(pair f,pair t,real [] para);

struct plead
{
  restricted real [] para;
  restricted sfun sf;
  restricted void operator init(sfun sf ...real [] para){
    this.para = copy(para);    
    this.sf =sf;
  }
  restricted pair cal(pair p){
    return sf(p,para);
  }  
}

restricted guide operator..(guide g,plead l)
{  
  return g..l.cal(point(g,length(g)));
}

restricted guide operator::(guide g,plead l)
{ 
  return g::l.cal(point(g,length(g)));
}

restricted guide operator--(guide g,plead l)
{  
  return g--l.cal(point(g,length(g)));  
}

restricted guide operator---(guide g,plead l)
{ 
  return g---l.cal(point(g,length(g)));
}


struct hold
{
  public guide cal(pair p)
  {
    write("Warning: you should not call me . by hold.get()");
    return nullpath;
  }
}
struct mlead
{
  restricted dfun df = null;
  restricted guide pg = nullpath;
  restricted real[] para = null;
  restricted interpolate op = null;
  
  restricted void operator init(dfun df ...real[] para)
  {
    this.op = op;
    this.df = df;
    this.para= copy(para);
  }
  
  restricted guide cal(pair p)
  {
    return op(this.pg,df(point(pg,length(pg)),p,para));
  }
 
  restricted hold tohold(interpolate op,guide pg)
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
  restricted sfun sf = null;
  restricted guide pg = nullpath;
  restricted hold ph = null;
  restricted real[] para;
  restricted interpolate op;
  restricted void operator init(sfun sf ...real [] para){
    this.sf =sf;
    this.para = copy(para);        
  }

  restricted void operator init(sfun sf ...real [] para){
    this.sf =sf;
    this.para = copy(para);        
  }
  
  restricted guide cal(pair p)
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

  restricted hold tohold(interpolate op,guide pg)
  {
    this.pg = pg;
    this.op = op;
    hold x;
    x.cal =this.cal;
    return x;    
  }
  
  restricted hold tohold(interpolate op,hold ph)
  {
    this.ph = ph;
    this.op = op;
    hold x;
    x.cal = this.cal;
    return x;
  }
}

restricted hold operator cast(nlead nl)
{
  return nl.tohold(operator--,nullpath);
}
 

// begin guide op nlead
restricted hold operator..(guide g,nlead nl)
{
  return nl.tohold(operator..,g);
}

restricted hold operator::(guide g, nlead nl)
{
  return nl.tohold(operator::,g);
}

restricted hold operator--(guide g, nlead nl)
{
  return nl.tohold(operator--,g);
}

restricted hold operator---(guide g, nlead nl)
{
  return nl.tohold(operator---,g);
}
//end guide op nlead

//begin guide op mlead
restricted hold operator..(guide g,mlead ml)
{
  return ml.tohold(operator..,g);
}

restricted hold operator::(guide g, mlead ml)
{
  return ml.tohold(operator::,g);
}

restricted hold operator--(guide g, mlead ml)
{
  return ml.tohold(operator--,g);
}

restricted hold operator---(guide g, mlead ml)
{
  return ml.tohold(operator---,g);
}
//end guide op mlead;

//begin hold op nlead
restricted hold operator..(hold h,nlead nl)
{
  return nl.tohold(operator..,h);
}

restricted hold operator::(hold h,nlead nl)
{
  return nl.tohold(operator::,h);
}

restricted hold operator--(hold h,nlead nl)
{
  return nl.tohold(operator--,h);
}

restricted hold operator---(hold h,nlead nl)
{
  return nl.tohold(operator---,h);
}
//end hold op mlead

// begian hold op guide
restricted guide operator..(hold h,guide g)
{
  return h.cal(point(g,0))..g;
}

restricted guide operator::(hold h,guide g)
{
  return h.cal(point(g,0))::g;
}

restricted guide operator--(hold h,guide g)
{
  return h.cal(point(g,0))--g;
}

restricted guide operator---(hold h,guide g)
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
restricted plead pwalk(real x, real y)
{
  return plead(rel,x,y);
}
restricted plead pw(real x, real y) = pwalk;

restricted plead pxwalk(real x)
{
  return pwalk(x,0);
}
restricted plead pxw(real x) = pxwalk;

restricted plead pywalk(real y)
{
  return pwalk(0,y);
}
restricted plead pyw(real y) = pywalk;

restricted nlead nwalk(real x, real y)
{
  return nlead(rel,x,y);
}
restricted nlead nw(real x, real y) = nwalk;

restricted nlead nxwalk(real x)
{
  return nwalk(x,0);
}
restricted nlead nxw(real x) = nxwalk;

restricted nlead nywalk(real y)
{
  return nwalk(0,y);
}
restricted nlead nyw(real y) = nywalk;

restricted mlead leftside(real s = 12pt)
{
  return mlead(lside,s);
}
restricted mlead ls(real s) = leftside;

restricted mlead leftside = leftside();
restricted mlead ls = leftside;
restricted mlead rightside = leftside(-12pt);
restricted mlead rs = rightside;

restricted mlead hv = mlead(hfLpoint);
restricted mlead vh = mlead(vfLpoint);

