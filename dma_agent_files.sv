/* 
This File Contains:
1. Sequence item -> dma_seq_item
2. Sequencer -> dma_sequencer
3. Sequences -> Sequences 
4. driver    -> dma_driver 
*/

class dma_seq_item extends uvm_sequence_item;

  rand bit [31:0] addr;
  rand bit       wr_en;
  rand bit [31:0] wdata;
       bit [31:0] rdata;

  `uvm_object_utils_begin(dma_seq_item)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(wr_en,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "dma_seq_item");
    super.new(name);
  endfunction
  
endclass

////2. dma_sequencer
class dma_sequencer extends uvm_sequencer#(dma_seq_item);

  `uvm_component_utils(dma_sequencer) 

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass


////3. dma_sequence's
//// dma_sequence - random stimulus 
class dma_sequence extends uvm_sequence#(dma_seq_item);
  
  `uvm_object_utils(dma_sequence)
  
  function new(string name = "dma_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(dma_sequencer)
  
  virtual task body();
   repeat(2) begin
    req = dma_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass

//// write_sequence - "write" type
class write_sequence extends uvm_sequence#(dma_seq_item);
  
  `uvm_object_utils(write_sequence)
   
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.wr_en==1;})
  endtask
endclass

//// read_sequence - "read" type
class read_sequence extends uvm_sequence#(dma_seq_item);
  
  `uvm_object_utils(read_sequence)
   
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.wr_en==0;})
  endtask
endclass

////	dma_driver
`define DRIV_IF vif.DRIVER.driver_cb

class dma_driver extends uvm_driver #(dma_seq_item);

  virtual dma_if vif;
  `uvm_component_utils(dma_driver)
    
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual dma_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  virtual task drive();
    `DRIV_IF.wr_en <= 0;
    @(posedge vif.DRIVER.clk);
    
    `DRIV_IF.addr <= req.addr;

    `DRIV_IF.valid <= 1;
    `DRIV_IF.wr_en <= req.wr_en;
    if(req.wr_en) begin //write operation
      `DRIV_IF.wdata <= req.wdata;
      @(posedge vif.DRIVER.clk);
    end
    else begin //read operation
      @(posedge vif.DRIVER.clk);
      `DRIV_IF.valid <= 0;
      @(posedge vif.DRIVER.clk);
      req.rdata = `DRIV_IF.rdata;
    end
    `DRIV_IF.valid <= 0;
    
  endtask : drive
endclass : dma_driver

class dma_monitor extends uvm_monitor;

  virtual dma_if vif;
  
  uvm_analysis_port #(dma_seq_item) item_collected_port;
  
  dma_seq_item trans_collected;

  `uvm_component_utils(dma_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dma_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.MONITOR.clk);
      wait(vif.monitor_cb.valid);
        trans_collected.addr = vif.monitor_cb.addr;
        trans_collected.wr_en = vif.monitor_cb.wr_en;
      
      if(vif.monitor_cb.wr_en) begin
        trans_collected.wr_en = vif.monitor_cb.wr_en;
        trans_collected.wdata = vif.monitor_cb.wdata;
        @(posedge vif.MONITOR.clk);
      end
      else begin
        @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        trans_collected.rdata = vif.monitor_cb.rdata;
      end
	  item_collected_port.write(trans_collected);
      end 
  endtask : run_phase

endclass : dma_monitor