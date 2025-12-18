/// @description Inicializar subtítulos

// Array con los subtítulos divididos en segmentos
subtitulos = [
    "Hola? Hola? Oh, espero que se me escuche",
    "Bien, tu primera noche, supongo que ya leiste el manual",
    "y sabes las cosas basicas, pero los que ya trabajamos aqui",
    "sabemos un par de cosas sobre las que... hay que tener cuidado,",
    "nada muy peligroso pero es mejor saberlas, sabes? Jejej ",
    "ehhh bueno, los animatronicos tiene una inteligencia artificial",
    "que hace que se muevan, es lo que hace que bailen y actuen en el dia,",
    "lo curioso es que tambien salen a estirar las piernas en la noche,",
    "solo pasean por la pizzeria pero... no hacen nada raro,",
    "la mayoria de las veces jeje, bueno en cualquier caso",
    "es mejor que no te les acerques, en ningun caso,",
    "ni mientras caminan ni mientras bailan,",
    "a veces son algo... impredecibles y debido a su programacion",
    "podrian confundirte con un endoesqueleto sin traje",
    "y trataran de meterte en uno con un poco de su 'fuerza de robot', jeje,",
    "eso no sera nada bueno así que solo mantente fuera de su alcance ok?",
    "Ah, como podras ver la pizzería es algo vieja",
    "y hay cosas que dejan de funcionar de repente,",
    "no querras quedarte a oscuras con esas cosas rondando por ahi,",
    "tienen muy mala vision pero en la noche tu tampoco veras mucho",
    "asi que lo mejor es que te encargues de cambiar los fusibles cuando eso ocurra",
    "Yyyy creo que eso es todo, buena suerte,",
    "te ira bien mientras sigas los consejos, adios"
];

// Tiempos en segundos cuando debe aparecer cada subtítulo
// AJUSTA ESTOS TIEMPOS según tu audio real
tiempos = [
    0,    // "Hola? Hola?..."
    5,    // "Bien, tu primera noche..."
    10,    // "y sabes las cosas básicas..."
    15,    // "sabemos un par de cosas..."
    19,   // "nada muy peligroso..."
    24,   // "ehhh bueno, los animatrónicos..."
    29,   // "que hace que se muevan..."
    33,   // "lo curioso es que también..."
    37,   // "solo pasean por la pizzería..."
    41,   // "la mayoría de las veces..."
    45,   // "es mejor que no te les acerques..."
    49,   // "ni mientras caminan..."
    53,   // "a veces son algo... impredecibles..."
    57,   // "podrían confundirte..."
    61,   // "y tratarán de meterte..."
    65,   // "eso no será nada bueno..."
    69,   // "Ah, cómo podrás ver..."
    73,   // "y hay cosas que dejan..."
    77,   // "no querrás quedarte a oscuras..."
    81,   // "tienen muy mala visión..."
    85,   // "así que lo mejor es..."
    89,   // "Yyyy creo que eso es todo..."
    94    // "te irá bien mientras..."
];

indice_actual = 0;
tiempo_inicio = current_time;
audio_referencia = noone;
alpha_subtitulo = 0;