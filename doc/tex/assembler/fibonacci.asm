setup:
	immediate 0
	move ctrl.o0 duplication.i0
	
	immediate N
	move ctrl.o0 add.i0
	move duplicaton.o0, add.i1
	
	immediate 1
	immediate 0
	move ctrl.o0 add.i0
	move ctrl.o0 add.i1

loop:
	// Loop invariant: * output buffer of add contains: (n-i)
	//                                             then fib(i)
	//                 * output buffer of duplication contains: fib(i-1)
	
	immediate -1
	move ctrl.o0, add.i1
	
	move duplication.o0, add.i1
	// add.i1: -1, fib(i-1)
	// add.o0: (n-i), fib(i)
	
	move add.o0, duplication.i0
	// add.i1: -1, fib(i-1)
	// add.o0: fib(i)
	// duplication.o0: (n-i), (n-i)
	
	move duplication.o0 ctrl.i0
	// add.i1: -1, fib(i-1)
	// add.o0: fib(i)
	// duplication.o0: (n-i)
	// ctrl.i0: (n-i)
	
	move duplication.o0 add.i0
	// add.i1: fib(i-1)
	// add.o0: fib(i), (n-i-1)
	// ctrl.i0: (n-i)
	
	move add.o0, duplication.i0
	// add.i1: fib(i-1)
	// add.o0: (n-i-1)
	// duplication.o0: fib(i), fib(i)
	// ctrl.i0: (n-i)
	
	move duplication.o0, add.i0
	// add.o0: (n-i-1), fib(i+1)
	// duplication.o0: fib(i)
	// ctrl.i0: (n-i)
	
	// takes ctrl.i0 as branch condition
	branch loop

finished:
	// TODO: write values to result place in ram?

