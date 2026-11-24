# Reto final: contar negativos y mostrar la cantidad con pixeles rojos.
# Entrada de CONTAR: $a0 = direccion del arreglo, $a1 = cantidad de elementos.
# Salida de CONTAR: $v0 = cantidad de negativos.
# CONTAR usa $t0, $t1, $t2 y $t3; no modifica registros $s ni hace otro jal.

.data
A:          .word 5, -3, 12, -7, 0, 8, -1, -10
RESULTADO:  .word 0

.text
        addi $a0, $zero, A       # Direccion base del arreglo: 0x200.
        addi $a1, $zero, 8       # Hay ocho palabras.
        jal  CONTAR             # Devuelve el numero de negativos en $v0.

        sw   $v0, RESULTADO($zero) # Guarda la cuenta en 0x220.

        add  $t4, $v0, $zero     # Pixeles que faltan por pintar.
        addi $t5, $zero, 0x400   # Pixel (0,0).
        addi $t6, $zero, 1       # Color 1: rojo.

PINTAR:
        beq  $t4, $zero, FIN     # Al completar la cuenta, termina.
        sb   $t6, 0($t5)        # Un byte pinta un solo pixel.
        addi $t5, $t5, 1        # Siguiente columna de la fila 0.
        addi $t4, $t4, -1
        j    PINTAR

# Funcion hoja: $ra conserva la direccion guardada por jal.
CONTAR:
        add  $t0, $a0, $zero     # Puntero al elemento actual.
        add  $t1, $a1, $zero     # Elementos que faltan por revisar.
        add  $v0, $zero, $zero   # Cuenta inicial: cero.

RECORRER:
        beq  $t1, $zero, RETORNAR
        lw   $t2, 0($t0)        # Lee una palabra del arreglo.
        slt  $t3, $t2, $zero    # Comparacion con signo: 1 si es negativo.
        add  $v0, $v0, $t3      # Suma 1 si es negativo; de lo contrario, 0.
        addi $t0, $t0, 4        # Siguiente palabra: cuatro bytes despues.
        addi $t1, $t1, -1
        j    RECORRER

RETORNAR:
        jr   $ra                # Regresa al sw del programa principal.

FIN:                            # PC al final de .text: termina ArquiSim.
