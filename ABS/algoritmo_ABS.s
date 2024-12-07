/*IDEA:

ATTIVAXIONE SOPRA I 5 km/h IN MODO DA NON ENTRARE A VELOCITA TROPPO BASSE

RILEVAZIONE BLOCCAGGIO  
    RILEVAZIONE ASSE/RUOTA BLOCCANTE

        PRESSIONE FRENANTE = 0 - 1(NON FULL) IN OSCILLAZZIONE REGOLARE


NON RILEVAZIONE BLOCCAGGIO  (ritorno ad una situazione di non bloccaggio solo quando la sitazione è stabile x intervalli di tempo con ruota NON bloccata)

    SISTEMA IN FASE DI ASCOLTO(LETTURA TUTTI SENSORI) */

.section .data  
pressure_normal: .word 100 // pressione frenante normale, il valore andrebbe cambiato da macchina a macchina
pressure_reduced .word 50 // pressione ridotta per ruota bloccata, valore calcolato in base alla macchina che si usa 
error_message: .asciz "ANOMALIA RILEVATA! Riduzione pressione sulla ruota bloccata.\n"
.section .bss
engine_status: .space 4 // stato del motore 1 acceso 0 spento
wheel_pressure_1: .space 4 // pressione frenanate sulla ruota 1
wheel_pressure_2: .space 4 // pressione frenanate sulla ruota 2
wheel_pressure_3: .space 4 // pressione frenanate sulla ruota 3
wheel_pressure_4: .space 4 // pressione frenanate sulla ruota 4

.section .text

.global_start

_start:
    LDR R0, =engine_status // carico il valore puntato di engine_status in R0

loop: 
    LDR R1, [R0] // carico il valore di engine_status puntato da R0 su R1
    CMP R1, #0 // confronto con 0 per vedere se il motore è spento
    BEQ loop // se è acceso rimango nel loop
    B end // se è 0 salto a end e termino il loop



