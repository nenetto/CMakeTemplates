# CMakeTemplates
### CMakeTemplates
The repository contain two folders: 

1. CMakeProject
2. CMakeSuperBuildTemplate

CMakeProject configures executables, dynamic library or static library using CMake and creates the configuration folder structure for developing. On the other hand, CMakeSuperBuildTemplate is a template for a SuperBuild configuration folder structure. With minimal changes on the CMakeLists.txt files and adding your code files, configuration structure will be ready for your development, taking care of internal and external dependencies. 

### Tutorial

#### Creating a simple executable (library)

This example is useful when you are creating an executable or library that depends **only** on standard libraries of C/C++

1. Configure CMakeProject using CMake
2. Change the name of your executable/library, this will be the project name
3. Change the folder where your source code will be generated **using the same name that the project name**

#### Creating your SuperBuild project

This is strongly recommended even if you are just creating a new library or executable. Template will configure automatically [Doxygen](http://www.stack.nl/~dimitri/doxygen/) for documentation of your project and Git for external dependencies if your executable or library need them.

1. Create an empty folder for your SuperBuild
2. Copy the content of [CMakeSuperBuildTemplate]() into your folder
3. Open the file CMakeLists.txt of your SuperBuild folder and change the name project for the folder's name

This project comes with 4 example projects inside: InternalLibrary, InternalExecutable, ExternalLibrary and ExternalExecutable in order to show how dependencies work. The dependency list is:

* InternalLibrary has no dependencies
* InternalExecutable depends on InternalLibrary and ExternalLibrary
* ExternalLibrary has no dependencies
* ExternalExecutable depends on ExternalLibrary

Note that if you look inside Projects folder, you will find the configuration for each project, including two extra: Doxygen and Git. As reader can see, all external projects depends on Git. CMake during SuperBuild building will download Git repositories of external dependencies and will download them during compilation time (CMake configuration and Generation phase).

#### Combining both

Let say that you created your awesome library using first option of this tutorial. Now, you want to create your test executable in order to use your library and make some tests. Well, here you will find the steps for this task:

1. Copy your library folder into your SuperBuild folder
2. Go to CMake folder of your **library** and you will find the file: LIBRARY_NAME-external.cmake .  Copy the file into SuperBuild/Projects folder and rename the file as: LIBRARY_NAME.cmake

This is! Now you can configure your SuperBuild project and find a new option called USE_LIBRARY_NAME

For creating your test executable, just follow the first tutorial for create the executable. Then follow the previous two steps in order to add your executable to the SuperBuild and finally add the dependency to your library. To do so, go to your EXECUTABLE_NAME.cmake that you put into SuperBuild/Projects folder and add LIBRARY_NAME in the first lines as:

```
set(EP_OPTION_NAME "USE_${EP_NAME}")
set(EP_REQUIRED_PROJECTS LIBRARY_NAME)
```

Configure again, and now the executable will appear as a USE_EXECUTABLE_NAME option. CMake will take care, thanks to [CMakeAll](https://github.com/auneri/CMakeAll), of the dependencies.
