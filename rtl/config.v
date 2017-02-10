module config,
	input wire clk,
	input wire rst_n,
	input wire [31:0] addr,
	input wire we,
	input wire [31:0] wdata,
	output reg [31:0] rdata,
	output reg [31:0] divFactor_1,
	output reg [31:0] divFactor_2,
	output reg [31:0] divFactor_3,
	output reg [31:0] divFactor_4,
	output reg heartbeat,
	input wire timeout,
	output reg we_out
);
endmodule

parameter CONTROL     = 32'b0;
parameter STATUS     = 32'h4;
parameter DIVFACTOR_1 = 32'h8;
parameter DIVFACTOR_2 = 32'hc;
parameter DIVFACTOR_3 = 32'h10;
parameter DIVFACTOR_4 = 32'h14;
always @(posedge clk or negedge rst_n)
begin
        if(!rst_n)begin
	divFactor_1<=32'hff,
	divFactor_2<=32'hff,
	divFactor_3<=32'hff,
	divFactor_4<=32'hff,
	 heartbeat<=1'b0,
	 timeout<=1'b0,
	 we_out<=1'b0;
        end
        else begin 
                heartbeat<=1'b0;
                        we_out<=1'b0;
                        if(we)begin
                                we_out<=1'b1;
                                case(addr)
                                        CONTROL: heartbeat<=wdata[0];
                                        DIVFACTOR_1:divFactor_1<=wdata;
                                        DIVFACTOR_2:divFactor_2<=wdata;
                                        DIVFACTOR_3:divFactor_3<=wdata;
                                        DIVFACTOR_4:divFactor_4<=wdata;
                                endcase

                        end
                end
        end
        always @(*)begin
                rdata=32'b0;
                if(!we)begin
                        case (addr)
                                CONTROL: rdata[0]=heartbeat;
                                STATUS: rdata[0]=timeout;
                                DIVFACTOR_1: rdata=divFactor_1;
                                DIVFACTOR_2: rdata=divFactor_2;
                                DIVFACTOR_3: rdata=divFactor_3;
                                DIVFACTOR_4: rdata<=divFactor_4;
                        endcase
                end
        end
        endmodule
