; Levi de Lima Pereira Junior - 121210472
; Roteiro 6 - questão 2

.text
main:
    addi x10, zero, 2 
    addi x11, zero, 4
    beq x10, x11, jump
    add x12, x10, x10
    jal x0, fim
jump: 
    add x12, x11, x11 
fim: 
    addi x0, x0, 0 
