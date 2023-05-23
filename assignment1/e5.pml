mtype = { p, v }; //  P for Wait, V for signal

chan S = [0] of {mtype};

// TODO: Impl chanl
chan C = [5] of {int};

byte N = 0;

proctype semaphore(byte n) {
    N = n;
    do
    :: N > 0 ->
        S ? p;
        N--;
    :: N == 0->
        S ? v;
        N++;
    od
}

active[5] proctype c() {
    do 
    :: S ! p;
        printf("%d bien here!\n", _pid);
       S ! v;
    od
}

active proctype check() {
    assert (N >= 0);
}


init {
    byte n = 3;
    run semaphore(n);

    // run check();

    /*bit i;
    for (i: 1..5) {
        run c();
    }*/ 
}

