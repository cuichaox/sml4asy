# Objective #
Quikly drawing UML in Asympote -A powerful descriptive vector graphics language.

# Demo #
## Use Case to use it ##
### Source code ###
```
import sml;

symbol a = mkactor("Programer");
symbol c = mkcase("Design In UML");
symbol c1 = mkcase("Code in asy");
symbol c2 = mkcase("Complie asy");

dock(0.3*AVG,MID,-45,a,c,hdock(c1,c2)).add();

(a--c).draw();
(c--c1).style(dep).ml("include").draw();
(c--c2).style(dep).ml("include").draw();
```
### Result Image ###
![http://blogimg.chinaunix.net/blog/upfile2/100411081456.jpg](http://blogimg.chinaunix.net/blog/upfile2/100411081456.jpg)

## A Class Digram of Composite Pattern ##
### Source code ###
```
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
symbol sdh1 = mkclass("DataBaseImp");
symbol sdh2 = mkclass("CsvFileImp");


vdock(1.5*AVG,
      LEFT,
      hdock(1.2*AVG,MID,data,dh),
      hdock(0.3*AVG,space*1cm,sdh,chd,comdh),
      hdock(0.2AVG,sdh1,sdh2)).add();

(dh--data).style(dep).ml("use").draw();
(dh--pyw(-2cm)--hv--(new symbol[]{sdh,chd,comdh})).style(rea).draw();
(sdh--pyw(-2cm)--hv--(new symbol[]{sdh1,sdh2})).style(gen).draw();
(comdh--pxw(1cm)--vh--dh).style(com).sl("1").dl("*").draw();

```
### Result Image ###
![http://blogimg.chinaunix.net/blog/upfile2/100411081907.jpg](http://blogimg.chinaunix.net/blog/upfile2/100411081907.jpg)

## A Wrap Package Diagram ##
### Source code ###
```
import sml;

symbol ld = mkpack(hdock(4bp,
                         mkbox("plead"),
                         mkbox("mlead"),
                         mkbox("nlead")),"lead");

symbol ln = mknote("A smart way to specify line between symbols, "
                   "I like this ideal");

symbol paks= mkpack(hdock(4bp,TOE,
                           mkpack(mkpack("actor"),
                                  "symbol"),
                           ld,
                           mkpack("utility")),
                     "sml");

vdock(0.5*AVG,RIGHT,ln,paks).add();

(ln--ld).style(dashline).draw();
```
### Result Image ###
![http://blogimg.chinaunix.net/blog/upfile2/100411082321.jpg](http://blogimg.chinaunix.net/blog/upfile2/100411082321.jpg)
## A Componet Digram ##
### Source code ###
```
import sml;

symbol scheduler = mkcom(":Scheduler");
symbol im = mkiball("MakeReservations",E);
symbol planner = mkcom(":Planner");
symbol ip =mkiball("UpdatePlans",N);
symbol gui = mkcom(":TripGUI");

vdock(LEFT,hdock(MID,scheduler,im),
      hdock(MID,space*1.5cm,planner,ip,gui)).add();

(scheduler--im).draw();
(planner--hv--im).style(req_i).draw();
(planner--ip).draw();
(gui--ip).style(req_i).draw();
```
### Result Image ###
![http://blogimg.chinaunix.net/blog/upfile2/100411082732.jpg](http://blogimg.chinaunix.net/blog/upfile2/100411082732.jpg)
