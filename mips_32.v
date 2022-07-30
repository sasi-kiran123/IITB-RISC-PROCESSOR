module mips_32(clk,PC,ID_EX_PC,IF_ID_PC,EX_MEM_PC,MEM_WB_PC,ID_EX_IMMEDIATE_9_BIT_DATA_latch,Reg0,Reg1,Reg2,Reg3,Reg4,Reg5,Reg6);
input clk;
output reg [15:0]PC;

//output reg[15:0]PC_BEQ;

reg [15:0]IF_ID_NPC,IF_ID_IR;
 

output reg [15:0]IF_ID_PC,EX_MEM_PC,MEM_WB_PC;
output reg [15:0]ID_EX_PC;
 
reg [15:0]IF_ID;

reg [15:0]ID_EX_A,ID_EX_IMM,ID_EX_IR,ID_EX_NPC;

 reg [15:0]ID_EX_B,EX_MEM_B;
 
 reg [15:0]ID_EX_IMM_latch;
reg [5:0] ID_EX_type_latch;
reg [15:0] ID_EX_AR1,ID_EX_AR2;
reg [15:0] ID_EX_IR_latch;
output reg [8:0] ID_EX_IMMEDIATE_9_BIT_DATA_latch;
 reg [8:0] EX_MEM_IMMEDIATE_9_BIT_DATA_latch;

reg [5:0]ID_EX_type;
reg [5:0] EX_MEM_type,MEM_WB_type;

reg [15:0]EX_MEM_IR,EX_MEM_AR3,EX_MEM_AR1;

 reg EX_MEM_COND;
 
// reg clear_signal=1'b0;
 
 reg [15:0]EX_MEM_ALUout;
 reg [15:0]EX_MEM_ALUout_latch;
  reg[15:0] EX_MEM_ALUout_BEQ;
  reg [15:0]EX_MEM_ALUout_JAL;
reg [15:0]EX_MEM_ALUout_JLR;
 reg [15:0] EX_MEM_ALUout_JRI;


reg [15:0]MEM_WB_IR;

 reg [15:0]MEM_WB_ALUout;
 reg [15:0]MEM_WB_ALUout_latch;
 reg [15:0] MEM_WB_AR3;

reg [15:0] Reg [0:6];										
reg [15:0] mem [0:1023];
         
reg [15:0]data_memory[0:255];            

reg [8:0] ID_EX_IMMEDIATE_9_BIT_DATA;

reg write_enable,read_enable;

reg write_enable_latch,read_enable_latch;

reg [15:0] ID_EX_C,ID_EX_AR3;

reg sa_enable,la_enable;

 reg sa_enable_latch,la_enable_latch;

reg sm_enable, lm_enable;

reg is_jal,is_jlr,is_jri;

 reg sm_enable_latch, lm_enable_latch;

 reg [15:0] MEM_WB_ALUout_la[0:6];
 reg [15:0] MEM_WB_ALUout_la_latch[0:6];
 
 reg [15:0] MEM_WB_ALUout_lm[0:6];
 reg [15:0] MEM_WB_ALUout_lm_latch[0:6];


 reg [15:0]MEM_WB_STORE_LATCH;
 
reg disable_add;

output reg [15:0] Reg0;
output reg [15:0] Reg1;
output reg [15:0] Reg2;
output reg [15:0] Reg3;
output reg [15:0] Reg4;
output reg [15:0] Reg5;
output reg [15:0] Reg6;
	
    

parameter RR_alu=6'd0,load=6'd1,store=6'd2,branch=6'd3,adc=6'd4,adz=6'd5,ndu=6'd6,ndc=6'd7,adl=6'd8,ndz=6'd9,adi=6'd10,lhi=6'd11,sa=6'd12,la=6'd13,lm=6'd14,sm=6'd15,
beq=6'd16,jal=6'd17,jlr=6'd18,jri=6'd19;


reg CARRY_FLAG=1'b0, ZERO_FLAG=1'b0;

reg taken_branch;


 //IF_stage  --- Fetching the instruction  and pc always points to next instruction.
