class intr extends uvm_reg;
  `uvm_object_utils(intr)
   
  rand uvm_reg_field status;
  rand uvm_reg_field mask;

  function new (string name = "intr");
    super.new(name,32,UVM_NO_COVERAGE);
  endfunction

  function void build; 
    
    // Create bitfield
    status = uvm_reg_field::type_id::create("status");   
    // Configure
    status.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(0), 
                     .access("RW"),  
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(1), 
                     .individually_accessible(0)); 
    // Below line is equivalen to above one   
    // status.configure(this, 32,       0,   "RW",   0,        0,        1,        1,      0); 
    //                  reg, bitwidth, lsb, access, volatile, reselVal, hasReset, isRand, fieldAccess
    
    mask = uvm_reg_field::type_id::create("mask");   
    mask.configure(.parent(this), 
                     .size(16), 
                     .lsb_pos(16), 
                     .access("RW"),  
                     .volatile(0), 
                     .reset(0), 
                     .has_reset(1), 
                     .is_rand(1), 
                     .individually_accessible(0));    
    endfunction
endclass

////	Register Class defination - ctrl
class ctrl extends uvm_reg;
  `uvm_object_utils(ctrl)
   
  rand uvm_reg_field start_dma;
  rand uvm_reg_field w_count;
  rand uvm_reg_field io_mem;
  rand uvm_reg_field reserved;

  function new (string name = "ctrl");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction

  function void build; 
    start_dma = uvm_reg_field::type_id::create("start_dma");   
    start_dma.configure(.parent(this), 
                        .size(1), 
                        .lsb_pos(0),  
                        .access("RW"),   
                        .volatile(0),  
                        .reset(0),  
                        .has_reset(1),  
                        .is_rand(1),  
                        .individually_accessible(0));  
    
    w_count = uvm_reg_field::type_id::create("w_count");   
    w_count.configure(.parent(this),  
                      .size(8),  
                      .lsb_pos(1),  
                      .access("RW"),   
                      .volatile(0),  
                      .reset(0),  
                      .has_reset(1),  
                      .is_rand(1),  
                      .individually_accessible(0));     
            
    io_mem = uvm_reg_field::type_id::create("io_mem");   
    io_mem.configure(.parent(this),  
                     .size(1),  
                     .lsb_pos(9),  
                     .access("RW"),    
                     .volatile(0),   
                     .reset(0),   
                     .has_reset(1),   
                     .is_rand(1),   
                     .individually_accessible(0));   
            
    reserved = uvm_reg_field::type_id::create("reserved");   
    reserved.configure(.parent(this),  
                       .size(22),  
                       .lsb_pos(10),  
                       .access("RW"),     
                       .volatile(0),    
                       .reset(0),    
                       .has_reset(1),    
                       .is_rand(1),    
                       .individually_accessible(0));        
    endfunction
endclass

////	Register Class defination - io_addr
class io_addr extends uvm_reg;
  `uvm_object_utils(io_addr)
   
  rand uvm_reg_field addr;
  
  function new (string name = "io_addr");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction

  function void build; 
    
    // Create bitfield
    addr = uvm_reg_field::type_id::create("addr");   
    // Configure
    addr.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

////	Register Class defination - mem_addr
class mem_addr extends uvm_reg;
  `uvm_object_utils(mem_addr)
   
  rand uvm_reg_field addr;

  //// Constructor 
  function new (string name = "mem_addr");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction
  
  function void build; 
    
    //// Create bitfield
    addr = uvm_reg_field::type_id::create("addr");   
    //// Configure
    addr.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

////	Register Class defination - extra_info
class extra_info extends uvm_reg;
  `uvm_object_utils(extra_info)
   
  rand uvm_reg_field extra;

  function new (string name = "extra_info");
    super.new(name,32,UVM_NO_COVERAGE); //32 -> Register Width
  endfunction

  function void build; 
    
    // Create bitfield
    extra = uvm_reg_field::type_id::create("extra");   
    // Configure
    extra.configure(.parent(this), 
                   .size(32), 
                   .lsb_pos(0),  
                   .access("RW"),   
                   .volatile(0),  
                   .reset(0),  
                   .has_reset(1),  
                   .is_rand(1),  
                   .individually_accessible(0));   
    endfunction
endclass

////	Register Block Definition
class dma_reg_model extends uvm_reg_block;
  `uvm_object_utils(dma_reg_model)
  
  // register instances 
  rand intr 	reg_intr; 
  rand ctrl 	reg_ctrl;
  rand io_addr 	reg_io_addr;
  rand mem_addr reg_mem_addr;
  rand extra_info reg_extra_info;
  
  function new (string name = "");
    super.new(name, build_coverage(UVM_NO_COVERAGE));
  endfunction

  function void build;
    
    // reg creation
    reg_intr = intr::type_id::create("reg_intr");
    reg_intr.build();
    reg_intr.configure(this);
    //r0.add_hdl_path_slice("r0", 0, 8);      // name, offset, bitwidth
 
    reg_ctrl = ctrl::type_id::create("reg_ctrl");
    reg_ctrl.build();
    reg_ctrl.configure(this);
    
    reg_io_addr = io_addr::type_id::create("reg_io_addr");
    reg_io_addr.build();
    reg_io_addr.configure(this);
  
    reg_mem_addr = mem_addr::type_id::create("reg_mem_addr");
    reg_mem_addr.build();
    reg_mem_addr.configure(this);
    
    reg_extra_info = extra_info::type_id::create("reg_extra_info");
    reg_extra_info.build();
    reg_extra_info.configure(this);
    
    // memory map creation and reg map to it
    default_map = create_map("my_map", 0, 4, UVM_LITTLE_ENDIAN); // name, base, nBytes
    default_map.add_reg(reg_intr	, 'h0, "RW");  // reg, offset, access
    default_map.add_reg(reg_ctrl	, 'h4, "RW");
    default_map.add_reg(reg_io_addr	, 'h8, "RW");
    default_map.add_reg(reg_mem_addr, 'hC, "RW");
    default_map.add_reg(reg_extra_info, 'h10, "RW");
    
    lock_model();
  endfunction
endclass