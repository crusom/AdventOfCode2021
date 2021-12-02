#include <fstream>
#include <iostream>

int main() {

  std::ifstream infile("input");
  int i = 0, prev, curr;

  infile >> prev;

  while(infile >> curr) {

    if(curr - prev > 0) i++;
    prev = curr;
  }
  
  std::cout << i;

  return 0;
}
