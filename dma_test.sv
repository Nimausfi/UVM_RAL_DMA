//1. dma_model_base_test
//2. dma_reg_test

////	1. dma_model_base_test
`include "dma_env.sv"
class dma_model_base_test extends uvm_test;

  `uvm_component_utils(dma_model_base_test)
  
  dma_model_env env;

  function new(string name = "dma_model_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = dma_model_env::type_id::create("env", this);
  endfunction : build_phase
  
  virtual function void end_of_elaboration();
    print();
  endfunction

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 

endclass : dma_model_base_test

////	2. dma_reg_test
class dma_reg_test extends dma_model_base_test;

  `uvm_component_utils(dma_reg_test)
  
  dma_reg_seq reg_seq;

  function new(string name = "dma_reg_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sequence
    reg_seq = dma_reg_seq::type_id::create("reg_seq");
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
      if ( !reg_seq.randomize() ) `uvm_error("", "Randomize failed")
      // Setting sequence in reg_seq
      reg_seq.regmodel       = env.regmodel;
      reg_seq.starting_phase = phase;
      reg_seq.start(env.dma_agnt.sequencer); 
    phase.drop_objection(this);
    
    // set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : dma_reg_test