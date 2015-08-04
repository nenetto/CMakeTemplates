// This is an example for a source file
// It calculates the square of a number

// Include example header
#include "InternalExecutable.h"

  void InternalExecutable::printConfigVariables(void){

// This line print variables into Config.h header if
// DEBUG_FLAG was set to TRUE during Configuration time
#ifdef InternalExecutable_DEBUG_FLAG

    fprintf(stdout,"The current version of the program %s is: %i.%i\n",
           InternalExecutable_PROJECT_NAME, InternalExecutable_VERSION_MAJOR, InternalExecutable_VERSION_MINOR);
#else

    fprintf(stdout,"printConfigVariables function\n");

#endif
  }

double InternalExecutable::myfunction(double x)
{
  return sqrt(x);
}

// Main Function

int main (int argc, char *argv[])
{

  // Shows the Config.h functionality
  InternalExecutable::printConfigVariables();

  // Uses a function defined in other cpp file of the same project
  double outputValue = InternalExecutable::myfunction(4.0);

  return 0;
}
