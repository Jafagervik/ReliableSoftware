int x = 0;

proctype P() {
    int k;
    int N = 5;

    int local_x;

    for (k: 1..N) {
        local_x = x; /* LOAD */ 
        local_x++;   /* INCREMENT */ 
        x = local_x; /* STORE */ 
    }
}

proctype check() {
    if 
    :: (_nr_pr == 1) -> printf("x is %d\n", x); assert (x == 3);
    fi
}


init { 
	run P(); run P(); run P(); 

    run check();
} 

