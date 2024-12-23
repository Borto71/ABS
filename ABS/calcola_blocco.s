    .section .text
    .global calcola_blocco

calcola_blocco:
    PUSH {LR}           // salva LR nello stack

    // R0 contine decelerazione (argument 1)
    // R1 contiene velcoità (argument 2)

    CMP R0, #10         // Compara decelerazione con threshold (e.g., 10)
    BLE no_blocco       // Se decelerazione <= threshold, vai a no_blocco
    CMP R1, #0          // Compara la velocità con 0
    BLE no_blocco       // If velocità <= 0, vai a no_blocco

    // entrambe le condizioni sono vero
    MOV R0, #1          // Return 1 (blocco)
    B fine

no_blocco:
    MOV R0, #0          // Return 0 (nessun blocco)

fine:
    POP {LR}            // tiro fuori dallo stack LR
    BX LR               // ritorno al chiamante
