//SISTEMA DI AUTO-DIAGNOSI PER VEICOLO IN MOVIMENTO

//prima di effettuare l'auto diagnosi in maniera ripetitiva testare e sincronizzare i sensori collegati
//(OPZIONALE: implementare un filtro passa-basso per rimuovere eventuali rumori presenti)

//lettura costante di sensore di velocità e controllo con gli altri sensori per decretare se uno di essi è guasto
//installazione di un sensore aggiuntivo che calcola la velocità del veicolo in modo da comaprarla col sensore sulla gomma 

//controllo anche su impanto idraulico, sopratutto su valvole e pompe in modo da effettuare auto diagnosi anche su quello.


.section .data 
sync_message:  .asciz "Sincronizzazione in corso..."
error_message: .asciz "Errore sulla ruota:"
wheel_labels: .asciz "1\0"
              .asciz "2\0"
              .asciz "3\0"
              .asciz "4\0"


anomaly_msg .asciz "Anomalia rilevata, ||ABS NON IN FUNZIONE||ARRESTARE IL VEICOLO||"

.section .bss 
    speed_wheel_1: .space 4 // riservo 4 byte alla velocità della ruota 1 fino alla ruota 4
    speed_wheel_2: .space 4
    speed_wheel_3: .space 4
    speed_wheel_4: .space 4
    global_speed: .space 4 // riservo 4 byte alla velocità globale 

.section .text 

.global_start

_start

BL init_sensor // salto all'etichetta che inizializza i sensori

// ORA STO FACENDO LA DIAGNOSI PER SINGOLA RUOTA 

//RUOTA 1 
    LDR R0, =speed_wheel_1 // carico l'indirizzo del sensore della ruota 1
    BL check_wheel // controllo ruota 1
//RUOTA 2
    LDR R0, =speed_wheel_2 // carico l'indirizzo del sensore della ruota 2
    BL check_wheel // controllo ruota 1
//RUOTA 3
    LDR R0, =speed_wheel_3 // carico l'indirizzo del sensore della ruota 3
    BL check_wheel // controllo ruota 1
//RUOTA 4
    LDR R0, =speed_wheel_4 // carico l'indirizzo del sensore della ruota 4
    BL check_wheel // controllo ruota 1

    BL end_program // salto alla fine del programma 

check_wheel: // ho su R0 la velocita della ruota e su R1 il numero della ruota 
    LDR  R2, [R0] // metto sul regsitro R2 la velocita della ruota 
    LDR R3, =global_speed // metto su R3 l'indirizzo della velocita globale
    LDR R3, [R4] // leggo il valore di velocita globale, su R3 avevo l'indirizzo e ora lo sto leggendo 
    SUB R5, R2, R4 // calcolo la differenza tra singola ruota e velocita globale
    CMP R5, #0 // ora controllo il segno della differenza
    BGE positive_diff // salta se la differenza è positiva
    RSBS R5, R5, #0 // rendo la differenza vel ruota - vel globale positiva 

positive_diff:
    LDR R6, =tollerance // carico la tolleranza nel registro di R6
    LSR R6, [R6]
    CMP R5, R6 // confronto la tolleranza con la differenza (vel ruota - vel globale) ovviamente postiva
    BLS no_error  // ora guardo se non ci sono errori sulla tolleranza, e salto all'etichetta no_error

    // segnalo ERRORE NEI SENSORI
    LDR R0, =error_message // carico sul registro R0 il messaggio di errore
    BL print_string // stampo il messaggio di errore
    LDR R0, =wheel_labels // carico l'indirizzo delle ruota
    ADD R0, R0, R1, LSL #2 // calcolo l'indirizzo per l'offset in memoria per accedere ai sensori di una ruota specifica
    BL print_string // ora stampo il numero della ruota

    no_error:
        BL LR // ritorno al chiemante, tramite il registro LR

    print_string:
    // stampo la stringa puntata da R0
        MOV R1, R0 // salvo l'indirizzo della stringa in R1

    print_loop:
        LDRB R2, [R1], #1 // leggo di un byte e avanzo 
        CMP R2, #0 // controllo se il terminatore non è nullo 
        BEQ print_done // se è nullo ho finito e quindi salto a print_done
        




init_sensor:
        MOV R0, #0                         // simulo la velocità iniziale per i sensori
    STR R0, [speed_wheel_1]
    STR R0, [speed_wheel_2]
    STR R0, [speed_wheel_3]
    STR R0, [speed_wheel_4]
    STR R0, [global_speed]
    BX LR 

    

read_speed_sensor:
    BL read_speed_main // salto all'etichetta dove leggo il valore dal sensore principale