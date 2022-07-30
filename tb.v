module tb;

reg clk;
integer k;
wire [15:0]PC;
wire [15:0] Reg0;
wire [15:0] Reg1;
wire [15:0] Reg2;
wire [15:0] Reg3;
wire [15:0] Reg4;
wire [15:0] Reg5;
wire [15:0] Reg6;
//wire [15:0]EX_MEM_ALUout_JAL;
//wire [15:0] EX_MEM_ALUout_JRI;
//wire EX_MEM_COND;
wire sm_enable_latch,lm_enable_latch;

//wire [2:0] ID_EX_type;
//
//wire [15:0]EX_MEM_ALUout_latch;
////wire 16:0]MEM_WB_ALUout;
//wire [15:0]EX_MEM_ALUout;
////wire [16:0]MEM_WB_STORE_LATCH;
//
//wire [8:0] EX_MEM_IMMEDIATE_9_BIT_DATA_latch;


wire [15:0] ID_EX_PC;
wire [15:0] ID_EX_IMM_latch;
wire [15:0] EX_MEM_ALUout_BEQ;
wire [15:0]IF_ID_PC,EX_MEM_PC,MEM_WB_PC;
wire [8:0] ID_EX_IMMEDIATE_9_BIT_DATA_latch;



mips_32 mips(clk,PC,ID_EX_PC,IF_ID_PC,EX_MEM_PC,MEM_WB_PC,ID_EX_IMMEDIATE_9_BIT_DATA_latch,Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6);

initial begin 

clk=1'b1;

end

always #10 clk=!clk;

initial begin 

//for(k=0;k<7;k=k+1) 
//	mips.Reg[k] <=k;

mips.Reg[0] =1;
mips.Reg[1] =2;
mips.Reg[2] =2;
mips.Reg[3] =3;
mips.Reg[4] =4;
mips.Reg[5] =5;
mips.Reg[6] =6;





//mips.mem[0]  = 16'h3000;         // lhi r0,0
//mips.mem[1]  = 16'h3201;			// lhi r1,128
//mips.mem[2]  = 16'h3401;			// lhi r2,128
//
////mips.mem[3] =  16'h829f;         // branch instruction
//        
//mips.mem[3]  = 16'h3603;			// lhi r3,384
//mips.mem[4]  = 16'h3804;			// lhi r4,512
//mips.mem[5]  = 16'h3a02;			// lhi r5,256
//mips.mem[6]  = 16'h3c01;			// lhi r6,128
//mips.mem[7]  = 16'hb00f;
//mips.mem[7]  = 16'h1298;        // add r1,r2,r3
//mips.mem[8]  = 16'h129b;        // adl r1,r2,r3
//mips.mem[9]  = 16'h0281;		  // ADI r1,r2,Imm
//mips.mem[10] = 16'h558f;        // sw ra,rb,Imm
//mips.mem[11] = 16'h478f;        // lw ra,rb,Imm
//mips.mem[12] = 16'hf000;        // 
//mips.mem[13] = 16'he000;  
//mips.mem[14] = 16'h9000;   
//mips.mem[15]  = 16'h3000;         // lhi r0,0
//mips.mem[16]  = 16'h3201;			// lhi r1,128
//mips.mem[17]  = 16'h3401;			// lhi r2,128   

//mips.mem[14] = 16'hc0ff;        
//mips.mem[15] = 16'hb0ff;        
//

//mips.mem[3] = 16'h904c;    // jal instruction
//mips.mem[7] =  16'h805f;         // branch instruction  beq r0,r1,31


mips.mem[0] =16'h3002;  
mips.mem[1] = 16'h3202;
mips.mem[2] = 16'h3502;
mips.mem[3]  = 16'h3603;			// lhi r3,384
mips.mem[4]  = 16'h3804;			// lhi r4,512
mips.mem[5]  = 16'h3a02;			// lhi r5,256
mips.mem[6]  = 16'h3c01;			// lhi r6,128
mips.mem[7] = 16'h904c;    // jal instruction 1001 0000 0100 1100   7+76=83
mips.mem[39] = 16'h3000;
           
//mips.mem[7] = 16'hd0ff;  
//mips.mem[8] = 16'hc0ff;
//mips.mem[4]  = 16'h3000;         // lhi r0,0
//mips.mem[5]  = 16'h3201;			// lhi r1,128
//mips.mem[6]  = 16'h3401;			// lhi r2,128
//mips.mem[80]  = 16'h3000;         // lhi r0,0
//mips.mem[81]  = 16'h3201;			// lhi r1,128
//mips.mem[82]  = 16'h3401;			// lhi r2,128

mips.taken_branch=1'b0;
mips.PC = 16'd0;

//for(k=0;k<6;k=k+1) 
//$display(k,mips.Reg[k]);


end
endmodule
