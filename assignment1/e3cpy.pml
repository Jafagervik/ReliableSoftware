#define N 3  
#define B_MIN 0
#define B_MAX 4

mtype = {P1, P2, P3}; // one for each person 
mtype channel[N]; // set up 3 channels to communicate in 

// Known constants from the task
byte a1 = 5, a2 = 6, a3 = 7;

byte b[N], a[N], d[N], f[N]; 

active proctype P(byte id) {
  byte prevID = (id + N - 1) % N;
  byte nextID = (id + 1) % N;
  
  byte prev_date;
  
  d[id] = 0;
  f[id] = 0;
  
  do
  :: true ->
    d[id] = f[id];
    
    channel[nextID] ! d[id];
    
    channel[id] ? prev_date;
    
    if
    :: prev_date > d[id] -> d[id] = prev_date;
    :: else -> skip;
    fi;
    
    // Update earliest available date
    f[id] = (d[id] - b[id] + a[id]);
    
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
            a[0] = a1; a[1] = a2; a[2] = a3;
          
            // Start the processes for each person
            run P(0); run P(1); run P(2);
          
            // Check if all processes have terminated
            byte count = 0;
            do
            :: count < N -> count++;
            :: count == N -> break;
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

