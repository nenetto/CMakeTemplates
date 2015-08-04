// This is an example for a heaer file
// It defines the square of a number function

#include "InternalLibraryPublicHeader.h"

InternalLibrary_EXPORT double InternalLibrary::myfunction(double x)
{
	return sqrt(x);
}


InternalLibrary_EXPORT void InternalLibrary::printConfigVariables(void){

// This line print variables into Config.h header if
// DEBUG_FLAG was set to TRUE during Configuration time
#ifdef InternalLibrary_DEBUG_FLAG

    fprintf(stdout,"The current version of the program %s is: %i.%i\n",
           InternalLibrary_PROJECT_NAME, InternalLibrary_VERSION_MAJOR, InternalLibrary_VERSION_MINOR);
#else

    fprintf(stdout,"printConfigVariables function\n");

#endif
  }
