import sml;

symbol ld = mkpack(hdock(4bp,
			 mkbox("plead"),
			 mkbox("mlead"),
			 mkbox("nlead")),"lead");

symbol ln = mknote("A smart way to specify line between symbols, "
		   "I like this idea");

symbol paks=  mkpack(hdock(4bp,TOE,
			   mkpack(mkpack("actor"),
				  "symbol"),
			   ld,
			   mkpack("utility")),
		     "sml");

vdock(0.5*AVG,RIGHT,ln,paks).add();

(ln--ld).style(dashline).draw();




