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

arrowhead mkarrowhead(arrowfun af, real minsize)
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

path isa_af(pair b, pair e)
{
  pair A = b + rotate(90)*Tan(30)*(e-b);
  pair B = b + rotate(-90)*Tan(30)*(e-b);
  return A--B--e--cycle;  
}

path hasa_af(pair b, pair e)
{
  pair A = (b+e)/2 + rotate(90)*Tan(30)*((e-b)/2);
  pair B = (b+e)/2 + rotate(-90)*Tan(30)*((e-b)/2);
  return b--A--e--B--cycle;  
  
}

arrowhead genhead = mkarrowhead(isa_af,18bp);
arrowhead comhead = mkarrowhead(hasa_af,18bp);

struct lstyle
{
  pen p = defaultpen;
  arrowbar arrow = None; 
}



lstyle association;
lstyle ass = association;

lstyle dependency;
dependency.arrow = EndArrow(SimpleHead,lstyle_setting.arrowsize);
dependency.p = dashed;
lstyle dep = dependency;

lstyle generalization;
generalization.arrow = BeginArrow(genhead,FillDraw(white));
lstyle gen = generalization;

lstyle realization;
realization.arrow = BeginArrow(genhead,FillDraw(white));
realization.p = dashed;
lstyle rea = realization;

lstyle composition;
composition.arrow = BeginArrow(comhead,FillDraw(black));
lstyle com = composition;
  
lstyle aggregation;
aggregation.arrow = BeginArrow(comhead,FillDraw(black));
lstyle agg = aggregation;

lstyle dashline;
dashline.p = dashed;



void req_i(picture pic =currentpicture,
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
