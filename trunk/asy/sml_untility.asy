/**
 * sml_untility.asy - some untility
 *    by cuichaox@gmail.com
 */

struct T_SML_SETTING
{
  real max_distance = 25cm;
  real min_distance = 5bp;
}

T_SML_SETTING sml_setting;

private bool isintersect(pair o,
			 pair a,
			 pair b,
			 object obj,
			 pair ps)
{
  path x = shift(ps)*obj.g;
  path y = o -- (sml_setting.max_distance*unit(a));
  if(intersect(x,y).length > 1)
    return true;
  path z = o -- (sml_setting.max_distance*unit(b));
  if(intersect(x,z).length > 1)
    return true;  
  return false;
}
private void  put2corner(picture pic = currentpicture,
			 pair o,
			 pair a,
			 pair b,
			 object obj)
{
  pair c = ( min(obj) + max(obj) )/2;
  obj = shift(c)*obj;
  
  a = unit(a);
  b = unit(b);

  pair xdir = unit((a+b)/2);
  
  pair begin = o;
  pair end = o +  (sml_setting.max_distance*xdir);

  real mind = sml_setting.min_distance>0 ? sml_setting.min_distance: 1pt;
  
  if(!isintersect(o,a,b,obj,end)){
    while(length(end - begin)>mind){
      pair m = (begin + end)/2;
      if(isintersect(o,a,b,obj,m))
	begin = m;
      else
	end = m;
    }
  }
  add(pic,obj,end);
}


private pair find_pos(path o,path a,pair begin, pair end)
{
  path xpath = shift(end)*a;
  if(intersect(o,xpath).length > 1)
    return end;

  real mind = sml_setting.min_distance>0 ? sml_setting.min_distance: 1pt;

  while(length(end - begin) > mind){
    pair m = (begin + end)/2;
    xpath = shift(m)*a;
    if(intersect(o,xpath).length > 1)
      begin = m;
    else
      end =m;
  }
  return end;
}

private void  put2side(picture pic = currentpicture,
		       path g,
		       real t,
		       object obj)
{
  pair c = ( min(obj) + max(obj) )/2;
  obj = shift(c)*obj;

  pair begin = point(g,t);
  pair bdir = dir(g,t);
  pair ndir = unit(rotate(90)*bdir);

  pair endl = begin + sml_setting.max_distance * ndir;
  pair endr = begin - sml_setting.max_distance * ndir;
    
  pair leftp = find_pos(g,obj.g,begin,endl);
  //pair rightp = find_pos(g,obj.g,begin,endr);

  //pair xp = leftp;
  //if(length(leftp -bp) >length(rightp -bp))
  //xp = rightp;
  //add(pic,obj,xp);
  add(pic,obj,leftp);
}
