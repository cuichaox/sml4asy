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
