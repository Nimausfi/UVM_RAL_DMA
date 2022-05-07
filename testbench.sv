import uvm_pkg::*;
`include "uvm_macros.svh"
`include "dma_interface.sv"
`include "dma_test.sv"

module tbench_top;

  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5 reset =0;
  end

  dma_if intf(clk,reset);
  
  DMA DUT (
    .clk(intf.clk),
    .reset(intf.reset),
    .addr(intf.addr),
    .wr_en(intf.wr_en),
    .valid(intf.valid),
    .wdata(intf.wdata),
    .rdata(intf.rdata)
   );
  
  //// passing the interface handle to lower heirarchy using set method 
  //// and enabling the wave dump
  initial begin 
    uvm_config_db#(virtual dma_if)::set(uvm_root::get(),"*","vif",intf);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  initial begin 
    run_test();
  end
  
endmodule