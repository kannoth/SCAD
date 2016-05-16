Current processor architectures offer instruction-level parallelism by duplicating processing resources and handling both instruction and data distribution from a central controller. Although this scheme offers high throughput on non-dependent instructions, existence of central register file cripples the performance on data dependent workloads where several consecutive instructions contend for registers, which results in serialization of the machine code and stalls on controller. 

In this work, we implement *Synchronous Control Asynchronous Dataflow (SCAD)* architecture, where instructions are issued in order but data movement is handled by processing elements that are connected to each other via data network. Similar to out-of-order super scalar processors, SCAD architecture enforces dataflow order of instructions. However, fundamental difference is the decentralized hazard resolving mechanism, in which the controller does not halt issuing instructions as long as there are enough processing elements available. Instructions are issued in-order (synchronously), while operands and results are moved out-of-order (asynchronously). Data dependencies within a block of operations are resolved by a VLIW like mechanism without incurring register file contention.

*src* and *sim* directories include source and simulation files respectively. *top_level.vhd* file contains integrated components, with a testbench that executes a simple assembly program.
