/*
 * sml_arrows.asy - draw arrows for sml 
 * by cuichaox@gmail.com
 */

struct T_SML_LSTYLE
{
  real iballsize = 6bp;
  real itraysize = iballsize + 3bp;;
  real arrowsize = 8bp;
};

T_SML_LSTYLE lstyle_setting;


typedef void linker_drawer(picture pic =currentpicture,
		      path g,
		      pen p,
		      arrowbar arrow=None);  


/*
 * This function give a simple way to create a arrowhead
 */
typedef path arrowfun(pair b, pair e);

restricted arrowhead mkarrowhead(arrowfun af, real minsize)
{
  arrowhead xhead;
  xhead.head=new path(path g, position position=EndPoint, pen p=currentpen,
                      real size=0, real angle=arrowangle){
    if(size == 0)
      size = xhead.size(p);
    if(size < minsize)
      size = minsize;
    
    bool relative=position.relative;
    real position=position.position.x;
    if(relative)
      position=reltime(g,position);
    
    path r=subpath(g,position,0);
  
    pair endp=point(r,0);
    real t=arctime(r,size);
    pair beginp=point(r,t);
  
    return af(beginp,endp);  
    };
  return xhead;
}

restricted path isa_af(pair b, pair e)
{
  pair A = b + rotate(90)*Tan(30)*(e-b);
  pair B = b + rotate(-90)*Tan(30)*(e-b);
  return A--B--e--cycle;  
}

restricted path hasa_af(pair b, pair e)
{
  pair A = (b+e)/2 + rotate(90)*Tan(30)*((e-b)/2);
  pair B = (b+e)/2 + rotate(-90)*Tan(30)*((e-b)/2);
  return b--A--e--B--cycle;  
  
}

restricted arrowhead genhead = mkarrowhead(isa_af,18bp);
restricted arrowhead comhead = mkarrowhead(hasa_af,18bp);

struct lstyle
{
  public pen p = defaultpen;
  public arrowbar arrow = None; 
}



restricted lstyle association;
restricted lstyle ass = association;

restricted lstyle dependency;
dependency.arrow = EndArrow(SimpleHead,lstyle_setting.arrowsize);
dependency.p = dashed;
restricted lstyle dep = dependency;

restricted lstyle generalization;
generalization.arrow = BeginArrow(genhead,FillDraw(white));
restricted lstyle gen = generalization;

restricted lstyle realization;
realization.arrow = BeginArrow(genhead,FillDraw(white));
realization.p = dashed;
restricted lstyle rea = realization;

restricted lstyle composition;
composition.arrow = BeginArrow(comhead,FillDraw(black));
restricted lstyle com = composition;
  
restricted lstyle aggregation;
aggregation.arrow = BeginArrow(comhead,FillDraw(black));
restricted lstyle agg = aggregation;

restricted lstyle dashline;
dashline.p = dashed;



restricted void req_i(picture pic =currentpicture,
	   path g,
	   pen p,
	   arrowbar arrow=None)
{
  real t = length(g);
  pair endpos = point(g,t);
  pair enddir = dir(g,t);
  pair o = endpos + scale(lstyle_setting.iballsize)*enddir;
  real md = degrees(-1*enddir);
  path x = arc(o,lstyle_setting.itraysize,md-60,md+60);

  real T[] = intersect(g,x);
  if(T.length > 0)
    g = subpath(g,0,T[0]);

  draw(pic,x,p);
  draw(pic,g,p,arrow);
  
}
