$fn=20;

/******     Parameter lijst     ******/
/*************************************/
//Afmetingen doos
lengte = 120;
breedte = 80;
hoogte = 30;
dikte = 2;

//Fillet waarde
//De Fillet waarde zal voor kleine waarden scherpe hoeken geven
//en voor grote waarden ronde hoeken. Het bereik ligt tussen 0,1 en 12.
fillet = 0.1;

//Ventilatiegaten
ventilatiegatenBoven = 1;
ventilatiegatenOnder = 8;




//Deze module zal een balk produceren en afhankelijk van de fillet waarde
//zullen de hoeken minder of meer afgerond zijn.
module ronding($a=lengte, $b=breedte, $c=hoogte) {
    translate([0,fillet, fillet]){
        minkowski() {
            cube([$a-(lengte/2), $b-(2*fillet), $c-(2*fillet)], center = false);
            rotate([0,90,0]) {
                cylinder(r=fillet, h=lengte/2, center = false);
            }
        }
    }
}

//Deze module zal de elementaire behuizing produceren zonder ventilatiegaten, pootjes, ...
module doos() {
    //De 0.000001 is toegevoegd om de bug in OpenSCAD te elimineren
    dikte = dikte*2+0.000001;
    difference() {
        difference() {
            union(){
                //Het uithollen van de doos
                difference(){
                    ronding();
                    translate([dikte/2, dikte/2, dikte/2]) {
                        ronding($a=lengte-dikte, $b=breedte-dikte, $c=hoogte-dikte);
                    }
                }
            }
         //Het afsnijden van de top opdat enkel de randen overblijven
         translate([-dikte, -dikte, hoogte/2]){
             cube([lengte+dikte, breedte+dikte, hoogte], center=false);
         }
     }
 }
 }

 module bevestiging() {
     dikte = dikte*2;
     difference() {
     union() {
         translate([3*dikte + 5, dikte, hoogte/2]) {
             rotate([90,0,0]){
                 
             cylinder(d=16, dikte/2);
             }
         }

         translate([lengte-((3*dikte) + 5), dikte, hoogte/2]) {
             rotate([90,0,0]){
             cylinder(d=16, dikte/2);
             }
         }
     }

         translate([4,dikte+fillet, hoogte/2-57]){
             rotate([45,0,0]){
             cube([lengte, 40, 40]);
             }
         }

         translate([0,-(dikte*1.46), hoogte/2]){
             cube([lengte, dikte*2, 10]);
             }
         }
     }

module gaten() {
    dikte = dikte*2;
     union() {

                translate([3*dikte+5,20,hoogte/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([lengte-((3*dikte)+5),20,hoogte/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([3*dikte+5,breedte+5,hoogte/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([lengte-((3*dikte)+5),breedte+5,hoogte/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
            }
        }




 module ventilatiegaten(top) {
     afmeting = dikte*2;

     union() {
         if(top == 1) {
             for(i=[0:dikte:lengte/4]){
             translate([10+i,0,1]){
                    cube([ventilatiegatenBoven,afmeting,hoogte/4]);
                    }
                    translate([(lengte-10) - i,0,1]){
                    cube([ventilatiegatenBoven,afmeting,hoogte/4]);
                    }
                    translate([(lengte-10) - i,breedte-afmeting,1]){
                    cube([ventilatiegatenBoven,afmeting,hoogte/4]);
                    }
                    translate([10+i,breedte-afmeting,1]){
                    cube([ventilatiegatenBoven,afmeting,hoogte/4]);
                    }
                }

     }

     if(top == 0) {

         for(i=[0:dikte:lengte/4]){
             translate([10+i,0,1]){
                    cube([ventilatiegatenOnder,afmeting,hoogte/4]);
                    }
                    translate([(lengte-10) - i,0,1]){
                    cube([ventilatiegatenOnder,afmeting,hoogte/4]);
                    }
                    translate([(lengte-10) - i,breedte-afmeting,1]){
                    cube([ventilatiegatenOnder,afmeting,hoogte/4]);
                    }
                    translate([10+i,breedte-afmeting,1]){
                    cube([ventilatiegatenOnder,afmeting,hoogte/4]);
                    }
                }

     }
 }









}

//ronding();
//doos();
//ventilatiegaten(0);

//bevestiging();

difference() {
    difference() {
        union() {
            doos();
            bevestiging();


        }

    }
    gaten();
    ventilatiegaten(0);
}


  //doos();
  //bevestiging();
//doos();
//bevestiging();
