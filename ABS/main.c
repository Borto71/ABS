#include "algoritmo_ABS.h"
#include "auto_diagnosi.h"

int main(void) {
    // Inizializzazione dell'hardware
    
    while(1) {
        algoritmo_ABS();
        auto_diagnosi();
        // Altre funzioni o logica
    }
    
    return 0;
}