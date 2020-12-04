LMDPL AND Verilator Testbench
=============================

This directory contains a basic, scratch Verilator testbench targeting
functional verification of the LMDPL AND gate implementation.

How to build and run the testbench
----------------------------------

From the OpenTitan top level execute

   ```sh
   fusesoc --cores-root=. run --setup --build lowrisc:dv_verilator:lmdpl_and_tb
   ```
to build the testbench and afterwards

   ```sh
   ./build/lowrisc_dv_verilator_lmdpl_and_tb_0/default-verilator/Vlmdpl_and_tb \
     --trace
   ```
to run it.

Details of the testbench
------------------------

- `rtl/lmdpl_and_tb.sv`: SystemVerilog testbench, instantiates and drives the
  LMDPL AND gate, compares outputs, signals test end and result (pass/fail)
  to C++ via output ports.
- `cpp/lmdpl_and_tb.cc`: Contains main function and instantiation of SimCtrl,
  reads output ports of DUT and signals simulation termination to Verilator.
