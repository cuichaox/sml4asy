/**
 *sml_seq.asy  a modulor to draw sequence diagram.
 *  by cuichaox@gmail.com
 */

struct T_SEQ_SETTING
{
  real min_xmatric = 8bp;
  real min_ymatric = 8bp;
  real act_width = 6bp;
}
T_SEQ_SETTING seq_setting;

struct seqrow
{
  restricted real high = seq_setting.min_xmatric;
  private real pos = 0.0;
  private bool placed = false;
  restricted int n;

  void  operator init(int n)
  {
    this.n = n;
  }
    
  restricted void fit(real h)
  {
    if(high < h)
      this.high = h;
  }

  restricted void place(real pos)
  {
    if(this.placed)
      abort("Error: This row already placed.");
    this.pos = pos;
    this.placed = true;
  }

  void move2next()
  {
    ++this.n;
  }

  real getpos()
  {
    if(!this.placed){
      abort("Error: This row is not placed.");
    }
    return this.pos;
  }
}

struct seqcol
{
  private struct status
  {
    restricted bool isactive = false;
    restricted int actlevel = 0;

    restricted void operator init(bool isactive, int actlevel)
    {
      this.isactive = isactive;
      this.actlevel = actlevel;
    }
    
    restricted status clone()
    {
      status ret;
      ret.isactive = this.isactive;
      ret.actlevel = this.actlevel;
      return ret;
    }

    restricted void inc(bool onleft)
    {
      if(! this.isactive){
	this.isactive = true;
	this.actlevel = 0;
	return;
      }
      if(this.actlevel >0){
	++this.actlevel;
      } else if( this.actlevel < 0 ){
	--this.actlevel;
      } else if( this.actlevel == 0){
	this.actlevel = onleft? -1: 1;
      } else{
	abort("Error: invarint is broken this.actlevel < 0");
      }      
    }
    
    restricted void dec()
    {
      if( !this.isactive )
	  abort("Error: Can not decrease on inactive status.");
      if(this.actlevel > 0){
	  --this.actlevel;
      } else if( this.actlevel < 0){
	  ++this.actlevel;
      } else if( this.actlevel == 0){
	  this.isactive = false;
      } else{
	abort("Error: invarint is broken this.actleve <0");
      }	
    }

    restricted real offset(bool onleft)
    {
      if( !this.isactive){
	  return 0.0;
      }
      int nlevel = this.actlevel;
      if(onleft){
	  --nlevel;
      }else{
	  ++nlevel;
      }
      return  seq_setting.act_width*nlevel;           
    }
  }
  restricted status sstack[] = new status[]{};
  restricted bool keepact = false;
  restricted real width = seq_setting. min_ymatric;
  restricted object head;
  restricted int n;
  restricted void fit(real w)
  {
    if(this.width < w)
      this.width = w;
    return;
    
  }

  restricted void operator init(object head, bool keepact, int n)
  {
    this.n = n;
    this.head = head;
    this.keepact = keepact;
    status sts = null;    
    if(keepact){
      sts = status(true,0);     
    } else{
      sts = status(false,0);
    }      
    this.sstack.push(sts);        
  }

  restricted void pull2row(int row)
  {
    int n = this.sstack.length;
    if( n >= row)
      return;
    if( n < 1)
      abort("Error: UnInitilize status.");
    for(int i=n; i<row; ++i){      
      status sts = sstack[n-1].clone();
      sstack.push(sts);
    }	
  }

  restricted real leftoffset(int n)
  {
    return sstack[n].offset(true);    
  }
  
  restricted real rightoffset(int n)
  {
    return sstack[n].offset(false);    
  }  
  
  restricted real actleft(int n)
  {
    if(n <sstack.length -1)
      abort("Error: act on middle.");
    this.pull2row(n);	
    sstack[n].inc(true);
    return leftoffset(n);
  }
  
  restricted real actright(int n)
  {
    if(n <sstack.length -1)
      abort("Error: act on middle.");
    this.pull2row(n);
    sstack[n].inc(false);
    return this.rightoffset(n);
  }

  private real pos = 0.0;
  private bool placed = false;

  void place(real pos)
  {
    if(placed)
      abort("Error: This collumn is already placed.");
    this.placed = true;
    this.pos = pos;
  }

  real getpos()
  {
    if(!placed){
      abort("Error: This collum is not placed.");
    }
    return this.pos;
  }
}


struct seqmsg
{
  //begin  message type enum
  static restricted int ASY = 1;
  static restricted int SYS = 2;
  static restricted int RET = 3; 
  //end message type enum
  
  restricted int type = SYS; 
  restricted seqrow beginrow = null;
  restricted seqrow endrow = null;
  restricted seqcol begincol = null;
  restricted seqcol endcol = null;
  restricted object name =null;  
  restricted real beginoffset = 0.0;
  restricted real endoffset = 0.0;
  
  restricted string label = "";
    
