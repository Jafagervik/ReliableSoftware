int x = 10;
int y = 0;

active proctype t1() {
    do 
    :: x != y -> x = x - 1; y = y + 1; 
    od
}


active proctype t2() {
    do 
    :: x == y -> atomic { x = 7; y = 3; }
    od
}

init {run t1(); run t2();}
