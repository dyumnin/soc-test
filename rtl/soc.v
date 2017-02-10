module soc(
input wire bus_clk,
input wire bus_rst_n,
input wire [31:0] bus_addr,
input wire [31:0] bus_wdata,
output wire [31:0] bus_rdata,
input wire  we,
input wire timer_clk,
input wire timer_rst_n
);
config config(
	.clk(clk),
	.rst_n(rst_n),
	.addr(addr),
	.we(we),
	.wdata(wdata),
	.rdata(rdata)
	.divFactor_1(divFactor_1),
	.divFactor_2(divFactor_2),
	.divFactor_3(divFactor_3),
	.divFactor_4(divFactor_4),
	.heartbeat(heartbeat),
	.timeout(timeout_sync),
	.we_out(we_out)
);

wordsync_s2f DivFactorSync1(
	.din(divFactor_1),
	.sclk(bus_clk),
	.srst_n(bus_rst_n),
	.sen(we_out),
	.dclk(timer_clk),
	.drst_n(timer_rst_n),
	.dout(divFactor_1_sync)
);
wordsync_s2f DivFactorSync2(
	.din(divFactor_2),
	.sclk(bus_clk),
	.srst_n(bus_rst_n),
	.sen(we_out),
	.dclk(timer_clk),
	.drst_n(timer_rst_n),
	.dout(divFactor_2_sync)
);
wordsync_s2f DivFactorSync3(
	.din(divFactor_3),
	.sclk(bus_clk),
	.srst_n(bus_rst_n),
	.sen(we_out),
	.dclk(timer_clk),
	.drst_n(timer_rst_n),
	.dout(divFactor_3_sync)
);

wordsync_s2f DivFactorSync4(
	.din(divFactor_4),
	.sclk(bus_clk),
	.srst_n(bus_rst_n),
	.sen(we_out),
	.dclk(timer_clk),
	.drst_n(timer_rst_n),
	.dout(divFactor_4_sync)
);

pulsesync timeoutSync(
.dclk(bus_clk,),
.drst_n(bus_rst_n),
.sclk(timer_clk),
.srst_n(timer_rst_n),
.pulse_in(timeout),
.pulse_out(timeout_sync)
);
pulsesync heartbeatsync(
.sclk(bus_clk,),
.srst_n(bus_rst_n),
.dclk(timer_clk),
.drst_n(timer_rst_n),
.pulse_in(heartbeat),
.pulse_out(heartbeat_sync)
);
timer timer1 (
	.clk(clk),
	.rst_n(rst_n),
	.divFactor(divFactor_1),
	.usec_clk(),
	.usec_pulse(usec_pulse_1),
	.msec_clk(),
	.msec_pulse(msec_pulse_1),
	.sec_clk(),
	.sec_pulse(sec_pulse_1)
);
timer timer2 (
	.clk(clk),
	.rst_n(rst_n),
	.divFactor(divFactor_2),
	.usec_clk(),
	.usec_pulse(usec_pulse_2),
	.msec_clk(),
	.msec_pulse(msec_pulse_2),
	.sec_clk(),
	.sec_pulse(sec_pulse_2)
);
timer timer3 (
	.clk(clk),
	.rst_n(rst_n),
	.divFactor(divFactor_3),
	.usec_clk(),
	.usec_pulse(usec_pulse_3),
	.msec_clk(),
	.msec_pulse(msec_pulse_3),
	.sec_clk(),
	.sec_pulse(sec_pulse_3)
);
timer timer4 (
	.clk(clk),
	.rst_n(rst_n),
	.divFactor(divFactor_4),
	.usec_clk(),
	.usec_pulse(usec_pulse_4),
	.msec_clk(),
	.msec_pulse(msec_pulse_4),
	.sec_clk(),
	.sec_pulse(sec_pulse_4)
);




watchdog watchdog(
	.clk(timer_clk),
	.rst_n(timer_rst_n),
	.heartbeat(heartbeat_sync),
	.sec_count(sec_count),
	.msec_count(msec_count),
	.usec_count(usec_count),
	.timeout(timeout)

);
endmodule
