/**
 * sml.asy  - an asympote module for draw uml diagram
 *   by cuichaox@gmail.com
 */

include sml_symbol;
include sml_lead;
include sml_untility;
include sml_lstyle;

lstyle_setting.iballsize = symbol_setting.iballsize;

struct linker
{
  symbol src = null;
  symbol to = null;
  path g = nullpath;
  arrowbar arrow = None; 
  pen p = defaultpen;
  

  pair srcSdir;
  pair srcLdir;
  pair destSdir;
  pair destLdir;
  pair srcPoint;
  pair destPoint;


  void ldf (picture pic =currentpicture,
	    path g,
	    pen p,
	    arrowbar arrow=None)
  {
    draw(pic,g,p,arrow);
  }
  
  void operator init(symbol src, symbol dest,path g)
  {
    this.src = src;
    this.to = to;
    this.g =g;
    
    real T1[] = intersect(src.g,this.g);
    if (T1.length < 2){
      abort("This linker is not on the source symbol.");
    }
    
    srcSdir = dir(src.g,T1[0]);
    srcLdir = dir(this.g,T1[1]);
    srcPoint = point(this.g,T1[1]);

    real T2[] = intersect(dest.g,this.g);
    if(T2.length <2){
      abort("This linker is not on the dest symbol.");
    }
    destSdir = dir(dest.g,T2[0]);
    destLdir = -1*dir(this.g,T2[1]);
    destPoint = point(this.g,T2[1]);
        
    this.g = subpath(this.g,T1[1],T2[1]);
  }

  linker style(lstyle lst)
  {
    this.arrow = lst.arrow;   
    this.p = lst.p;
    return this;
  }

  linker style(linker_drawer ldf)
  {
    this.ldf = ldf;
    return this;
  }

  linker draw(picture pic = currentpicture)
  {
    this.ldf(pic,this.g,this.p,this.arrow);
    return this; 
  }

  linker sl(picture pic = currentpicture,
	    string l)
  {
    object obj = Label(l);
    real xdegrees = abs(degrees(srcSdir)-degrees(srcLdir));
    if(xdegrees < 90){
      srcSdir = -1 * srcSdir;
    }
    put2corner(pic,srcPoint,srcSdir,srcLdir,obj);    
    return this;    
  }

  linker ml(picture pic = currentpicture,
	    string l, bool stero = true)
  {
    if(stero)
      l = " \small $\ll$" + l +"$\gg$";
    object obj = Label(l);    
    real mt = reltime(this.g ,0.5);
    pair mdir = dir(this.g,mt);
    if(mdir.x < 0)
      mdir = -1*mdir;
    put2side(pic,this.g,mt,rotate(degrees(mdir))*obj);      
    return this;
  }
 


  linker dl(picture pic = currentpicture,
	    string l)
  {
    object obj = Label(l);
    real xdegrees = abs(degrees(destSdir)-degrees(destLdir));
    if(xdegrees < 90){
      destSdir = -1 * destSdir;
    }
    put2corner(pic,destPoint,destSdir,destLdir,obj);    
    return this;   
  }
  
}

void draw(picture pic = currentpicture,linker l)
{
  l.draw(pic);
}


struct pending_linker
{
  symbol src = null;
  guide g = nullpath;
  hold h = null;
  void operator init(symbol s)
  {
    this.src = s;
    this.g = (s.min()+s.max())/2;
  }  
}

pending_linker copy(pending_linker plk)
{
  pending_linker ret;
  ret.src = plk.src;
  ret.g = plk.g;
  ret.h = plk.h;
  return ret;    
}

pending_linker operator cast(symbol s)
{
  return pending_linker(s);  
}

//begin pending_linker op guide
pending_linker operator..(pending_linker pl,guide g)
{  
  if(alias(pl.h,null)){
    pl.g = pl.g..g;    
  }
  else{
    pl.g = pl.h..g;
 }
  return pl;    
}

pending_linker operator::(pending_linker pl,guide g)
{
  if(alias(pl.h,null)){
    pl.g = pl.g::g;    
  }
  else{
    pl.g = pl.h::g;
  }
  return pl;    
}

pending_linker operator--(pending_linker pl,guide g)
{
  if(alias(pl.h,null)){
    pl.g = pl.g--g;    
  }
  else{
    pl.g = pl.h--g;
  }
  return pl;    
}