  restricted void operator init(int type,
                                seqrow beginrow,
                                seqrow endrow,
                                seqcol begincol,
                                seqcol endcol,
                                object name,
                                real beginoffset,
                                real endoffset)
  {
    this.type = type;
    this.beginrow = beginrow;
    this.endrow = endrow;
    this.begincol = begincol;
    this.endcol = endcol;
    this.name = name;
    this.beginoffset = beginoffset;
    this.endoffset =  endoffset;
  }    
    
}

struct seqrim
{    
  restricted seqrow beginrow = null;
  restricted seqrow endrow = null;
  restricted seqcol begincol = null;
  restricted seqcol endcol = null;
  restricted string name;
  restricted string beginlabel;

  restricted seqrow[] sprow = new seqrow[]{};
  restricted string[] splabel = new string[]{};
  
  restricted bool pending()
  {
    if(endrow == null)
      return true;
    else
      return false;
  }
  
  restricted void operator init(seqrow beginrow,
				seqcol begincol,
				string name ,
				string beginlabel)
  {
    this.beginrow = beginrow;
    this.begincol = begincol;
    this.endcol = begincol;
    this.name = name;
    this.beginlabel = beginlabel;
  }

  restricted void spline(seqrow row,
			 string label)
  {
    if(!alias(this.endrow,null))
      abort("Error: this rim is alreay closed");    
    this.sprow.push(row);
    this.splabel.push(label);
  }

  restricted void end(seqrow row)
  {
    if(!alias(this.endrow,null))
      abort("Error: this rim is alreay closed");
    this.endrow = row;
  }
 
}

struct seqdia
{
  struct contex
  {
    public seqcol[] calstack = new seqcol[]{};
    public seqrim[] rimstack = new seqrim[]{};
    public seqrow currow = null;

    restricted seqcol ctop()
    {
      if(this.calstack.length == 0){
	abort("Error: call stack is empty.");
      }	
      return this.calstack[this.calstack.length -1];
    }
    restricted seqcol cpop()
    {
      if(this.calstack.length == 0){
	abort("Error: call stack underfllow");
      }
      return this.calstack.pop();
    }           
    restricted seqrim rtop()
    {
      if(this.rimstack.length == 0){
	abort("Error: rim stack is empty.");
      }
      return this.rimstack[this.rimstack.length -1];      
    }
    restricted seqrim rpop()
    {
      if(this.rimstack.length == 0){
	abort("Error rim stack unserfllow.");
      }
      return this.rimstack.pop();      
    }       
  };
  public contex ctx = new contex;
  public seqrow[] rows = new seqrow[]{};
  public seqcol[] cols = new seqcol[]{};
  restricted void fit(seqcol bcol, seqcol ecol,real w)
  {
    seqcol col1 = bcol;
    seqcol col2 = ecol;
    if(bcol.n > ecol.n){
      col1 = ecol;
      col2 = bcol;
    }else if(bcol.n == ecol.n){
      bcol.fit(w);
      return;
    }
    real tw =0.0;
    for( int i = bcol.n; i<ecol.n; ++i){
      tw += this.cols[i].width;
    }
    if(tw < w){
      return;
    }
    real lw = (tw-w)+col1.width;
    col1.fit(lw);      
  }
  public seqrim[] rims = new seqrim[]{};
  public seqmsg[] msgs = new seqmsg[]{};

  restricted bool autoret;
  restricted void operator init(bool autoret)
  {
    this.autoret = autoret;
  }

  restricted seqrow appendrow()
  {
    int n = this.rows.length;
    seqrow ret = seqrow(n);
    this.rows.push(ret);
    return ret;
  }
   
  restricted seqrow nextrow()
  {
    if(this.ctx.currow.n < this.rows.length -1){
      return this.rows[this.ctx.currow.n +1];
    }
    else if(this.ctx.currow.n == (this.rows.length -1)){
      seqrow ret = seqrow(this.ctx.currow.n +1);
      this.rows.push(ret);
      this.ctx.currow = ret;
      return ret;
    }
    abort("Error: current row is out of range.");
    return null;
  }
  
}

private seqdia curdia = null;

restricted void begindia(bool autoret = true)
{
  curdia = seqdia(autoret);
}

private void assert_begin(string who)
{
  if(alias(curdia,null)){
    abort("Error: ["+who+"] Call begindia first, please.");    
  }   
}


restricted void enddia()
{
  assert_begin("enddia");
  // wait to hack  
}

restricted void pushcol(object head,bool keepact)
{
  assert_begin("pushcol");
  int n = curdia.cols.length;
  seqcol newcol = seqcol(head,keepact,n);
  curdia.cols.push(newcol);
  
}

