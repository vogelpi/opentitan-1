Galois Multiplier Verilator Testbench
=====================================

This directory contains a basic, scratch Verilator testbench targeting
functional verification of the Galois multiplier primitive during
development.

Prerequisites
-------------

For the DPI calls into C and then Python to work, you need to:

1. Install the `pyfinite` Python package for finite field arithmetics.
```
   pip3 install --user pyfinite
```

2. Install the `python3-dev` libraries. On Ubuntu, run
```
   sudo apt-get install python3-dev
```

3. Make sure that GCC will find `python3-dev` headers and libraries. Run
```
   python3.6-config --cflags
   python3.6-config --ldflags
```
to get the corresponding flags on your machine and cross check with the flags passed to FuseSoC in:
```
   hw/ip/prim/dv/prim_galois_mult_model_dpi/prim_galois_mult_model_dpi.core
```
You might need adjust the flags in the core file.

How to build and run the testbench
----------------------------------

From the OpenTitan top level execute

   ```sh
   fusesoc --cores-root=. run --setup --build \
     lowrisc:dv_verilator:prim_galois_mult_tb
   ```
to build the testbench and afterwards

   ```sh
   ./build/lowrisc_dv_verilator_prim_galois_mult_tb_0/default-verilator/Vprim_galois_mult_tb \
     --trace
   ```
to run it.

Details of the testbench
------------------------

- `rtl/prim_galois_mult_tb.sv`: SystemVerilog testbench, instantiates and
  drives the DUT, compares outputs, signals test end and result (pass/fail)
  to C++ via output ports.
- `cpp/prim_galois_mult_tb.cc`: Contains main function and instantiation of
  SimCtrl, reads output ports of DUT and signals simulation termination to
  Verilator.
