import sml;

symbol data = mkclass(mkcname("Record","type"));
symbol dh = mkclass(mkcname("DataHandler","interface",true),
		   blank,
		   mkopers("+PushData(fd:Record)"));
symbol sdh = mkclass("StoreHandler");
symbol chd = mkclass("CheckingHandler");
symbol comdh = mkclass(mkcname("CompositeHandler"),
		       "-hdset: DataHandler[]",
		        mkopers("+PushData(fd:Record)"));
symbol sdh1 =  mkclass("DataBaseImp");
symbol sdh2 =  mkclass("CsvFileImp");


vdock(1.5*AVG,
      LEFT,
      hdock(1.2*AVG,MID,data,dh),
      hdock(0.3*AVG,space*1cm,sdh,chd,comdh),
      hdock(0.2AVG,sdh1,sdh2)).add();

(dh--data).style(dep).ml("use").draw();
(dh--pyw(-2cm)--hv--(new symbol[]{sdh,chd,comdh})).style(rea).draw();
(sdh--pyw(-2cm)--hv--(new symbol[]{sdh1,sdh2})).style(gen).draw();
(comdh--pxw(1cm)--vh--dh).style(com).sl("1").dl("*").draw();


