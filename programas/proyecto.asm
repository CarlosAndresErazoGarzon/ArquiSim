# Proyecto final -- Filtros de imagen con ArquiSim
#
# El programa lee los botones UNA vez al empezar (palabra 0x600) y dibuja la imagen
# de .data con los filtros elegidos:
#
#   botón 0   filtro 1: negativo                 botón 7 = 0  pantalla de 16 colores:
#   botón 1   filtro 2: escala de grises                      original (x 0-15) | filtrada (x 16-31)
#   botón 2   filtro 3: el que proponga el grupo  botón 7 = 1  pantalla RGB 32 x 32:
#                                                             filtrada, cada píxel en 2 x 2
#
# Cómo probarlo:
#   (copie este archivo a la carpeta programas/ de su simulador)
#   ./sim -n 100000 programas/proyecto.asm
#   mem[0x600] = 0x81      activa los botones 0 y 7 (o use bt 0 y bt 7)
#   c                      ejecuta hasta el final;  p  cambia de pantalla
#   0                      reinicia: los botones se conservan para probar otra vez
#
# La imagen ocupa 0x200-0x2FF (16 x 16 bytes, RGB332 = RRRGGGBB). Para cambiarla,
# reemplace el bloque de abajo por la salida de img_a_arquisim (vea la sección
# "Preparar la imagen" del enunciado). El programa NO debe modificar la imagen.
#
# >>> IMAGEN (generado con: ./img_a_arquisim ejemplo.bmp, a partir de ejemplo.jpg)
# Imagen generada con img_a_arquisim a partir de 'ejemplo.bmp' (1500 x 1500)
# 16 x 16 píxeles, 1 byte por píxel en formato RGB332 (RRRGGGBB) = 256 bytes
# El píxel (x, y) está en la dirección IMAGEN + 16*y + x
.data
IMAGEN:
        .byte 0xFF, 0xFF, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xED, 0xFF, 0xFF    # fila 0
        .byte 0xFF, 0xFF, 0xE0, 0xE4, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xE4, 0xFF, 0xFF    # fila 1
        .byte 0xFF, 0xFF, 0xE9, 0xE5, 0xC4, 0xA0, 0xA0, 0xA0, 0xE0, 0xE4, 0xE4, 0xE0, 0xE0, 0xE9, 0xFF, 0xFF    # fila 2
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0xC4, 0x85, 0x44, 0xA4, 0xE4, 0xE4, 0xE4, 0xE4, 0xE0, 0xF2, 0xFF, 0xFF    # fila 3
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0x65, 0x44, 0x65, 0x65, 0xE0, 0xE4, 0xE4, 0xE4, 0xE0, 0xF2, 0xFF, 0xFF    # fila 4
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0x89, 0x45, 0x24, 0x69, 0x84, 0xE4, 0xE4, 0xE4, 0xE0, 0xF6, 0xFF, 0xFF    # fila 5
        .byte 0xFF, 0xFF, 0xF2, 0xC4, 0x49, 0x49, 0x45, 0x89, 0x69, 0xA4, 0xC4, 0xC0, 0xE0, 0xF6, 0xFF, 0xFF    # fila 6
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0xA4, 0x65, 0x65, 0x84, 0xA5, 0x69, 0x89, 0x85, 0xE0, 0xF6, 0xFF, 0xFF    # fila 7
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0xE4, 0xA5, 0x84, 0xE0, 0xA8, 0x88, 0x88, 0xA8, 0xE0, 0xF6, 0xFF, 0xFF    # fila 8
        .byte 0xFF, 0xFF, 0xF2, 0xE0, 0xE4, 0xA4, 0x84, 0xC0, 0x89, 0x6D, 0x6D, 0x68, 0x84, 0xD6, 0xFF, 0xFF    # fila 9
        .byte 0xFF, 0xFF, 0xF6, 0xE4, 0xA4, 0xE4, 0x65, 0x44, 0x8D, 0xB1, 0xD5, 0x71, 0x91, 0xDA, 0xFF, 0xFF    # fila 10
        .byte 0xFF, 0xFF, 0x92, 0x00, 0x20, 0x24, 0x69, 0xD1, 0xD5, 0x8D, 0xA8, 0x68, 0x95, 0xDA, 0xFF, 0xFF    # fila 11
        .byte 0xFF, 0xFF, 0x92, 0x00, 0x20, 0x24, 0xAD, 0xCC, 0xAD, 0xAD, 0x84, 0x90, 0xAC, 0xD6, 0xFF, 0xFF    # fila 12
        .byte 0xFF, 0xFF, 0x6D, 0x00, 0x40, 0x00, 0x24, 0x68, 0x68, 0x88, 0xAC, 0x88, 0x88, 0xB1, 0xFF, 0xFF    # fila 13
        .byte 0xFF, 0xFF, 0x24, 0x00, 0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0xFF, 0xFF    # fila 14
        .byte 0xFF, 0xFF, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xD2, 0xFF, 0xFF    # fila 15
