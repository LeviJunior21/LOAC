// Aluno: Levi de Lima Pereira Júnior - 121210472
// Roteiro 2

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

  /*
  Questão 1:
  */

  // Preparando para receber dois cabos
  logic [1:0] entrada;

  // Representação dos segmentos em binário
  parameter apagado = 'b00000000;
  parameter numeroZero = 'b00111111;
  parameter numeroUm = 'b00000110;
  parameter numeroDois = 'b01011011;

  always_comb begin
    // Recebendo os cabos nos SWIFT´s 0 e 1
    entrada <= SWI[1:0];

    if (entrada == 'b00) begin
        SEG[7:0] <= apagado;
    end
    else if (entrada == 'b01) begin
        SEG[7:0] <= numeroZero;
    end
    else if (entrada == 'b10) begin
        SEG[7:0] <= numeroUm;
    end
    else begin
        SEG[7:0] <= numeroDois;
    end
  end

  /*
  Questão 2:
  */

  logic [1:0] A;
  logic [1:0] B;
  logic status;

  always_comb begin
    A <= SWI[7:6];
    B <= SWI[5:4];
    status <= SWI[3];

    if (status) begin
        LED[7:6] <= B;
    end
    else begin
        LED[7:6] <= A;
    end

  end
  
endmodule