always @(posedge clk)                                                
 begin 
 
 
     if(EX_MEM_COND ) 
	  begin
				PC<= EX_MEM_ALUout_BEQ;

	  end
	  
	 else   if(is_jal==1'b1&& IF_ID_IR[15:12]==4'd9) 
	  begin 	
				PC<=EX_MEM_PC +{7'd0,ID_EX_IMMEDIATE_9_BIT_DATA_latch}; 
				
		end
		
		
		else if(is_jlr==1'b1 && ID_EX_IR_latch[15:12] ==4'd10) 
		begin 
				PC <=ID_EX_AR2;
		end
		
		else if(is_jri==1'b1 && ID_EX_IR_latch[15:12] == 4'd11) 
		begin 
				PC <=ID_EX_AR3 + {7'd0,ID_EX_IMMEDIATE_9_BIT_DATA_latch};
		end
		
		
	else begin 
				PC        <=PC+1;
				IF_ID  <=mem[PC];
				taken_branch<=1'b0;
		end
		
end



// instruction fetch to instruction decode stage



always @(posedge clk) begin 

 

IF_ID_IR <= IF_ID;
IF_ID_PC <= PC;
//end
//
//else 
//IF_ID_IR <= 16'd0;
//IF_ID_PC <= 16'd0;

end





// instruction decoding



always @(*) begin 

if(IF_ID_IR[15:12]==4'd1 && IF_ID_IR[1:0] == 2'd0 ) 
 
 ID_EX_type <= RR_alu;
 
else if(IF_ID_IR[15:12] == 4'd1 && IF_ID_IR[1:0] == 2'd2) 

ID_EX_type <= adc;


else if(IF_ID_IR[15:12] == 4'd1 && IF_ID_IR[1:0] == 2'd1) 

ID_EX_type <= adz;

else if(IF_ID_IR[15:12] == 4'd1 && IF_ID_IR[1:0] == 2'd3) 

ID_EX_type <= adl;

else if(IF_ID_IR[15:12] == 4'd2 && IF_ID_IR[1:0] == 2'd0) 

ID_EX_type <= ndu;

else if(IF_ID_IR[15:12] == 4'd2 && IF_ID_IR[1:0] == 2'd2) 

ID_EX_type <= ndc;

else if(IF_ID_IR[15:12] == 4'd2 && IF_ID_IR[1:0] == 2'd1) 

ID_EX_type <=ndz;

else if(IF_ID_IR[15:12] ==4'd0) 

ID_EX_type<= adi;

else if(IF_ID_IR[15:12] == 4'd4) 

ID_EX_type <= load;	 
	 
else if(IF_ID_IR[15:12] == 4'd5) 

ID_EX_type <=store;

else if(IF_ID_IR[15:12] == 4'd3) 

ID_EX_type <=lhi;

else if(IF_ID_IR[15:12] == 4'd15)

ID_EX_type <=sa;

else if(IF_ID_IR[15:12] == 4'd14) 

ID_EX_type <=la;


else if(IF_ID_IR[15:12] == 4'd13) 

ID_EX_type  <=sm;

else if(IF_ID_IR[15:12] ==4'd12) 

ID_EX_type <=lm;


else if(IF_ID_IR[15:12] ==4'd8) 

ID_EX_type <=beq;

else if(IF_ID_IR[15:12] == 4'd9) 

ID_EX_type <=jal;

else if(IF_ID_IR[15:12] == 4'd10)

ID_EX_type <= jlr;

else if(IF_ID_IR[15:12] == 4'd11) 

ID_EX_type <= jri;

		 
		 

ID_EX_NPC <= IF_ID_NPC;
ID_EX_A   <= Reg[IF_ID_IR[8:6]];
ID_EX_B 	 <= Reg[IF_ID_IR[5:3]];
ID_EX_IMM <= { {10{IF_ID_IR[5]}} ,{IF_ID_IR[5:0]}};
ID_EX_IR  <= IF_ID_IR;

ID_EX_IMMEDIATE_9_BIT_DATA <= IF_ID_IR[8:0] ;

ID_EX_C   <= Reg[IF_ID_IR[11:9]];




end 


// instruction decoder to execution stage latch 


always@(posedge clk) 
begin



ID_EX_type_latch <=ID_EX_type;
ID_EX_AR1        <=ID_EX_A;
ID_EX_AR2        <=ID_EX_B;
ID_EX_IMM_latch  <=ID_EX_IMM;
ID_EX_IR_latch   <=ID_EX_IR;
ID_EX_IMMEDIATE_9_BIT_DATA_latch <= ID_EX_IMMEDIATE_9_BIT_DATA;
ID_EX_AR3        <=ID_EX_C;
ID_EX_PC  <= IF_ID_PC;



//
//else   begin 
//ID_EX_type_latch <=3'd0;
//ID_EX_AR1        <=3'd0;
//ID_EX_AR2        <=3'd0;
//ID_EX_IMM_latch  <=16'd0;
//ID_EX_IR_latch   <=16'd0;
//ID_EX_IMMEDIATE_9_BIT_DATA_latch <= 9'd0;
//ID_EX_AR3        <=9'd0;
//ID_EX_PC  <= IF_ID_PC;
//
//end


end





// execution or memory calculation stage


always @(*) begin 



case(ID_EX_type_latch) 

RR_alu,adc,adz : begin 
	 
			{CARRY_FLAG,EX_MEM_ALUout} <= ID_EX_AR1  + ID_EX_AR2;

end




adl : begin 

			EX_MEM_ALUout <= ID_EX_AR1  + (ID_EX_AR2<<1'b1);

end

ndu,ndc,ndz : begin 

		{CARRY_FLAG,	EX_MEM_ALUout} <= ~(ID_EX_AR1  & ID_EX_AR2);

end 


adi : begin 

			EX_MEM_ALUout <=   ID_EX_AR1 + ID_EX_IMM_latch;
end 


lhi : begin

				EX_MEM_ALUout <= {ID_EX_IMMEDIATE_9_BIT_DATA_latch,7'd0};
end

store : begin 


				EX_MEM_ALUout <=   ID_EX_AR1 + ID_EX_IMM_latch;
				write_enable  <=1'b1;
				read_enable   <=1'b0;
		end
		
load : begin 
				EX_MEM_ALUout <=   ID_EX_AR1 + ID_EX_IMM_latch;
				read_enable   <= 1'b1;
				write_enable  <= 1'b0;
		end


		
		
sa : begin

				sa_enable     <=1'b1;
				la_enable     <=1'b0;
end


la : begin
				la_enable     <=1'b1;
				sa_enable     <=1'b0;

end            


sm : begin
				sm_enable <=1'b1;
				lm_enable <=1'b0;
	end
	
lm : begin 
				lm_enable <=1'b1;
				sm_enable <=1'b0;
	end 
	

beq : begin 
				EX_MEM_COND  <= (ID_EX_AR1==ID_EX_AR3)?1'b1 :1'b0;
				EX_MEM_ALUout_BEQ <= ID_EX_PC +ID_EX_IMM_latch;

				
end

jal: begin 
				is_jal<=1'b1;
	  end
	  
	  
jlr : begin
           is_jlr <=1'b1;
			  EX_MEM_ALUout_JLR <= PC+1'b1;
			  
	   end
		

jri: begin
			is_jri <=1'b1;
			
		end
		
	  
	  
	  
endcase	




end


 //execution stage to memory stage


always @(posedge clk) begin 
EX_MEM_B    <= ID_EX_AR2;
EX_MEM_IR     <=ID_EX_IR_latch;
EX_MEM_type <= ID_EX_type_latch;

EX_MEM_ALUout_latch <= EX_MEM_ALUout;
write_enable_latch  <=write_enable;
read_enable_latch   <=read_enable;
sa_enable_latch     <= sa_enable;
la_enable_latch     <= la_enable;
EX_MEM_PC           <= ID_EX_PC;

sm_enable_latch     <= sm_enable;
lm_enable_latch     <= lm_enable;
EX_MEM_IMMEDIATE_9_BIT_DATA_latch <=ID_EX_IMMEDIATE_9_BIT_DATA_latch;
EX_MEM_AR3          <= ID_EX_AR3;
EX_MEM_AR1          <= ID_EX_AR1;
end










// Memory stage 

always @(*) begin 
	if(write_enable_latch==1'b1) 
	
		data_memory[EX_MEM_ALUout_latch] <= Reg[EX_MEM_IR[11:9]];
		
		
	 if(read_enable_latch==1'b1) 
		
		MEM_WB_ALUout                    <= data_memory[EX_MEM_ALUout_latch];
		
	 if(sa_enable_latch == 1'b1) begin
	   
		data_memory[EX_MEM_AR3]      <= Reg[6];
		data_memory[EX_MEM_AR3+3'd1] <= Reg[5];
		data_memory[EX_MEM_AR3+3'd2] <= Reg[4];
		data_memory[EX_MEM_AR3+3'd3] <= Reg[3];
		data_memory[EX_MEM_AR3+3'd4] <= Reg[2];
		data_memory[EX_MEM_AR3+3'd5] <= Reg[1];
		data_memory[EX_MEM_AR3+3'd6] <= Reg[0];
		
		end

		
	 if(la_enable_latch == 1'b1) begin
	   
		 MEM_WB_ALUout_la[EX_MEM_IR[11:9]]<=data_memory[EX_MEM_AR3] ;
	    MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd1]<=data_memory[EX_MEM_AR3+3'd1];
	    MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd2]<=data_memory[EX_MEM_AR3+3'd2];
		 MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd3]<=data_memory[EX_MEM_AR3+3'd3];
		 MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd4]<=data_memory[EX_MEM_AR3+3'd4];
		 MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd5]<=data_memory[EX_MEM_AR3+3'd5];
	    MEM_WB_ALUout_la[EX_MEM_IR[11:9]+3'd6]<=data_memory[EX_MEM_AR3+3'd6];
		
		end

		
		if(sm_enable_latch ==1'b1) begin
		
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[0]==1'b1)              data_memory[EX_MEM_AR3]      <= Reg[0];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[1]==1'b1)              data_memory[EX_MEM_AR3+3'd1] <= Reg[1];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[2]==1'b1) 					data_memory[EX_MEM_AR3+3'd2] <= Reg[2];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[3]==1'b1) 					data_memory[EX_MEM_AR3+3'd3] <= Reg[3];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[4]==1'b1) 					data_memory[EX_MEM_AR3+3'd4] <= Reg[4];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[5]==1'b1) 					data_memory[EX_MEM_AR3+3'd5] <= Reg[5];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[6]==1'b1) 					data_memory[EX_MEM_AR3+3'd6] <= Reg[6];
																				
		end
		
		
		if(lm_enable_latch ==1'b1) begin
		
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[0]==1'b1)              MEM_WB_ALUout_lm[EX_MEM_AR3]     <=data_memory[EX_MEM_AR3] ;
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[1]==1'b1)             	MEM_WB_ALUout_lm[EX_MEM_AR3+3'd1]<=data_memory[EX_MEM_AR3+3'd1];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[2]==1'b1) 					MEM_WB_ALUout_lm[EX_MEM_AR3+3'd2]<=data_memory[EX_MEM_AR3+3'd2];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[3]==1'b1) 					MEM_WB_ALUout_lm[EX_MEM_AR3+3'd3]<=data_memory[EX_MEM_AR3+3'd3];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[4]==1'b1) 					MEM_WB_ALUout_lm[EX_MEM_AR3+3'd4]<=data_memory[EX_MEM_AR3+3'd4];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[5]==1'b1) 					MEM_WB_ALUout_lm[EX_MEM_AR3+3'd5]<=data_memory[EX_MEM_AR3+3'd5];
		if(EX_MEM_IMMEDIATE_9_BIT_DATA_latch[6]==1'b1) 					MEM_WB_ALUout_lm[EX_MEM_AR3+3'd6]<=data_memory[EX_MEM_AR3+3'd6];
		
		end
		
		
		
		
		
end



 //memory stage  to write back stage 

always @(posedge clk) begin 

MEM_WB_IR     <= EX_MEM_IR;
MEM_WB_type   <= EX_MEM_type;
MEM_WB_STORE_LATCH  <=  MEM_WB_ALUout;
MEM_WB_ALUout_latch <= EX_MEM_ALUout_latch;
MEM_WB_ALUout_la_latch[EX_MEM_AR3] <=  MEM_WB_ALUout_la[EX_MEM_AR3];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd1] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd1];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd2] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd2];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd3] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd3];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd4] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd4];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd5] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd5];
MEM_WB_ALUout_la_latch[EX_MEM_AR3+3'd6] <=  MEM_WB_ALUout_la[EX_MEM_AR3+3'd6];

MEM_WB_PC  <=EX_MEM_PC;
MEM_WB_AR3 <= EX_MEM_AR3;

MEM_WB_ALUout_lm_latch[EX_MEM_AR3]      <=  MEM_WB_ALUout_lm[EX_MEM_AR3];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd1] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd1];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd2] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd2];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd3] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd3];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd4] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd4];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd5] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd5];
MEM_WB_ALUout_lm_latch[EX_MEM_AR3+3'd6] <=  MEM_WB_ALUout_lm[EX_MEM_AR3+3'd6];
end




// write back stage 


always @(posedge clk) begin 


case(MEM_WB_type) 






RR_alu,ndu,adi: begin 

if(MEM_WB_IR[11:9]==3'd0)  begin 

					Reg0<=MEM_WB_ALUout_latch;
					Reg[0]<=MEM_WB_ALUout_latch;


end


else if(MEM_WB_IR[11:9]==3'd1) begin 

					Reg1<=MEM_WB_ALUout_latch;
					Reg[1]<=MEM_WB_ALUout_latch;

end

else if(MEM_WB_IR[11:9]==3'd2) begin 
					Reg2<=MEM_WB_ALUout_latch;
					Reg[2]<=MEM_WB_ALUout_latch;

end


else if(MEM_WB_IR[11:9]==3'd3) begin
					Reg3<=MEM_WB_ALUout_latch;
					Reg[3]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd4) begin 
					Reg4<=MEM_WB_ALUout_latch;
					Reg[4]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd5) begin 
					Reg5<=MEM_WB_ALUout_latch;
					Reg[5]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd6) begin
					Reg6<=MEM_WB_ALUout_latch;
					Reg[6]<=MEM_WB_ALUout_latch;
					
end 


end 





adl: begin 

if(MEM_WB_IR[11:9]==3'd0) begin
					Reg0<=MEM_WB_ALUout_latch;
					Reg[0]<=MEM_WB_ALUout_latch;
					
end

else if(MEM_WB_IR[11:9]==3'd1) begin
					Reg1<=MEM_WB_ALUout_latch;
					Reg[1]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd2) begin
					Reg2<=MEM_WB_ALUout_latch;
					Reg[2]<=MEM_WB_ALUout_latch;
					
end



else if(MEM_WB_IR[11:9]==3'd3) begin
					Reg3<=MEM_WB_ALUout_latch;
					Reg[3]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd4) begin
					Reg4<=MEM_WB_ALUout_latch;
					Reg[4]<=MEM_WB_ALUout_latch;
				
end


else if(MEM_WB_IR[11:9]==3'd5) begin
					Reg5<=MEM_WB_ALUout_latch;
					Reg[5]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd6) begin
					Reg6<=MEM_WB_ALUout_latch;
					Reg[6]<=MEM_WB_ALUout_latch;
					
end


end 





load: begin 

if(MEM_WB_IR[11:9]==3'd0)  
					begin 
					Reg0<=MEM_WB_STORE_LATCH;
					Reg[0]<=MEM_WB_STORE_LATCH;

					end

else if(MEM_WB_IR[11:9]==3'd1)
					begin
					 Reg1<=MEM_WB_STORE_LATCH;
					 Reg[1]<=MEM_WB_STORE_LATCH;
					end

else if(MEM_WB_IR[11:9]==3'd2)
					begin
					 Reg2<=MEM_WB_STORE_LATCH;
					 Reg[2]<=MEM_WB_STORE_LATCH;
					end


else if(MEM_WB_IR[11:9]==3'd3)
					begin
					 Reg3<=MEM_WB_STORE_LATCH;
					 Reg[3]<=MEM_WB_STORE_LATCH;
					end


else if(MEM_WB_IR[11:9]==3'd4)
					begin
					 Reg4<=MEM_WB_STORE_LATCH;
					 Reg[4]<=MEM_WB_STORE_LATCH;

					 end

else if(MEM_WB_IR[11:9]==3'd5)
					begin
					 Reg5<=MEM_WB_STORE_LATCH;
					 Reg[5]<=MEM_WB_STORE_LATCH;
					end

else if(MEM_WB_IR[11:9]==3'd6)
					begin
					 Reg6<=MEM_WB_STORE_LATCH;
					Reg[6]<=MEM_WB_STORE_LATCH;

					end 

end




adc,ndc: begin 


if(CARRY_FLAG==1'B1) begin


if(MEM_WB_IR[11:9]==3'd0) begin
					Reg0<=MEM_WB_ALUout_latch;
					Reg[0]<=MEM_WB_ALUout_latch;

end




else if(MEM_WB_IR[11:9]==3'd1) begin
					Reg1<=MEM_WB_ALUout_latch;
					Reg[1]<=MEM_WB_ALUout_latch;
					
end

else if(MEM_WB_IR[11:9]==3'd2) begin
					Reg2<=MEM_WB_ALUout_latch;
					Reg[2]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd3) begin
					Reg3<=MEM_WB_ALUout_latch;
					Reg[3]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd4) begin
					Reg4<=MEM_WB_ALUout_latch;
					Reg[4]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd5) begin
					Reg5<=MEM_WB_ALUout_latch;
					Reg[5]<=MEM_WB_ALUout_latch;
				
end




else if(MEM_WB_IR[11:9]==3'd6) begin
					Reg6<=MEM_WB_ALUout_latch;
					Reg[6]<=MEM_WB_ALUout_latch;
					
end

end 


end




adz,ndz: begin 

if(MEM_WB_ALUout_latch ==32'd0) begin 

if(MEM_WB_IR[11:9]==3'd0) begin
					Reg0<=MEM_WB_ALUout_latch;
					Reg[0]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd1) begin
					Reg1<=MEM_WB_ALUout_latch;
					Reg[1]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd2) begin
					Reg2<=MEM_WB_ALUout_latch;
					Reg[2]<=MEM_WB_ALUout_latch;
					
end

else if(MEM_WB_IR[11:9]==3'd3) begin
					Reg3<=MEM_WB_ALUout_latch;
					Reg[3]<=MEM_WB_ALUout_latch;
					
end


else if(MEM_WB_IR[11:9]==3'd4) begin
					Reg4<=MEM_WB_ALUout_latch;
					Reg[4]<=MEM_WB_ALUout_latch;
				
end


else if(MEM_WB_IR[11:9]==3'd5) begin
					Reg5<=MEM_WB_ALUout_latch;
					Reg[5]<=MEM_WB_ALUout_latch;
				
end


else if(MEM_WB_IR[11:9]==3'd6) begin
					Reg6<=MEM_WB_ALUout_latch;
					Reg[6]<=MEM_WB_ALUout_latch;
				
end


end 
end






lhi  : begin
 
if(MEM_WB_IR[11:9] == 3'd0 )
		begin 
		Reg0 <= MEM_WB_ALUout_latch;
		Reg[0]<=MEM_WB_ALUout_latch;
		end

else if(MEM_WB_IR[11:9] ==3'd1) 
			begin 
			Reg1 <=MEM_WB_ALUout_latch;
			Reg[1]<=MEM_WB_ALUout_latch;
			end
			
			
			
else if(MEM_WB_IR[11:9] ==3'd2)
			begin 
			Reg2 <=MEM_WB_ALUout_latch;
			Reg[2]<=MEM_WB_ALUout_latch;
			end
			
			

else if(MEM_WB_IR[11:9] ==3'd3) 
			begin 
			Reg3 <=MEM_WB_ALUout_latch;
			Reg[3]<=MEM_WB_ALUout_latch;
			end

else if(MEM_WB_IR[11:9] ==3'd4) 
			begin 
			Reg4 <=MEM_WB_ALUout_latch;
			Reg[4]<=MEM_WB_ALUout_latch;
			end
			
			
			
			
else if(MEM_WB_IR[11:9] ==3'd5) begin 
			Reg5 <=MEM_WB_ALUout_latch;
			Reg[5]<=MEM_WB_ALUout_latch;
			end
			
			
			

else if(MEM_WB_IR[11:9] ==3'd6)
begin
Reg6 <=MEM_WB_ALUout_latch;			
Reg[6] <=MEM_WB_ALUout_latch;
end



end


la : begin

if(MEM_WB_IR[11:9] == 3'd0 | MEM_WB_IR[11:9] ==3'd1 |MEM_WB_IR[11:9] ==3'd2 | MEM_WB_IR[11:9] ==3'd3 | MEM_WB_IR[11:9] ==3'd4 | MEM_WB_IR[11:9] ==3'd5 | MEM_WB_IR[11:9] ==3'd6)
		begin 
		Reg0 <= MEM_WB_ALUout_la_latch[0];
		Reg[0]<=MEM_WB_ALUout_la_latch[0];
		


			Reg1 <=MEM_WB_ALUout_la_latch[1];
			Reg[1]<=MEM_WB_ALUout_la_latch[1];
		
			
			
			

			Reg2 <=MEM_WB_ALUout_la_latch[2];
			Reg[2]<=MEM_WB_ALUout_la_latch[2];
		
			
			


			Reg3 <=MEM_WB_ALUout_la_latch[3];
			Reg[3]<=MEM_WB_ALUout_la_latch[3];
			

			Reg4 <=MEM_WB_ALUout_la_latch[4];
			Reg[4]<=MEM_WB_ALUout_la_latch[4];
			
			
			
			
			
			Reg5 <=MEM_WB_ALUout_la_latch[5];
			Reg[5]<=MEM_WB_ALUout_la_latch[5];
			
			
			
			


Reg6 <=MEM_WB_ALUout_la_latch[6];			
Reg[6] <=MEM_WB_ALUout_la_latch[6];
end

end





lm : begin

if(MEM_WB_IR[11:9] == 3'd0 | MEM_WB_IR[11:9] ==3'd1 |MEM_WB_IR[11:9] ==3'd2 | MEM_WB_IR[11:9] ==3'd3 | MEM_WB_IR[11:9] ==3'd4 | MEM_WB_IR[11:9] ==3'd5 | MEM_WB_IR[11:9] ==3'd6)
		begin 
		Reg0 <= MEM_WB_ALUout_lm_latch[MEM_WB_AR3];
		Reg[0]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3];
		


			Reg1 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd1];
			Reg[1]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd1];
		
			
			
			

			Reg2 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd2];
			Reg[2]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd2];
		
			
			


			Reg3 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd3];
			Reg[3]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd3];
			

			Reg4 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd4];
			Reg[4]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd4];
			
			
			
			
			
			Reg5 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd5];
			Reg[5]<=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd5];
			
			
			
			


Reg6 <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd6];			
Reg[6] <=MEM_WB_ALUout_lm_latch[MEM_WB_AR3+3'd6];
end

end







jal  : begin
 
if(MEM_WB_IR[11:9] == 3'd0 )
		begin 
		Reg0 <= MEM_WB_PC;
		Reg[0]<=MEM_WB_PC;
		end

else if(MEM_WB_IR[11:9] ==3'd1) 
			begin 
			Reg1 <=MEM_WB_PC;
			Reg[1]<=MEM_WB_PC;
			end
			
			
			
else if(MEM_WB_IR[11:9] ==3'd2)
			begin 
			Reg2 <=MEM_WB_PC;
			Reg[2]<=MEM_WB_PC;
			end
			
			

else if(MEM_WB_IR[11:9] ==3'd3) 
			begin 
			Reg3 <=MEM_WB_PC;
			Reg[3]<=MEM_WB_PC;
			end

else if(MEM_WB_IR[11:9] ==3'd4) 
			begin 
			Reg4 <=MEM_WB_PC;
			Reg[4]<=MEM_WB_PC;
			end
			
			
			
			
else if(MEM_WB_IR[11:9] ==3'd5) begin 
			Reg5 <=MEM_WB_PC;
			Reg[5]<=MEM_WB_PC;
			end
			
			
			

else if(MEM_WB_IR[11:9] ==3'd6)
begin
Reg6 <=MEM_WB_PC;			
Reg[6] <=MEM_WB_PC;
end



end



jlr  : begin
 
if(MEM_WB_IR[11:9] == 3'd0 )
		begin 
		Reg0 <= MEM_WB_PC;
		Reg[0]<=MEM_WB_PC;
		end

else if(MEM_WB_IR[11:9] ==3'd1) 
			begin 
			Reg1 <=MEM_WB_PC;
			Reg[1]<=MEM_WB_PC;
			end
			
			
			
else if(MEM_WB_IR[11:9] ==3'd2)
			begin 
			Reg2 <=MEM_WB_PC;
			Reg[2]<=MEM_WB_PC;
			end
			
			

else if(MEM_WB_IR[11:9] ==3'd3) 
			begin 
			Reg3 <=MEM_WB_PC;
			Reg[3]<=MEM_WB_PC;
			end

else if(MEM_WB_IR[11:9] ==3'd4) 
			begin 
			Reg4 <=MEM_WB_PC;
			Reg[4]<=MEM_WB_PC;
			end
			
			
			
			
else if(MEM_WB_IR[11:9] ==3'd5) begin 
			Reg5 <=MEM_WB_PC;
			Reg[5]<=MEM_WB_PC;
			end
			
			
			

else if(MEM_WB_IR[11:9] ==3'd6)
begin
Reg6 <=MEM_WB_PC;			
Reg[6] <=MEM_WB_PC;
end



end


endcase

end

endmodule






















