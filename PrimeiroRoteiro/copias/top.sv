// Laboratório de Organização e Arquitetura de Computadores
// Aluno: Levi de Lima Pereira Júnior - 121210472
// Professor: Kyller Costa Gorgônio

// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

  always_comb begin
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
       if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
       else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
  end

  logic porta;
  logic relogio;
  logic interruptor;

  always_comb begin
    porta <= SWI[0];
    relogio <= SWI[1];
    interruptor <= SWI[2];
    /*
    Acende o LED[1] se a porta estiver aberta (SEG[0] <= 0), o relógio eletrônico estiver fora de expediente(SWI[1] <= 0) e o interruptor na mesa do gerente estiver desligado (SWI[2] <= 0). Ou
    Acende o LED[1] se a porta estiver aberta (SEG[0] <= 0), o relógio eletrônico estiver fora de expediente(SWI[1] <= 0) e o interruptor na mesa do gerente estiver ligado (SWI[2] <= 1), Ou
    Acende o LED[1] se a porta estiver aberta (SEG[0] <= 0), o relógio eletrônico estiver em horário de expediente(SWI[1] <= 1) e o interruptor na mesa do gerente estiver ligado (SWI[2] <= 1).
    Não acende o LED[1] se a porta estiver aberta (SEG[0] <= 0), o relógio eletrônico estiver em horário de expediente(SWI[1] <= 1) e o interruptor na mesa do gerente estiver desligado (SWI[2] <= 0).
    */
    LED[1] <= (~porta & (~relogio | interruptor));
  end

  /*
  -----------------------------------------------------------------------------
  Questão 2: 
  */

  logic Temperatura1;
  logic Temperatura2;

  always_comb begin
    Temperatura1 <= SWI[7];
    Temperatura2 <= SWI[6];

    /* 
    Se o SWIFT 7 (temperatura igual ou maior que 15 graus) está desligado e o SWIFT 6 (Temperatura igual ou maior que 20 graus) está desligado,
    então o aquecedor é ativado. Pois está abaixo do limite, então está frio e temos que ligar o aquecedor
    */
    if (~Temperatura1 & ~Temperatura2) begin
      LED[7] <= 1;
      LED[6] <= 0;
      SEG[7] <= 0;
    end
    /* 
    Se o SWIFT 7 (temperatura igual ou maior que 15 graus) está ligado e o SWIFT 6 (Temperatura igual ou maior que 20 graus) está desligado,
    então o resfriador é ativado.
    */
    else if (Temperatura1 & Temperatura2) begin
      LED[6] <= 1;
      LED[7] <= 0;
      SEG[7] <= 0;
    end
    /* 
    Se o SWIFT 7 (temperatura igual ou maior que 15 graus) está desligado e o SWIFT 6 (Temperatura igual ou maior que 20 graus) está ligado,
    então resulta em inconsistência e o SEGMENTO é ligado.
    */
    else if (~Temperatura1 & Temperatura2) begin
      SEG[7] <= 1;
      LED[7] <= 0;
      LED[6] <= 0;
    end
    /* 
    Se nenhuma das outras condições forem atendidas, então não é ligado nenhum LED e nenhum segmento.
    */
    else begin
      LED[6] <= 0;
      LED[7] <= 0;
      SEG[7] <= 0;
    end
  end

endmodule
