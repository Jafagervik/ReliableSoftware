#define N 3  // Number of people
#define B_MIN 0 
#define B_MAX 4 

#define NUM_M 300

byte PERSON1 = 0;
byte PERSON2 = 1;
byte PERSON3 = 2;

chan c1 = [NUM_M] of {int};
chan c2 = [NUM_M] of {int};
chan c3 = [NUM_M] of {int};

byte a1 = 5, a2 = 6, a3 = 7;

byte b[N];  // Lower bounds b[i] for each person
byte d[N];  // Candidate dates d[i] for each person
byte f[N];  // Earliest available dates f[i] for each person

// MAIN IDEA: RECEIVE TO YOUR OWN IDS CHANNEL, SEND TO NEXT

active proctype P1(byte id) {
  byte prev_date;
  
  d[id] = 0;
  f[id] = 0;
  
  do
  :: true ->
    d[id] = f[id];
    
    c2 ! d[id];
    
    c1 ? prev_date;
    
    if
    :: prev_date > d[id] -> d[id] = prev_date;
    :: else -> skip;
    fi;
    
    f[id] = (d[id] - b[id] + a1);
    
    if
    :: f[id] <= prev_date -> break;
    :: else -> skip;
    fi;
  od;
}

active proctype P2(byte id) {
  byte prev_date;
  
  d[id] = 0;
  f[id] = 0;
  
  do
  :: true ->
    d[id] = f[id];
    
    c3 ! d[id];
    
    c2 ? prev_date;
    
    if
    :: prev_date > d[id] -> d[id] = prev_date;
    :: else -> skip;
    fi;
    
    f[id] = (d[id] - b[id] + a2);
    
    if
    :: f[id] <= prev_date -> break;
    :: else -> skip;
    fi;
  od;
}

active proctype P3(byte id) {
  byte prev_date;
  
  d[id] = 0;
  f[id] = 0;
  
  do
  :: true ->
    d[id] = f[id];
    
    c1 ! d[id];
    
    c3 ? prev_date;
    
    if
    :: prev_date > d[id] -> d[id] = prev_date;
    :: else -> skip;
    fi;
    
    f[id] = (d[id] - b[id] + a3);
    
    if
    :: f[id] <= prev_date -> break;
    :: else -> skip;
    fi;
  od;
}

init {
  // Initialize lower bounds b[i] and intervals a[i]
  byte b1, b2, b3;
  
  // Loop through possible values of b1, b2, and b3
  for (b1: B_MIN..B_MAX) {
  for (b2: B_MIN..B_MAX) {
  for (b3: B_MIN..B_MAX) {
  
    // Initialize lower bounds and intervals for each person
    b[0] = b1; b[1] = b2; b[2] = b3;
  
    run P1(PERSON1);
	run P2(PERSON2); 
	run P3(PERSON3);
  
    // TODO: Fix this loop
    do
    :: _nr_pr > 1 -> 0;
    :: else -> break;
    od;
  
    // Print the largest possible meeting date and the corresponding lower bounds
    if
    :: d[0] > d[1] && d[0] > d[2] -> printf("Largest meeting date: %d, b1: %d, b2: %d, b3: %d\n", d[0], b1, b2, b3);
    :: d[1] > d[0] && d[1] > d[2] -> printf("Largest meeting date: %d, b1: %d, b2: %d, b3: %d\n", d[1], b1, b2, b3);
    :: d[2] > d[0] && d[2] > d[1] -> printf("Largest meeting date: %d, b1: %d, b2: %d, b3: %d\n", d[2], b1, b2, b3);
    :: else -> skip;
    fi;
  }
  }
  }
}


