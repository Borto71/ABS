    .section .text
    .global main

main:
    push {lr}           // Salva lr nello stack

    mov r0, #15         // Decelerazione (15)
    mov r1, #5          // Velocità (5)
    bl calcola_blocco   // Chiama la funzione calcola_blocco

    // Il risultato è in r0 (0 o 1)
    cmp r0, #1
    beq blocco_detected

    // Se non bloccato
    mov r2, #0          // Puoi usarlo come indicatore

    b fine

blocco_detected:
    mov r2, #1          // Indicatore di blocco

fine:
    pop {lr}            // Ripristina lr
    bx lr               // Torna al sistema operativo o al chiamante
