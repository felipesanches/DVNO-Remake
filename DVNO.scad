module black_bground(){
    color([0.1, 0.1, 0.1]) cube(center=true, [1000,1000,1]);
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
        linear_extrude(height=3)
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


module ed_banger_scene(t){
    T1=1.0; //aproximacao lenta
    TR=0.7;
    function logo_zoom(t) = t < (T1) ? (1-t/(T1))*1000 : 0;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    color([0.8, 0.8, 0, logo_opacity(t)])
    rotate(logo_rotation(t))
    translate([0,0,logo_zoom(t)])
        linear_extrude(height=3)
        import("Ed Banger records.dxf");
}


module justice_scene(t){
    T1=1.0; //aproximacao lenta
    TR=0.7;
    function logo_zoom(t) = t < (T1) ? (1-t/(T1))*1000 : 0;
    function logo_opacity(t) = t < TR ? 1 : 1-((t-TR)/(1-TR));
    color([0.8, 0.8, 0, logo_opacity(t)])
    rotate(logo_rotation(t))
    translate([0,0,logo_zoom(t)])
        linear_extrude(height=3)
        import("Justice.dxf");
}


black_bground();
TOTAL = 10;
time = $t*TOTAL;

function within_range(t, start, end) = t > start && t < end;
function time_range(t, start, end) = (t-start)/(end-start);

if(within_range(time, 0, 3))
    ed_banger_scene(time_range(time, 0, 3));

if(within_range(time, 3, 5))
    justice_scene(time_range(time, 3, 5));

if(within_range(time, 6, 10))
    printed_in_gold_scene(time_range(time, 6, 10));