restricted void retmsg(string label = "",
		       bool draw = true,
		       real during = 0.0)
{
  assert_begin("retmsg");
  if(curdia.ctx.calstack.length < 2){
    abort("Error: can't retrun. Call stack underflow.");
  }
  
  if(curdia.rows.length < 1){
    abort("Error: can't retrun on zero row.");
  }
  seqcol bcol = curdia.ctx.cpop();
  seqcol ecol = curdia.ctx.ctop();

  seqrow prow = curdia.ctx.currow;
  seqrow brow = curdia.nextrow();
  seqrow erow = brow;
  prow.fit(during);
  if(during != 0.0 || alias(bcol,ecol)){
    erow = curdia.nextrow();    
  }

  object lab = null;
  if(draw && length(label) > 0){
    lab = object(label);
    pair t = max(lab) - min(lab);
    curdia.fit(bcol,ecol,t.x);
    prow.fit(during + t.y);
  }
  bcol.pull2row(brow.n);
  bcol.sstack[brow.n].dec();
  ecol.pull2row(erow.n);

  if(!draw)
    return;
     
  real boff = 0.0;  
  real eoff = 0.0;
  if(bcol.n < ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.leftoffset(erow.n);
  }else if(bcol.n == ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.rightoffset(erow.n);
  }else{
    boff = bcol.leftoffset(brow.n);
    eoff = ecol.rightoffset(erow.n);
  }  
  
  seqmsg msg = seqmsg(seqmsg.RET,
		      brow,
		      erow,
		      bcol,
		      ecol,
		      lab,
		      boff,
		      eoff);
  curdia.msgs.push(msg);
}

restricted  void asymsg(string name = "",
			seqcol bcol,
			seqcol ecol,
			real during = 0.0,
			bool nextrow = true)
{
  assert_begin("asymsg");
 
  while(curdia.ctx.calstack.length >=1
	&& !alias(bcol,curdia.ctx.ctop())){
    retmsg(curdia.autoret);    
  } 

  object xname = object(name);
  pair xs = max(xname) - min(xname);
  curdia.fit(bcol,ecol,xs.x);
  
  seqrow brow = curdia.ctx.currow;
  brow.fit(xs.y);
  if(nextrow){
    brow = curdia.nextrow();
  }
  seqrow erow = brow;
  if(during > 0.0){
    erow = curdia.nextrow();
    brow.fit(brow.high + during);
  }
  bcol.pull2row(brow.n);  
  ecol.pull2row(erow.n);

  real boff = 0.0;
  real eoff = 0.0;
  if(bcol.n < ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.leftoffset(erow.n);
  }else if(bcol.n == ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.rightoffset(erow.n);
  }else{
    boff = bcol.leftoffset(brow.n);
    eoff = ecol.rightoffset(erow.n);
  }
  seqmsg msg = seqmsg(seqmsg.ASY,
		      brow,
		      erow,
		      bcol,
		      ecol,
		      xname,
		      boff,
		      eoff);
  curdia.msgs.push(msg);  
}

restricted void synmsg(string name = "",
		       seqcol bcol,
		       seqcol ecol,
		       real during =0.0)
{
  assert_begin("synmsg");
  if(curdia.ctx.calstack.length ==0){
    curdia.ctx.calstack.push(bcol);
  }    
  while(curdia.ctx.calstack.length >=1
	&& !alias(bcol,curdia.ctx.ctop())){
    retmsg(curdia.autoret);    
  }
  if((curdia.ctx.calstack.length ==0)){
    abort("Error: the begin col is not on stack: "+ name);
  }
  curdia.ctx.calstack.push(ecol);
    
  object xname = object(name);
  pair xs = max(xname) - min(xname);
  curdia.fit(bcol,ecol,xs.x);
  curdia.ctx.currow.fit(xs.y);

  seqrow brow = curdia.nextrow();
  seqrow erow = brow;
  if(during >0.0){
    erow = curdia.nextrow();
    brow.fit(brow.high + during);
  }
  
  bcol.pull2row(brow.n);  
  ecol.pull2row(erow.n);
  real boff = 0.0;
  real eoff = 0.0;
  if(bcol.n < ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.actleft(erow.n);
  }else if(bcol.n == ecol.n){
    boff = bcol.rightoffset(brow.n);
    eoff = ecol.actright(erow.n);
  }else{
    boff = bcol.leftoffset(brow.n);
    eoff = ecol.actright(erow.n);
  }

  seqmsg msg = seqmsg(seqmsg.SYS,
		      brow,
		      erow,
		      bcol,
		      ecol,
		      xname,
		      boff,
		      eoff);
  curdia.msgs.push(msg);    
}

restricted seqcol newmsg(string name,
			 string head,
			 bool keepact)
{
  assert_begin("newmsg");
  // wait to hack
  seqcol ret;
  return ret;
}

 
restricted void beginrim()
{
  assert_begin("beginrim");
  
}

restricted void sprim()
{
  assert_begin("sprim");
  
}

restricted void endrim()
{
  assert_begin("endrim");
  
}

restricted void endseq()
{
  assert_begin("endseq");
  
}
  
