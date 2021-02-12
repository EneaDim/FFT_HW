# FFT Hardware Accelerator

The FFT algorithm make possible to speed up the DFT.

DFT:

<img src="https://render.githubusercontent.com/render/math?math=\huge%20X(k)%20=%20\sum_{n=0}^{N-1}x(n)%20e^{-j\frac{2\pi}{N}nk}">

## Algorithm

<b>Cooley-Tukey</b>

The Cooley-Turkey algorithm is the most famous FFt algorithm. It breaks the DFT into smaller DFT's.
The computational complexity is reduced from O(N^2) to O(N logN).

This implementation is a simple <b>radix-2</b> DIT (decimation in time) FFT:

<img src="https://render.githubusercontent.com/render/math?math=\huge%20X(k)=\sum_{n=0}^{\frac{N}{2}-1}x(2n)e^{-j\frac{2\pi}{\frac{N}{2}}(2n)k}%2B\sum_{n=0}^{\frac{N}{2}-1}x(2n%2B1)%20e^{-j\frac{2\pi}{\frac{N}{2}}(2n%2B1)k}">

Thanks to the periodicity of the complex exponential, is possible to rewrite X(k) as following:

<img src="https://render.githubusercontent.com/render/math?math=X(k)=\large%20\sum_{n=0}^{\frac{N}{2}-1}x(2n)e^{-j\frac{2\pi}{\frac{N}{2}}(2n)k}%2Be^{-j\frac{2\pi}{N}nk}O_k">
<img src="https://render.githubusercontent.com/render/math?math=X(k%2B\frac{N}{2})=\large%20\sum_{n=0}^{\frac{N}{2}-1}x(2n)e^{-j\frac{2\pi}{\frac{N}{2}}(2n)k}-e^{-j\frac{2\pi}{N}nk}O_k">

Where <img src="https://render.githubusercontent.com/render/math?math=O_k=\large%20\sum_{n=0}^{\frac{N}{2}-1}x(2n%2B1)e^{-j\frac{2\pi}{\frac{N}{2}}nk}"> 

For more information you can take a look at <https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm>

## Hardware Design

The idea is to implement this algorithm in hardware. The main components are:

#### Datapath

- Multipliers
- Adder-Subtractors
- Registers

#### Control Unit

- Microprogrammed CU

<img src="https://github.com/EneaDim/FFT_HW/blob/main/uPCU.png">

### Requirements to Compile and Simulate

```sudo apt-get install ghdl gtkwave```

### Requirements to Synthetize

Walkthrough <https://github.com/YosysHQ/yosys>

Walkthrough to convert vhdl into verilog files <https://github.com/ldoolitt/vhd2vl> (needed for synthesys with yosys)

### Requirements to Place&Route

Walkthrough <https://github.com/YosysHQ/nextpnr>

### Simulation

The 'testbench_FFT.vhd' is the default testbench.

The simulation can be seen running ```gtkwave FFT.vcd```.

### Compile the design

Running ```tb_script``` file , all files will be analyzed using ```ghdl```.

By default a <b>vcd</b> file named 'FFT.vcd' will be created.

You can see the simulation running again ```gtkwave FFT.vcd```.

### Synthesis

Has to be done. (Some problem converting vhdl to verilog)

If you can convert them, all verilog files the synthesys can be done with ```yosys```.

The target FPGA platform can be choosed with ```yosys``` with the commmand: ```synth\_<target_name>```.

### Place & Route 

Has to be done.

Using ```nextpnr```.
