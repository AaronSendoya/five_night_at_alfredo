varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform vec2 u_resolution;

float noise(vec2 coord) {
    return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 baseColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);

    // 1. SCANLINES MÁS FUERTES
    // Antes era * 0.1, ahora * 0.3 para que las líneas negras sean más oscuras
    float scanline = sin(v_vTexcoord.y * u_resolution.y * 2.0) * 0.25 + 0.75;

    // 2. RUIDO (ESTÁTICA) MUCHO MÁS NOTORIO
    // Subimos de 0.15 a 0.4. ¡Mucha nieve!
    float grain = noise(v_vTexcoord * u_time) * 0.4;

    // 3. COLOR MÁS DISTORSIONADO (Verde Fantasma)
    vec3 finalColor = baseColor.rgb * scanline + grain;
    finalColor.r *= 0.8; // Bajamos el rojo
    finalColor.g *= 1.2; // Subimos el verde
    finalColor.b *= 1.3; // Subimos el azul

    // 4. NUEVO: VIÑETA (Bordes Oscuros)
    // Esto oscurece las esquinas como un monitor de tubo viejo
    float dist = distance(v_vTexcoord, vec2(0.5, 0.5));
    float vignette = smoothstep(0.8, 0.2, dist * 1.2);
    finalColor *= vignette;

    gl_FragColor = vec4(finalColor, baseColor.a);
}