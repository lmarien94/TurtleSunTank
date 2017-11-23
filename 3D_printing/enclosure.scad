$fn=100;

difference() {
    minkowski(){
        cube([60,50,10], center = true);
        sphere(2);
        }
        
    //Top eraf
    translate([0,0,5]) cube([58,48,8], center = true);
        
    translate([0,0,5]){
        linear_extrude(10){
            minkowski(){
                square([59,49], center = true);
                circle(1);
                }
            }
        }
       
     //Uithollen van de binnenkant
     translate([0,0,0]);
     minkowski(){
         cube([58,48,8], center = true);
         sphere(1);
         }   
}