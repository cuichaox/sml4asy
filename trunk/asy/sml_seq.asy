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
  restricted real high = 0.0;
  restricted void fit(real h)
  {
    if(high < h)
      this.high = h;
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
  restricted real width;
  restricted object head;

  restricted void operator init(object head, bool keepact)
  {
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

  restricted real leftoffset()
  {
    return sstack[sstack.length -1].offset(true);    
  }
  
  restricted real rightoffset()
  {
    return sstack[sstack.length -1].offset(false);    
  }  
  
  restricted real actleft()
  {
    sstack[sstack.length -1].inc(true);
    return leftoffset();
  }
  
  restricted real actright()
  {
    sstack[sstack.length -1].inc(false);
    return this.rightoffset();
  } 
}

struct seqmsg
{
  //begin  message type enum
  static restricted int ASY = 1;
  static restricted int SYS = 2;
  static restricted int RET = 3; 
  //end message type enum
  
  restricted seqrow beginrow = null;
  restricted seqrow endrow = null;
  restricted seqcol begincol = null;
  restricted seqcol endcol = null;
  restricted string label ="";
  int type = 0; 
  
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
  