pending_linker operator---(pending_linker pl,guide g)
{
  if(alias(pl.h,null)){
    pl.g = pl.g---g;    
  }
  else{
    pl.g = pl.h---g;
  }
  return pl;    
}
//end pending_linker op guide

//beging pending_linker op plead
pending_linker operator..(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g .. pld;
  return plk;
}

pending_linker operator::(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g :: pld;
  return plk;
}

pending_linker operator--(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g -- pld;
  return plk;
}

pending_linker operator---(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g --- pld;
  return plk;
}
//end pending_linker op plead

//begin pending_linker op mlead
pending_linker operator ..(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ..mld;
  return plk;
}
pending_linker operator ::(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ::mld;
  return plk;
}

pending_linker operator --(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g --mld;
  return plk;
}

pending_linker operator ---(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ---mld;
  return plk;
}
//end pending_linker op mlead

//begin pending_linker op nlead
pending_linker operator ..(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g ..nld;
  } else{
    plk.h = plk.h ..nld;
  }
  return plk;    
}
pending_linker operator ::(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g ::nld;
  } else{
    plk.h = plk.h ::nld;
  }
  return plk;    
}
pending_linker operator --(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g --nld;
  } else{
    plk.h = plk.h --nld;
  }
  return plk;    
}
pending_linker operator ---(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g ---nld;
  } else{
    plk.h = plk.h ---nld;
  }
  return plk;    
}
//end pending_linker op nlead

//begin pending_linker op symbol
linker operator ..(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk .. z;
  return linker(plk.src,s,plk.g);  
}

linker operator ::(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk :: z;
  return linker(plk.src,s,plk.g);  
}

linker operator --(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk -- z;
  return linker(plk.src,s,plk.g);  
}

linker operator ---(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk --- z;
  return linker(plk.src,s,plk.g);  
}

//end pending_linker op symbol

struct mlinker
{
  linker[] linkers;
  void operator init(linker[] ls)
  {
    this.linkers = ls;
  }
  
  mlinker style(lstyle lst)
  {
    int n = linkers.length;
    for(int i =0; i<n; ++i)
      linkers[i].style(lst);
    return this;
  }

  mlinker draw(picture pic = currentpicture)
  {
    int n = linkers.length;
    for(int i=0; i<n; ++i)
      linkers[i].draw(pic);
    return this;
  }

  mlinker sl(picture pic = currentpicture,
	     string l)
  {
    int n = linkers.length;
    if(n >=1)
      (this.linkers[0]).sl(pic,l);
    return this;
  }

  mlinker dl(picture pic = currentpicture,
	     string l)
  {
    int n = linkers.length;
    for(int i=0; i<n; ++i)
      this.linkers[i].dl(pic,l);
    return this;
  }

}

void draw(picture pic = currentpicture,mlinker ml)
{
  ml.draw();
}


//begin pending_linker op symbol[]
mlinker operator ..(pending_linker plk,symbol[] ss)
{
  linker [] ls = new linker[]{};
  int n = ss.length;
  for(int i=0; i<n; ++i){
    pending_linker xplk = copy(plk);
    linker l = xplk .. ss[i];
    ls.push(l);
  }
  return mlinker(ls);
}

mlinker operator ::(pending_linker plk,symbol[] ss)
{
  linker [] ls = new linker[]{};
  int n = ss.length;
  for(int i=0; i<n; ++i){
    pending_linker xplk = copy(plk);
    linker l = xplk :: ss[i];
    ls.push(l);
  }
  return mlinker(ls);
}

mlinker operator --(pending_linker plk,symbol[] ss)
{
  linker [] ls = new linker[]{};
  int n = ss.length;
  for(int i=0; i<n; ++i){
    pending_linker xplk = copy(plk);
    linker l = xplk -- ss[i];
    ls.push(l);
  }
  return mlinker(ls);
}

mlinker operator ---(pending_linker plk,symbol[] ss)
{
  linker [] ls = new linker[]{};
  int n = ss.length;
  for(int i=0; i<n; ++i){
    pending_linker xplk = copy(plk);
    linker l = xplk --- ss[i];
    ls.push(l);
  }
  return mlinker(ls);
}

//end pending_linker op symbol[]
