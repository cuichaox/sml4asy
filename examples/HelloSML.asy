import sml;

symbol a = mkactor("Programer");
symbol c = mkcase("Design In UML");
symbol c1 = mkcase("Code in asy");
symbol c2 = mkcase("Complie asy");

dock(0.3*AVG,MID,-45,a,c,hdock(c1,c2)).add();

(a--c).draw();
(c--c1).style(dep).ml("include").draw();
(c--c2).style(dep).ml("include").draw();
