// Fragment Shader: shd_monitor_crt
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Variables que le pasaremos desde el objeto
uniform float u_time;

void main() {
    vec2 uv = v_vTexcoord;
    
    // 1. Efecto Curvatura (Viñeta Oscura en esquinas)
    vec2 center = uv - 0.5;
    float dist = length(center);
    float vignette = 1.0 - smoothstep(0.4, 0.95, dist * 1.5);
    
    // 2. Scanlines (Líneas horizontales)
    // El 600.0 define cuántas líneas hay.
    float scanline = sin(uv.y * 600.0 + u_time * 5.0) * 0.04; 
    
    // 3. Color Base
    vec4 base_color = texture2D(gm_BaseTexture, uv);
    
    // 4. Mezclar todo
    // Oscurecemos las scanlines y aplicamos la viñeta
    gl_FragColor = base_color * v_vColour;
    gl_FragColor.rgb -= scanline;      // Restar brillo en las líneas
    gl_FragColor.rgb *= vignette;      // Oscurecer bordes
}