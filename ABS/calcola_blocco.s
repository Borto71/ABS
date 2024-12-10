    .section .text
    .global calcola_blocco

calcola_blocco:
    PUSH {R4, LR}       // Salva r4 e lr nello stack

    // Caricare i parametri
    LDR R0, [SP, #4]    // Carica la decelerazione in r0 (argomento 1)
    LDR R1, [SP, #8]    // Carica la velocità in r1 (argomento 2)

    // Esegui i calcoli (esempio: se decelerazione > soglia e velocità > 0)
    CMP R0, #10         // Confronta decelerazione con soglia (10 come esempio)
    BLE no_blocco       // Se decelerazione <= soglia, vai a no_blocco
    CMP R1, #0          // Confronta velocità con 0
    BLE no_blocco       // Se velocità <= 0, vai a no_blocco

    // Se entrambe le condizioni sono vere, ruota bloccata
    MOV R0, #1          // Ritorna 1 (blocco)
    B fine

no_blocco:
    MOV R0, #0          // Ritorna 0 (nessun blocco)

fine:
    POP {R4, LR}        // Ripristina r4 e lr
    BX LR               // Ritorna al chiamante
