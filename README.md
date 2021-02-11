# FFT Hardware Accelerator
The FFT algorithm make possible to speed up the DFT.

## Algorithm
<b>Cooley-Tukey</b>

## Datapath

- Multiplier
- Adder-Subtractor
- RegisterFile

## Control Unit

- Microprogrammed CU

## Simulation

Running 'tb\_script' , all files will be analyzed using <b>GHDL</b>.

The 'testbench_FFT.vhd' is the default testbench.

The output of the simulation is the 'FFT.vcd' file.

This simulation can be seen using <b>GTKWAVE</b>.

## Synthesis

Has to be done. (Some problem converting vhdl to verilog)

If you can convert them, all verilog files the synthesys can be done with <b>YOSYS</b>.

The target FPGA platform can be choosed with <b>YOSYS</b> with the commmand: 'synth\_<target_name>'.

## Place & Route 
Has to be done.

Using <b>NEXTPNR</b>
