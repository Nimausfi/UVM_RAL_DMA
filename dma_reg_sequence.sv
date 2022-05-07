//	Register Access Sequence
class dma_reg_seq extends uvm_sequence;

  `uvm_object_utils(dma_reg_seq)
  
  dma_reg_model regmodel;
    
  function new (string name = ""); 
    super.new(name);    
  endfunction
  
  task body;  
    uvm_status_e   status;
    uvm_reg_data_t incoming;
    bit [31:0]     rdata;
    
    if (starting_phase != null)
      starting_phase.raise_objection(this);
    
    //Write to the Registers
    regmodel.reg_intr.write(status, 32'h1234_1234);
    regmodel.reg_ctrl.write(status, 32'h1234_5678);
    regmodel.reg_io_addr.write(status, 32'h1234_9ABC);
    regmodel.reg_mem_addr.write(status, 32'h1234_DEF0);
    regmodel.reg_extra_info.write(status, 32'h1234_1011);
    
    //Read from the registers
    regmodel.reg_intr.read(status, rdata);
    regmodel.reg_ctrl.read(status, rdata);
    regmodel.reg_io_addr.read(status, rdata);
    regmodel.reg_mem_addr.read(status, rdata);
    regmodel.reg_extra_info.write(status, rdata);
      
    if (starting_phase != null)
      starting_phase.drop_objection(this);  
    
  endtask
endclass