#include <fstream>
#include <iostream>

int main() {

  std::ifstream infile("input");
  int i = 0, prev_sum, curr_sum, a, b, c;

  infile >> a >> b >> c;
  prev_sum = a + b + c;

  while(infile >> c){

    curr_sum = a + b + c;

    if(curr_sum - prev_sum > 0) i++;
    
    prev_sum = curr_sum;
    a = b;
    b = c;
  }
  
  std::cout << i;

  return 0;
}
