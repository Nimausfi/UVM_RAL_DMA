`include "dma_reg.sv"
`include "dma_reg_sequence.sv"
`include "dma_agent.sv"
`include "dma_adapter.sv"

class dma_model_env extends uvm_env;
  
  dma_agent      dma_agnt;
 
  dma_reg_model  regmodel;   
  dma_adapter    m_adapter;
  
  `uvm_component_utils(dma_model_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dma_agnt = dma_agent::type_id::create("dma_agnt", this);
    regmodel = dma_reg_model::type_id::create("regmodel", this);
    regmodel.build();
    m_adapter = dma_adapter::type_id::create("m_adapter",, get_full_name());
  endfunction : build_phase
  
  //// connect_phase - connecting regmodel sequencer and adapter with mem agent sequencer and adapter

  function void connect_phase(uvm_phase phase);
     
    regmodel.default_map.set_sequencer( .sequencer(dma_agnt.sequencer), .adapter(m_adapter) );
    regmodel.default_map.set_base_addr('h400);        
    //// regmodel.add_hdl_path("tbench_top.DUT");
  endfunction : connect_phase

endclass : dma_model_env