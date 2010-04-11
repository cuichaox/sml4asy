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
  real high = 0.0;
  void fit(real h)
  {
    if(high < h)
      this.high = h;
  }
}

struct seqcol
{
  struct status
  {
    bool isactive = false;
    int actlevel = 0;    
    status clone()
    {
      status ret;
      ret.isactive = this.isactive;
      ret.actlevel = this.actlevel;
      return ret;
    }

    void inc(bool onleft)
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
    
    void dec()
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

    real offset(bool onleft)
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
  status sstack[] = new status[]{};
  bool keepact = false;
  real width;
  object head;

  void operator init(object head, bool keepact)
  {
    this.head = head;
    this.keepact = keepact;
    status sts = new status;    
    if(keepact){
      sts.isactive = true;
      sts.actlevel = 0;
    }
    this.sstack.push(sts);        
  }

  void pull2row(int row)
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

  real leftoffset()
  {
    return sstack[sstack.length -1].offset(true);    
  }
  
  real rightoffset()
  {
    return sstack[sstack.length -1].offset(false);    
  }  
  
  real actleft()
  {
    sstack[sstack.length -1].inc(true);
    return leftoffset();
  }
  
  real actright()
  {
    sstack[sstack.length -1].inc(false);
    return this.rightoffset();
  } 
}

struct seqmsg
{
  seqrow beginrow = null;
  seqrow endrow = null;
  // XX here  wait to hack 
    
    
}

struct seqrim
{
  
}

struct seqdia
{
  struct contex
  {
    
  }
}


void asymsg()
{
  
}

void synmsg()
{
  
}

seqcol newmsg()
{
  seqcol ret;
  return ret;
}

void retmsg()
{
  
}

void beginrim()
{
  
}

void sprim()
{
  
}

void endrim()
{
  
}

void endseq()
{
  
}
  
