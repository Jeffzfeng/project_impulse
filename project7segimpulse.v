module project7segimpulse(HEX0,HEX1,HEX2,HEX3,GPIO_1,LEDR,KEY,LEDG,CLOCK_50);
input CLOCK_50;
input [0:0] KEY;
input [1:0] GPIO_1;
output [6:0] LEDG;
output [11:0] LEDR;
wire [11:0] pulse;
wire [11:0] power_data;
wire [6:0] z,x,y,w,v,u;
output [6:0] HEX0, HEX1, HEX2, HEX3;



counter sup(GPIO_1[0],GPIO_1[1],pulse);
power_counter yo(KEY[0],pulse,power_data);
FSM_test digit1(CLOCK_50,power_data[2:0],0,z);
FSM_test digit2(CLOCK_50,power_data[5:3],0,y);
FSM_test digit3(CLOCK_50,power_data[8:6],0,x);
FSM_test digit4(CLOCK_50,power_data[11:9],0,w);

assign LEDR = power_data;
assign HEX0 = z;
assign HEX1 = y;
assign HEX2 = x;
assign HEX3 = w;


endmodule


module frequency_divider ( clock , pulse , switch ) ;
input clock ;
output pulse ;
input [1:0]switch ;
wire [27:0] speed ;



assign speed [27:0] = 28'd9999999;	// 1 HZ  Count is 49 , 999 , 999	

reg [27:0] counter ;
always@(posedge clock)
	begin
		if(pulse)
			counter <= 28'd0 ;
		else
			counter <= counter+1'b1 ;
	end
	assign pulse = ( counter==speed ) ;
	
endmodule






module counter(clock,sensor,pulse); // counts amount of pulses and stores it in pulse;

input sensor;
input clock;
output reg [11:0] pulse;

always@(posedge clock)
begin
if(clock==1)
pulse <= sensor;
end

endmodule



module power_counter(reset,pulse,data);

input reset;
input pulse;
output reg [11:0] data;

always@(posedge pulse or negedge reset)
begin
if(reset==0)
	data <= 0;
else if(pulse==1)
	data <= data + 1;
end

endmodule




module FSM_test(clock,pulse,enable,z);
input [2:0] pulse;
input enable;
input clock;
reg [3:0] current;
reg [3:0] next;
output reg [6:0] z;
	
parameter idle = 4'b0000, choose = 4'b0001, lightup_1 = 4'b0010, lightup_2 = 4'b0011, lightup_3 = 4'b0100, lightup_4 = 4'b0101, lightup_5 = 4'b0110, lightup_6 = 4'b0111, lightup_7 = 4'b1000, lightup_0 = 4'b1001;
	
always@(pulse[2:0], current, enable)
begin:les_go
	case(current)
		
		idle: if(!enable)				
				next = choose;
			else 
				next = idle;
	
		choose:        
					
					if(pulse==3'b000)
				next = lightup_0;
				   
					else if(pulse==3'b001)
				next = lightup_1;
					
					else if(pulse==3'b010)
				next = lightup_2;
				  
				  else if(pulse==3'b011)
				next = lightup_3;
				   
					else if(pulse==3'b100)
				next = lightup_4;
				    
					 else if(pulse==3'b101)
				next = lightup_5;
					
					else if(pulse==3'b110)
				next = lightup_6;
					
					else if(pulse==3'b111)
				next = lightup_7;
					else 
				next = lightup_0;
		
		
		lightup_0:
				next = idle;
				
		lightup_1: 
				next = idle;		
		
		lightup_2: 
				next = idle;
			
		lightup_3: 
				next = idle;
		
		lightup_4: 
				next = idle;
			
		lightup_5: 
				next = idle;	
		
		lightup_6: 
				next = idle;
		
		lightup_7:
				next = idle;
			
			
			default: 
				next = 4'bxxxx;
		endcase
	end
			


always@(posedge clock)
begin
	current <= idle;

if(clock==1)
	current <= next;
end
	


always@(current)
begin: output_sig
	case(current)

		choose: z =   7'b1111111;
		lightup_0: z = 7'b1000000;
		lightup_1: z = 7'b1111001;
		lightup_2: z = 7'b0100100;
		lightup_3: z = 7'b0110000;
		lightup_4: z = 7'b0011001;
		lightup_5: z = 7'b0010010;
		lightup_6: z = 7'b0000010;
		lightup_7: z = 7'b1111000;
		default: z =   7'b1111111;
		
	endcase
end

endmodule