# <<< IMAGEN

.text
# $s0: direccion del siguiente pixel de la imagen
# $s1: direccion del inicio de la fila en pantalla
# $s2: filas pendientes
# $s3: columna actual
# $s4: ancho de la imagen

    addi $s0, $zero, 0x200
    addi $s1, $zero, 0x400
    addi $s2, $zero, 16
    addi $s4, $zero, 16
    lw   $s5, 0x600($zero)
    andi $t0, $s5, 0x80
    bne  $t0, $zero, dibujar_rgb

fila:
    addi $s3, $zero, 0

columna:
    lbu  $a0, 0($s0)
    jal  a_16_colores

    add  $t0, $s1, $s3
    sb   $v0, 0($t0)
        # Dibujar el pixel en la mitad derecha
    jal  aplicar_filtros
    addi $a0, $v0, 0
    jal  a_16_colores
    add  $t0, $s1, $s3
    sb   $v0, 16($t0)

    addi $s0, $s0, 1
    addi $s3, $s3, 1
    bne  $s3, $s4, columna

    addi $s1, $s1, 32
    addi $s2, $s2, -1
    bne  $s2, $zero, fila
    j    fin

# Entrada: pixel RGB332 en $a0
# Salida: indice de la paleta de 16 colores en $v0
# Recibe un pixel RGB332 en $a0 y devuelve el resultado en $v0.
aplicar_filtros:
    addi $v0, $a0, 0
    andi $t0, $s5, 0x01
    beq  $t0, $zero, probar_grises
    xori $v0, $v0, 0xFF

probar_grises:
    andi $t0, $s5, 0x02
    beq  $t0, $zero, probar_posterizacion

    # Extraer rojo, verde y azul del pixel RGB332.
    srl  $t1, $v0, 5
    srl  $t2, $v0, 2
    andi $t2, $t2, 0x07
    andi $t3, $v0, 0x03

    # Calcular Y = (R + 2*G + 2*B + 2) >> 2.
    add  $t2, $t2, $t3
    sll  $t2, $t2, 1
    add  $t1, $t1, $t2
    addi $t1, $t1, 2
    srl  $t1, $t1, 2

    # Empacar R = Y, G = Y y B = Y >> 1.
    sll  $v0, $t1, 5
    sll  $t2, $t1, 2
    srl  $t3, $t1, 1
    or   $v0, $v0, $t2
    or   $v0, $v0, $t3
probar_posterizacion:
    andi $t0, $s5, 0x04
    beq  $t0, $zero, fin_filtros
    andi $v0, $v0, 0x92

fin_filtros:
    jr   $ra
a_16_colores:
# Recibe un pixel RGB332 en $a0 y lo devuelve en $v0.
# Por ahora, el pixel sale igual.
    srl  $v0, $a0, 7      # Bit alto de rojo -> bit 0
    srl  $t0, $a0, 3
    andi $t1, $t0, 2      # Bit alto de verde -> bit 1
    or   $v0, $v0, $t1

    sll  $t1, $a0, 1
    andi $t1, $t1, 4      # Bit alto de azul -> bit 2
    or   $v0, $v0, $t1

    or   $t0, $t0, $a0
    andi $t0, $t0, 8      # Segundo bit de rojo o verde -> brillo
    or   $v0, $v0, $t0
    jr   $ra

dibujar_rgb:
    sw   $zero, 0x604($zero)    # Empezar en (0, 0)
    addi $s6, $s0, 0           # Guardar el inicio de la fila original

fila_rgb:
    addi $s7, $zero, 2         # Dibujar dos veces cada fila

repetir_fila_rgb:
    addi $s0, $s6, 0
    addi $s3, $zero, 0

columna_rgb:
    lbu  $a0, 0($s0)
    jal  aplicar_filtros
    addi $a0, $v0, 0
    jal  a_rgb

    sw   $v0, 0x608($zero)     # Primera copia horizontal
    sw   $v0, 0x608($zero)     # Segunda copia horizontal

    addi $s0, $s0, 1
    addi $s3, $s3, 1
    bne  $s3, $s4, columna_rgb

    addi $s7, $s7, -1
    bne  $s7, $zero, repetir_fila_rgb

    addi $s6, $s0, 0           # Guardar el inicio de la siguiente fila
    addi $s2, $s2, -1
    bne  $s2, $zero, fila_rgb
    j    fin

# Convierte el pixel RGB332 de $a0 a 0x00RRGGBB en $v0.
a_rgb:
    srl  $v0, $a0, 5
    sll  $v0, $v0, 21          # Rojo
    andi $t0, $a0, 0x1C
    sll  $t0, $t0, 11          # Verde: sus bits ya empiezan en el bit 2
    andi $t1, $a0, 0x03
    sll  $t1, $t1, 6           # Azul
    or   $v0, $v0, $t0
    or   $v0, $v0, $t1
    jr   $ra

fin:
    sll  $zero, $zero, 0
