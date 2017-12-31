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
ventilatiegatenSpacingBoven = 1;
ventilatiegatenSpacingOnder = 8;
//Zorgen dat de ventilatiegaten door de behuizing komen
ventilatiegatenDikte = dikte*2;
//De lengte van de ventilatiegaten
ventilatiegatenLengte = dikte*2;

//Bevestiging
bevestigingDiameterCilinder = 16;
//0.8 om te vermenigvulden met een integer om zo de correcte 
//M-waarde van een schroef te krijgen
schroefgatendiameterCilinder = 0.8;






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

//Deze module zal de bevestiging produceren welke op de behuizing gezet wordt
 module bevestiging() {
     dikte = dikte*2;
     difference() {
         //hier worden 2 cilindervomige bevestigingen gemaakt
         union() {
             translate([3*dikte + 5, dikte, hoogte/2]) {
                 rotate([90,0,0]){
                 cylinder(d=bevestigingDiameterCilinder, dikte/2);
                 }
             }
             translate([lengte-((3*dikte) + 5), dikte, hoogte/2]) {
                 rotate([90,0,0]){
                 cylinder(d=bevestigingDiameterCilinder, dikte/2);
                 }
             }
         }
         //Snij de onderkant eraf met een hoek van 45°
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

//Deze module produceert gaten afhankelijk van de M-variant de gebruiker wilt
// Voor M3 geef een parameter 3 mee, voor M4 een parameter 4, enz. enz.
module gaten(M) {
    dikte = dikte*2;
    union() {
        translate([3*dikte+5,20,hoogte/2+4]){
            rotate([90,0,0]){
            cylinder(d=schroefgatendiameterCilinder*M,20);
            }
        }
        translate([lengte-((3*dikte)+5),20,hoogte/2+4]){
            rotate([90,0,0]){
            cylinder(d=schroefgatendiameterCilinder*M,20);
                    }
                }
        translate([3*dikte+5,breedte+5,hoogte/2-4]){
            rotate([90,0,0]){
            cylinder(d=schroefgatendiameterCilinder*M,20);
            }
        }
        translate([lengte-((3*dikte)+5),breedte+5,hoogte/2-4]){
            rotate([90,0,0]){
                cylinder(d=schroefgatendiameterCilinder*M,20);
            }
        }
    }
}

//Deze module produceert ventilatiegaten en krijgt een parameter mee of het de 
//bovenkant of onderkant is (verschillende ventilatiegaten worden geproduceerd
//afhankelijk hiervan).
 module ventilatiegaten(top) {
     union() {
         //Indien het om de bovenkant gaat
         if(top == 1) {
             for(i=[0:dikte:lengte/4]){
                 translate([10+i,-ventilatiegatenDikte+ventilatiegatenLengte,1]){
                    cube([ventilatiegatenSpacingBoven,ventilatiegatenDikte,hoogte/4]);
                 }
                 translate([(lengte-10) - i,-ventilatiegatenDikte+ventilatiegatenLengte,1]){
                    cube([ventilatiegatenSpacingBoven,ventilatiegatenDikte,hoogte/4]);
                 }
                 translate([(lengte-10) - i,breedte-ventilatiegatenLengte,1]){
                    cube([ventilatiegatenSpacingBoven,ventilatiegatenDikte,hoogte/4]);
                 }
                 translate([10+i,breedte-ventilatiegatenLengte,1]){
                    cube([ventilatiegatenSpacingBoven,ventilatiegatenDikte,hoogte/4]);
                 }
             }
         }

     if(top == 0) {
         for(i=[0:dikte:lengte/4]){
             translate([10+i,-ventilatiegatenDikte+ventilatiegatenLengte,1]){
                 cube([ventilatiegatenSpacingOnder,ventilatiegatenDikte,hoogte/4]);
             }
             translate([(lengte-10) - i,-ventilatiegatenDikte+ventilatiegatenLengte,1]){
                 cube([ventilatiegatenSpacingOnder,ventilatiegatenDikte,hoogte/4]);
             }
             translate([(lengte-10) - i,breedte-ventilatiegatenLengte,1]){
                 cube([ventilatiegatenSpacingOnder,ventilatiegatenDikte,hoogte/4]);
             }
             translate([10+i,breedte-ventilatiegatenLengte,1]){
                 cube([ventilatiegatenSpacingOnder,ventilatiegatenDikte,hoogte/4]);
             }
         }
     }
 }
 }

//doos();
//bevestiging();
//gaten();
//ventilatie();

/******     Onderkant     ******/
//Het verschil nemen tussen de doos met bevestigingen en de
//ventilatiegaten en bevestigingsgaten.
difference() {
        //Samenvoegen van de doos met de bevestiging.
        union() {
            doos();
            bevestiging();
        }
    gaten(3);
    ventilatiegaten(0);
}

/******     Bovenkant     ******/
translate([0,breedte, hoogte+10]){
    rotate([0,180,180], center = true) {
        difference() {
            union() {
                doos();
                bevestiging();
            }
            gaten(3);
            ventilatiegaten(1);
        }
    }
}


