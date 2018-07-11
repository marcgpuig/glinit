# OpenGL Project
Yet another OpenGL build project.

# How to use
### Necessary software
- Git
- Make
- Cmake

_Be sure that these programs are added to your path, so you can use them from your command prompt._

- Visual Studio

## Windows
### Environment Setup
You must **enable the x64 Visual C++ Toolset**.
I recommend to use this environment for everything you do.
You have different options:

- **Recomended:** Use [`Visual Studio x64 Native Tools Command Prompt`](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs). Just press the `Win` button and search for `x64`, because the name of this Command Prompt can change depending on the lenguage you have installed Visual Studio.
- [Enable a 64-Bit Visual C++ Toolset on the Command Line](https://msdn.microsoft.com/en-us/library/x4d2c09s.aspx) (the instructions will depend on the version of VS that you have).

Go to main project folder and run:

    > make
    > bin/opengl_project.exe

#### Visual Studio (2017)

    > make vsproject15

This will create a `build-vs-15` folder with the VS 15 (2017) project.
_The makefile can be easly modified to support older versions of VS._

#### Sublime Text
Serch for the vcvars64.bat in your computer and edit the `"shell_cmd":`.
Then you can `ctrl+shift+B` and select the build type.

## Linux
_Not tested_
