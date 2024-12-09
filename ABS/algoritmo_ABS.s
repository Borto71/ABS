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
vehicle_speed: .space 4 // velocita della machhina (calcolata nella funzione apposita)

.section .text

.global_start

_start:
    LDR R0, =pressure_normal // carico sul registro R1 l'indirizzo che punta alla variablile della pressione normale del freno
    LDR R1, [R0] // ora carico il valore effettivo 
    LDR R0, =pressure_reduced // carico sul registro R1 l'indirizzo che punta alla variablile della pressione ridotta del freno
    LDR R2, [R0] // ora carico il valore effettivo
    
abs_loop: 
    // controllo lo stato del motore
    LDR R3, =engine_status 
    LDR R4, [R3]
    CMP R4, #1 
    BNE stop_abs

    //leggi la velocità del veicolo
    LDR R3, =vehicle_speed
    LDR R4, [R3] // R4 = velocità del veicolo
    CMP R4, #5 // controllo se è maggiore o minore di 5
    BLE abs_loop // se <= 5 rimani in ascolto (non attivare ABS)
    
    



stop_abs: // termino il programma 
    MOV R7, #1 // codice di uscita 
    SWI #0 // genera un interruzione software, utilizzato per sistema embedded



