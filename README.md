# UVM RAL using a DMA design

The implementation shows one of the ways to access DUT registers with the UVM RAL Model.

Below are the DMA registers from DUT:
\
INTR
\
CTRL
\
IO_ADDR
\
MEM_ADDR
\
EXTRA_INFO





Below is the block diagram for the testbench:


<img src="UVM_RAL_DMA.jpg" width=600>


The testbench components are:

- Environment

- DMA Agent:
\
Driver
\
Monitor
\
Sequencer and Sequences
   
- RAL Model:
\
DMA Reg package    
\
Adapter
  
Changes:
Register "extra_info" with the address of 410 was added to the existing ----------------- design.

<p align="center">  
<img src="jpg" width=600>

Reference:
https://verificationguide.com/uvm-ral-example/uvm-ral-example-dma/
