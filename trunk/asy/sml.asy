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
  restricted symbol src = null;
  restricted symbol to = null;
  restricted path g = nullpath;
  restricted arrowbar arrow = None; 
  restricted pen p = defaultpen;
  

  restricted pair srcSdir;
  restricted pair srcLdir;
  restricted pair destSdir;
  restricted pair destLdir;
  restricted pair srcPoint;
  restricted pair destPoint;


  public void ldf (picture pic =currentpicture,
	    path g,
	    pen p,
	    arrowbar arrow=None)
  {
    draw(pic,g,p,arrow);
  }
  
  restricted void operator init(symbol src, symbol dest,path g)
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

  restricted linker style(lstyle lst)
  {
    this.arrow = lst.arrow;   
    this.p = lst.p;
    return this;
  }

  restricted linker style(linker_drawer ldf)
  {
    this.ldf = ldf;
    return this;
  }

  restricted  linker draw(picture pic = currentpicture)
  {
    this.ldf(pic,this.g,this.p,this.arrow);
    return this; 
  }

  restricted linker sl(picture pic = currentpicture,
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

  restricted linker ml(picture pic = currentpicture,
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
 


  restricted linker dl(picture pic = currentpicture,
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

restricted void draw(picture pic = currentpicture,linker l)
{
  l.draw(pic);
}


struct pending_linker
{
  public symbol src = null;
  public guide g = nullpath;
  public hold h = null;
  restricted void operator init(symbol s)
  {
    this.src = s;
    this.g = (s.min()+s.max())/2;
  }  
}

restricted pending_linker copy(pending_linker plk)
{
  pending_linker ret;
  ret.src = plk.src;
  ret.g = plk.g;
  ret.h = plk.h;
  return ret;    
}

restricted pending_linker operator cast(symbol s)
{
  return pending_linker(s);  
}

//begin pending_linker op guide
restricted pending_linker operator..(pending_linker pl,guide g)
{  
  if(alias(pl.h,null)){
    pl.g = pl.g..g;    
  }
  else{
    pl.g = pl.h..g;
 }
  return pl;    
}

restricted pending_linker operator::(pending_linker pl,guide g)
{
  if(alias(pl.h,null)){
    pl.g = pl.g::g;    
  }
  else{
    pl.g = pl.h::g;
  }
  return pl;    
}

restricted pending_linker operator--(pending_linker pl,guide g)
{
  if(alias(pl.h,null)){
    pl.g = pl.g--g;    
  }
  else{
    pl.g = pl.h--g;
  }
  return pl;    
}

restricted pending_linker operator---(pending_linker pl,guide g)
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
restricted pending_linker operator..(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g .. pld;
  return plk;
}

restricted pending_linker operator::(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g :: pld;
  return plk;
}

restricted pending_linker operator--(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g -- pld;
  return plk;
}

restricted pending_linker operator---(pending_linker plk,plead pld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a plead.");
  }
  plk.g = plk.g --- pld;
  return plk;
}
//end pending_linker op plead

//begin pending_linker op mlead
restricted pending_linker operator ..(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ..mld;
  return plk;
}
restricted pending_linker operator ::(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ::mld;
  return plk;
}

restricted pending_linker operator --(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g --mld;
  return plk;
}

restricted pending_linker operator ---(pending_linker plk,mlead mld)
{
  if(!alias(plk.h,null)){
    abort("Can't Fllow a holding path with a mlead.");
  }
  plk.h = plk.g ---mld;
  return plk;
}
//end pending_linker op mlead

//begin pending_linker op nlead
restricted pending_linker operator ..(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g ..nld;
  } else{
    plk.h = plk.h ..nld;
  }
  return plk;    
}
restricted pending_linker operator ::(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g ::nld;
  } else{
    plk.h = plk.h ::nld;
  }
  return plk;    
}
restricted pending_linker operator --(pending_linker plk,nlead nld)
{
  if(alias(plk.h,null)){
    plk.h = plk.g --nld;
  } else{
    plk.h = plk.h --nld;
  }
  return plk;    
}
restricted pending_linker operator ---(pending_linker plk,nlead nld)
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
restricted linker operator ..(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk .. z;
  return linker(plk.src,s,plk.g);  
}

restricted linker operator ::(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk :: z;
  return linker(plk.src,s,plk.g);  
}

restricted linker operator --(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk -- z;
  return linker(plk.src,s,plk.g);  
}

restricted linker operator ---(pending_linker plk, symbol s)
{
  pair z = (s.min() + s.max())/2;
  plk = plk --- z;
  return linker(plk.src,s,plk.g);  
}

//end pending_linker op symbol

struct mlinker
{
  restricted linker[] linkers;
  restricted void operator init(linker[] ls)
  {
    this.linkers = ls;
  }
  
  restricted mlinker style(lstyle lst)
  {
    int n = linkers.length;
    for(int i =0; i<n; ++i)
      linkers[i].style(lst);
    return this;
  }

  restricted mlinker draw(picture pic = currentpicture)
  {
    int n = linkers.length;
    for(int i=0; i<n; ++i)
      linkers[i].draw(pic);
    return this;
  }

  restricted mlinker sl(picture pic = currentpicture,
	     string l)
  {
    int n = linkers.length;
    if(n >=1)
      (this.linkers[0]).sl(pic,l);
    return this;
  }

  restricted mlinker dl(picture pic = currentpicture,
	     string l)
  {
    int n = linkers.length;
    for(int i=0; i<n; ++i)
      this.linkers[i].dl(pic,l);
    return this;
  }

}

restricted void draw(picture pic = currentpicture,mlinker ml)
{
  ml.draw();
}


//begin pending_linker op symbol[]
restricted mlinker operator ..(pending_linker plk,symbol[] ss)
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

restricted mlinker operator ::(pending_linker plk,symbol[] ss)
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

restricted  mlinker operator --(pending_linker plk,symbol[] ss)
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

restricted  mlinker operator ---(pending_linker plk,symbol[] ss)
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
