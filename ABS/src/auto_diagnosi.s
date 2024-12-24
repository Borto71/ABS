.section .data 
sync_message:  .asciz "Sincronizzazione in corso..."
error_message: .asciz "Errore sulla ruota:"     
wheel_labels: .asciz "1\0"
              .asciz "2\0"
              .asciz "3\0"
              .asciz "4\0"


anomaly_msg: .asciz "Anomalia rilevata, ||ABS NON IN FUNZIONE||ARRESTARE IL VEICOLO||"

.section .bss 
    speed_wheel_1: .space 4 // riservo 4 byte alla velocità della ruota 1 fino alla ruota 4
    speed_wheel_2: .space 4
    speed_wheel_3: .space 4
    speed_wheel_4: .space 4
    global_speed: .space 4 // riservo 4 byte alla velocità globale 


.section .text 
.global algoritmo_ABS
.type algoritmo_ABS, %function


.global_start

_start:

BL init_sensor // salto all'etichetta che inizializza i sensori

main_loop: 
    LDR R0, engine_status // vado a caricare l'indirizzo di engine status 
    LDR R1, [R0] // ora carico il valore in R1
    CMP R1, #0 // controllo se è 0
    BEQ end_program // se è 0 salto a end_program
    
    // effettu la diagnosi per ogni ruota

    BL diagnose_wheels 

    B main_loop // rimango nel main loop

diagnose_wheels: 
//DIAGNOSI PER RUOTA 1  
    LDR R0, =speed_wheel_1
    MOV R1, #0
    BL check_wheel
//DIAGNOSI PER RUOTA 2  
    LDR R0, =speed_wheel_2
    MOV R1, #0
    BL check_wheel
//DIAGNOSI PER RUOTA 3  
    LDR R0, =speed_wheel_3
    MOV R1, #0
    BL check_wheel
//DIAGNOSI PER RUOTA 4  
    LDR R0, =speed_wheel_4
    MOV R1, #0
    BL check_wheel

    BX LR // ritorno al chiamante

check_wheel: // ho su R0 la velocita della ruota e su R1 il numero della ruota
    LDR  R2, [R0]       //carico la velcoità delle ruote su R2
    LDR  R3, =global_speed
    LDR  R3, [R3]       // Carico la velcoità globale su R3
    SUB  R5, R2, R3     // Calcolo la differenza tra velocità di una ruota e velocità globale
    CMP  R5, #0
    BGE  positive_diff
    RSBS R5, R5, #0     // Rendo la differenza positiva 
   
positive_diff:
    LDR  R6, =tolerance // carico la tolleranza
    LSR  R6, R6, #1     // shifto R6 di 1 bit
    CMP  R5, R6
    BLS  no_error

    // Errore del segnale
    LDR  R0, =error_message
    BL   print_string
    LDR  R0, =wheel_labels
    ADD  R0, R0, R1, LSL #2
    BL   print_string

no_error:
    BL LR // ritorno al chiemante, tramite il registro LR

print_string:
    // stampo la stringa puntata da R0
    MOV R1, R0 // salvo l'indirizzo della stringa in R1

 print_loop:
    LDRB R2, [R1], #1 // leggo di un byte e avanzo 
    CMP R2, #0 // controllo se il terminatore non è nullo 
    BEQ print_done // se è nullo ho finito e quindi salto a print_done
    MOV R7, #4  // chiamata a sistema della write 
    MOV R0, #1 // file descriptor di stdout
    MOV R2, #1 //lunghezza di un byte 
    SVC #0 // chiamata a sistema (supervisor call)
    B print_loop // continua il loop 

print_done:
    BX LR // ritorno al chiamante 

init_sensor: // etichetta che inizializza i sensori
    MOV R0, #0 // simulo una velocità per i sensori
    STR R0, [speed_wheel_1]
    STR R0, [speed_wheel_2]
    STR R0, [speed_wheel_3]
    STR R0, [speed_wheel_4]
    STR R0, [global_speed]
    MOV R0, #1 // metto 1 nel registro  R1
    STR r1, =engine_status // carico 1 nel registro engine status per simulare il motore acceso
    BX LR 

end_program: // fine del programma 
    MOV R7, #1 // syscall per exit
    SVC #0