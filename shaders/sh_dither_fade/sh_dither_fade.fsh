// sh_dither_fade.fsh
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_alpha;
uniform float u_pixel_size; // 1.0 = normal, 2.0 = double size, 4.0 = huge pixels, etc.

void main()
{
    // Divide screen coordinates by pixel size and floor it to create "blocks"
    vec2 pos = floor(gl_FragCoord.xy / u_pixel_size);
    
    int x = int(mod(pos.x, 4.0));
    int y = int(mod(pos.y, 4.0));
    
    float threshold = 0.0;
    
    if (y == 0) {
        if (x == 0) threshold = 0.0625;
        else if (x == 1) threshold = 0.5625;
        else if (x == 2) threshold = 0.1875;
        else if (x == 3) threshold = 0.6875;
    } else if (y == 1) {
        if (x == 0) threshold = 0.8125;
        else if (x == 1) threshold = 0.3125;
        else if (x == 2) threshold = 0.9375;
        else if (x == 3) threshold = 0.4375;
    } else if (y == 2) {
        if (x == 0) threshold = 0.2500;
        else if (x == 1) threshold = 0.7500;
        else if (x == 2) threshold = 0.1250;
        else if (x == 3) threshold = 0.6250;
    } else if (y == 3) {
        if (x == 0) threshold = 1.0000;
        else if (x == 1) threshold = 0.5000;
        else if (x == 2) threshold = 0.8750;
        else if (x == 3) threshold = 0.3750;
    }

    if (u_alpha < threshold) {
        discard;
    }

    gl_FragColor = v_vColour;
}