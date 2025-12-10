/// @description Parpadeo AGRESIVO

// 1. Probabilidad de fallo mucho más alta (30% de cada frame)
if (random(100) > 70) {
    
    // 2. EL CAMBIO CLAVE: "choose" en lugar de "random_range"
    // "random_range" elige números suaves (0.4, 0.41, 0.42...)
    // "choose" da saltos bruscos. Aquí elegimos entre oscuridad fuerte o TOTAL.
    
    alpha = choose(0.8, 0.9, 1.0); // 1.0 es negro absoluto
    
} else {
    
    // 3. "La falsa calma":
    // A veces, incluso cuando hay luz, le damos un toquecito de suciedad (0.1)
    // para que el jugador nunca se sienta 100% seguro.
    alpha = choose(0, 0, 0, 0.1); 
}