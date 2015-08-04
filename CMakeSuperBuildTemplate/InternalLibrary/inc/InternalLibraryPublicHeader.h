// This is an example for a heaer file
// It defines the square of a number function

// This header file will be created during configuration time
// You can modify into CMake folder
#include "InternalLibraryConfig.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

namespace InternalLibrary{

InternalLibrary_EXPORT double myfunction(double x);

InternalLibrary_EXPORT void printConfigVariables(void);

}

