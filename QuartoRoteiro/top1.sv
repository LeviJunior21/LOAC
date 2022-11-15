// Levi de Lima Pereira Junior - 121210472
// Roteiro 4. Questão 1

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

    logic [0:0] selecaoSerialParalela;
    logic [3:0] entradaParalela;
    logic [0:0] entradaSerial;
    logic [3:0] memoria;
    logic [1:0] funcao;
    logic [0:0] reset;

    always_comb selecaoSerialParalela <= SWI[2];
    always_comb entradaParalela <= SWI[7:4];  
    always_comb entradaSerial <= SWI[3];
    always_comb funcao <= SWI[1:0];
    always_comb reset <= SWI[1]; 

    always_ff @(posedge clk_2 or posedge reset) begin
        if (reset) begin
            memoria <= 0; 
        end else
        if (selecaoSerialParalela == 'b0) begin
            if (reset) begin
               memoria <= 0;
            end
            else begin
                memoria[3] <= entradaSerial;
                memoria[2] <= memoria[3];
                memoria[1] <= memoria[2];
                memoria[0] <= memoria[1];
            end
        end
        else begin
            memoria <= entradaParalela;
        end
    end

    always_comb LED[7:4] <= memoria;
    always_comb LED[0] <= clk_2;
endmodule
