#include <fstream>
#include <iostream>
#include <string>

int main() {
  
  int horiz = 0, depth = 0;
  std::ifstream file("input");
  std::string line;
  
  if (file.is_open()) {
    while (std::getline(file, line)) {
   
      if(line[0] == 'f') {
        horiz += line.back() - '0';
      }   

      else if(line[0] == 'd') {
        depth += line.back() - '0';
      }   
      else if(line[0] == 'u') {
        depth -= line.back() - '0';
      }   
    }
  }

  file.close();

  std::cout << "depth: " << depth << "\n";
  std::cout << "horizontal: " << horiz << "\n";
  std::cout << "depth * horizontal: " << horiz * depth << "\n";

  return 0;
}
