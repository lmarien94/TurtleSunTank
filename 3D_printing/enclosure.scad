$fn=100;

//Parameter lijst, wordt later nog in een afzonderlijk bestand gestoken.
xSizeReal = 55;
ySizeReal = 60;
zSizeReal = 10;

xAdjustedSize1 = 54;
yAdjustedSize1 = 59;
zAdjustedSize1 = 9;

xAdjustedSize2 = 53;
yAdjustedSize2 = 59;
zAdjustedSize2 = 8;

radiusCircle = 1;
radiusSphere = 2;


//Functie voor de doos
difference() {
    //Gebruikmakend van de minskowski functie om zo makkelijk rondingen te creëren
    minkowski(){
        cube([xSizeReal,ySizeReal,zSizeReal], center = true);
        sphere(radiusSphere);
        }
        
    //Top eraf 
    translate([0,0,5]) cube([xAdjustedSize2,yAdjustedSize2,zAdjustedSize2], center = true);
        
    translate([0,0,5]){
        linear_extrude(10){
            minkowski(){
                square([xAdjustedSize1,yAdjustedSize1], center = true);
                circle(radiusCircle);
                }
            }
        }
       
     //Uithollen van de binnenkant
     translate([0,0,0]);
     minkowski(){
         cube([xAdjustedSize2,yAdjustedSize,zAdjustedSize2], center = true);
         sphere(1);
         }   
}



