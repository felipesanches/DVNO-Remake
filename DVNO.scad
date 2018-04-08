module black_bground(){
    translate([0,0,-100])
    color([0.1, 0.1, 0.1]) cube(center=true, [1000,1000,1]);
    
    for(i=[-1,1])
        for(j=[0,90])
            rotate([0,0,j])
    translate([i*500,0,0])
    rotate([0,90])
    color([0.1, 0.1, 0.1]) cube(center=true, [1000,1000,1]);
}

module ed_banger_scene(t){
    T1=1.0; //aproximacao lenta
    TR=0.7;
    function logo_zoom(t) = t < (T1) ? (1-t/(T1))*1000 : 0;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    rotate(logo_rotation(t))
    translate([0,0,logo_zoom(t)]){
        color([0.8, 0.7, 0, logo_opacity(t)])
        linear_extrude(height=20)
        import("Ed Banger records.dxf", layer="Ed");

        color([0.8, 0.2, 0, logo_opacity(t)])
        linear_extrude(height=20)
        import("Ed Banger records.dxf", layer="records");
    }
}


module justice_scene(t){
    T1=1.0; //aproximacao lenta
    TR=0.7;
    function logo_zoom(t) = t < (T1) ? (1-t/(T1))*1000 : 0;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    color([0.8, 0.7, 0.3, logo_opacity(t)])
    rotate(logo_rotation(t))
    translate([0,0,logo_zoom(t)])
        linear_extrude(height=5)
        import("Justice.dxf");
}

module DVNO_intro_logo_scene(t){
    T1=1.0; //aproximacao lenta
    TR=0.7;
    seed = 0;
    x=rands(-300,300,29,seed);
    y=rands(-300,300,29,seed);
    function layer_zoom(part, t) = t < T1 ? (1-t/T1)*1000 : 0;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    color([0.3, 0.2, 1, logo_opacity(t)])
    for(part=[1:29])
    translate([0,0, 40+layer_zoom(part, t)])
        rotate([(0.7-t)*x[part],(0.7-t)*y[part]])
        linear_extrude(height=6)
        import("DVNO_intro_logo.dxf", layer=str("part-",part));
}

module gold_logo(t, layer){
    T1=0.05; //aproximacao rapida
    TR=0.7;
    function layer_zoom(layer, t) = t < (layer*T1) ? (1-t/(layer*T1))*1000 : 0;
    function logo_rotation(t) = t < TR ? 0: (1-t/TR)*(1-t/TR) * 6000;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    color([0.8, 0.8, 0, logo_opacity(t)])
    rotate(logo_rotation(t))
    translate([0,0,layer_zoom(layer, t)])
        linear_extrude(height=20)
        import("Printed in gold.dxf", layer=str("layer-",layer));
}

module printed_in_gold(t){
    T1=0.10; //aproximacao rapida
    T2=0.50; //fadeout lento
    function text_zoom(t) = t < T1 ? (1-t/T1)*200 : 0;
    function text_opacity(t) = t < T2 ? 1 : 1-((t-T2)/(1-T2));
    color([0.8, 0.8, 0, text_opacity(t)])
    translate([0,0,text_zoom(t)])
    render()
    intersection(){
        linear_extrude(height=10)
        import("Printed in gold.dxf", layer="text");
    
        scale([1, 1, 0.5])
        translate([0,-74])
        rotate([0,90])
        cylinder(r=12, h=200, center=true);
    }
}

module printed_in_gold_scene(t){
    for (i=[1:6])
        gold_logo(t, layer=i);
    printed_in_gold(t);
}

module earth(){
    color([0.1,0.4,0.8])
    translate([0,0,-60])
    sphere(r=41, $fn=80);
}
    
module DVNO_globe_ending_scene(t){
    earth();

    color([0,1,1])
    DVNO_with_cuts(t);

    color([0,1,1,0.3])
    translate([0,-22])
    mirror([0,1,0])
    DVNO_with_cuts(t);
}

module DVNO_with_cuts(t){
    T1=1.0;
    function layer_zoom(part, t) = t < T1 ? (1-t/T1)*1000 : 0;
    render()
    difference(){
        linear_extrude(height=6)
        difference(){
            import("DVNO_globe_ending.dxf", layer="letters");
            import("DVNO_globe_ending.dxf", layer="cuts");
        }
        
        translate([0,-8,10])
        scale([1,1,0.6])
        rotate([0,90])
        cylinder(r=14,h=100, center=true);
    }
}



black_bground();
TOTAL = 15;
time = $t*TOTAL;

function within_range(t, start, end) = t > start && t < end;
function time_range(t, start, end) = (t-start)/(end-start);

if(within_range(time, 0, 3))
    ed_banger_scene(time_range(time, 0, 3));

if(within_range(time, 3, 5))
    justice_scene(time_range(time, 3, 5));

if(within_range(time, 5, 10))
    DVNO_intro_logo_scene(time_range(time, 5, 10));

if(within_range(time, 10, 15))
    printed_in_gold_scene(time_range(time, 10, 15));

//if(within_range(time, 0, 15))
//    DVNO_globe_ending_scene(time_range(time, 0, 15));