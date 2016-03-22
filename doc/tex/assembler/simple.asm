// Basic function:
// *result = *op1 == *op2 ? 33 : 27;

// Load operands from memory
immediate <op1_address> // op1_address into the control unit output
move ctrl.o0, load.i0
immediate <op2_address>
move ctrl.o0, load.i0

// Send result destination to "store" function unit
immediate <result_address>
move ctrl.o0, store.i0

// Send parameters to compare unit
move load.o0, cmp.i0
move load.o0, cmp.i1

move cmp.o0, ctrl.i0 //move to control unit input for branch
branch yes // branch to yes if control unit input != 0
no:
	immediate 27
	jump both
yes:
	immediate 33
both:
	move ctrl.o0, store.i1 // move to data input of the store unit

