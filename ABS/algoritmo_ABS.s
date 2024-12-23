.global _start

_start:
    // Inizializzo le variabili 
    LDR R0, =pressure_normal
    LDR R1, [R0]          // R1 = pressure_normal
    LDR R0, =pressure_reduced
    LDR R2, [R0]          // R2 = pressure_reduced

    B abs_loop            //salta a ABS loop

abs_loop:
    // controllo lo stato del motore
    LDR R3, =engine_status
    LDR R4, [R3]
    CMP R4, #1
    BNE stop_abs          // Se il motore è spento, ferma l'algoritmo ABS

    // leggi la valocità della machhina
    LDR R3, =vehicle_speed
    LDR R4, [R3]          // R4 = vehicle_speed
    CMP R4, #5            // controllo se velcoità > 5
    BLE abs_loop          // Se velocità <= 5, salta ad ABS proceesing

    // Processa ogni ruota
    BL process_wheel_1
    BL process_wheel_2
    BL process_wheel_3
    BL process_wheel_4

    B abs_loop            // Ripete il loop

stop_abs:
    // Termina il programma in un loop indefinito
    B stop_abs            // In un sistema embedded si farebbe un loop qua.

// RUOTA 1
process_wheel_1:
    //leggi la velocità della ruota 
    LDR R5, =wheel_speed_1
    LDR R6, [R5]          // R6 = wheel_speed_1

    // calcola la decelerazione: deceleration = abs(vehicle_speed - wheel_speed)
    SUB R0, R4, R6        // R0 = vehicle_speed - wheel_speed
    CMP R0, #0
    BGE dec_ok1
    NEG R0, R0            // R0 = -R0 (rendi la decelerazione postiva)
dec_ok1:
    // R0 ora ha la decelerazione
    MOV R1, R4            // R1 = vehicle_speed
    BL calcola_blocco     // chiama la funzione calcola_blocco

    // Aggiusta la pressione sul freno in base al risultato
    CMP R0, #1
    BNE wheel1_no_block

    // La ruota è bloccata
    LDR R2, =pressure_reduced
    LDR R2, [R2]
    LDR R3, =wheel_pressure_1
    STR R2, [R3]
    // opzionale, manda a schermo un messaggio di errore
    // LDR R0, =error_message
    // BL display_message    // Bisonga implementare il display_message
    B wheel1_done

wheel1_no_block:
    // la ruota non è bloccata
    LDR R2, =pressure_normal
    LDR R2, [R2]
    LDR R3, =wheel_pressure_1
    STR R2, [R3]

wheel1_done:
    BX LR                  // Return alla subroutine

// ROUTA 2

process_wheel_2:
    LDR R5, =wheel_speed_2
    LDR R6, [R5]          // R6 = wheel_speed_2
    SUB R0, R4, R6
    CMP R0, #0
    BGE dec_ok2
    NEG R0, R0
dec_ok2:
    MOV R1, R4
    BL calcola_blocco
    CMP R0, #1
    BNE wheel2_no_block
    LDR R2, =pressure_reduced
    LDR R2, [R2]
    LDR R3, =wheel_pressure_2
    STR R2, [R3]
    B wheel2_done

wheel2_no_block:
    LDR R2, =pressure_normal
    LDR R2, [R2]
    LDR R3, =wheel_pressure_2
    STR R2, [R3]

wheel2_done:
    BX LR

// RUOTA 3
process_wheel_3:
    LDR R5, =wheel_speed_3
    LDR R6, [R5]          
    SUB R0, R4, R6
    CMP R0, #0
    BGE dec_ok3
    NEG R0, R0
dec_ok3:
    MOV R1, R4
    BL calcola_blocco
    CMP R0, #1
    BNE wheel3_no_block
    LDR R2, =pressure_reduced
    LDR R2, [R2]
    LDR R3, =wheel_pressure_3
    STR R2, [R3]
    B wheel3_done

wheel3_no_block:
    LDR R2, =pressure_normal
    LDR R2, [R2]
    LDR R3, =wheel_pressure_3
    STR R2, [R3]

wheel3_done:
    BX LR


//RUOTA 4
process_wheel_4:
    LDR R5, =wheel_speed_4
    LDR R6, [R5]          // R6 = wheel_speed_4
    SUB R0, R4, R6
    CMP R0, #0
    BGE dec_ok4
    NEG R0, R0
dec_ok4:
    MOV R1, R4
    BL calcola_blocco
    CMP R0, #1
    BNE wheel4_no_block
    LDR R2, =pressure_reduced
    LDR R2, [R2]
    LDR R3, =wheel_pressure_4
    STR R2, [R3]
    B wheel4_done

wheel4_no_block:
    LDR R2, =pressure_normal
    LDR R2, [R2]
    LDR R3, =wheel_pressure_4
    STR R2, [R3]

wheel4_done:
    BX LR