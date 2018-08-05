BUILD_FOLDER=$(CURDIR)/build
BIN_FOLDER=$(CURDIR)/bin
INSTALL_FOLDER=$(CURDIR)/install
LIB_FOLDER=$(CURDIR)/lib
CMAKE_FOLDER=$(CURDIR)

BUILD_TYPE=Visual Studio 15 2017 Win64

ifeq ($(OS),Windows_NT)
BUILD_RULE=build_windows
CLEAN_RULE=clean_windows
CLEAN_LIBS_RULE=clean_libs_windows
DEFAULT_RULE=nmake
else
BUILD_RULE=build_linux
CLEAN_RULE=clean_linux
CLEAN_LIBS_RULE=clean_libs_linux
endif

### Builds ########################################################

default: help

help:
	@echo Options:
	@echo  - nmake
	@echo  - vs15
	@echo  - vs17

run: nmake
	@echo OFF & echo.
	@echo Compilation successful!
	@echo Running "$(BIN_FOLDER)/opengl_project.exe"...
	@"$(BIN_FOLDER)/opengl_project.exe"
	@echo Program terminated.

nmake: BUILD_FOLDER=$(CURDIR)/build-nmake
nmake: CMAKE_FLAGS+=-G"NMake Makefiles"
nmake: CMAKE_FLAGS+=-B"$(BUILD_FOLDER)"
nmake: call_cmake
	@cd "$(BUILD_FOLDER)" & nmake

vs15: BUILD_TYPE=Visual Studio 14 2015 Win64
vs15: BUILD_FOLDER=$(CURDIR)/build-vs-15
vs15: vsproject

vs17: BUILD_TYPE=Visual Studio 15 2017 Win64
vs17: BUILD_FOLDER=$(CURDIR)/build-vs-17
vs17: vsproject

vsproject: CMAKE_FLAGS+=-G"$(BUILD_TYPE)"
vsproject: CMAKE_FLAGS+=-B"$(BUILD_FOLDER)"
vsproject: CMAKE_FLAGS+=-DCMAKE_INSTALL_PREFIX="$(INSTALL_FOLDER)"
vsproject: call_cmake

call_cmake:
	@if not exist "$(BUILD_FOLDER)" mkdir "$(BUILD_FOLDER)"
	@cd "$(BUILD_FOLDER)" & cmake $(CMAKE_FLAGS) "$(CMAKE_FOLDER)"

### Clean #########################################################

clean: $(CLEAN_RULE)

clean_linux:
	@rm -Rf $(INSTALL_FOLDER)

clean_windows:
	@echo deleting "$(INSTALL_FOLDER)"...
	@if exist "$(INSTALL_FOLDER)" (rmdir /s/q "$(INSTALL_FOLDER)")

clean_lib: clean_libs
clean_libs: $(CLEAN_LIBS_RULE)

clean_libs_linux:
	@rm -Rf $(LIB_FOLDER)/glfw $(LIB_FOLDER)/glm $(LIB_FOLDER)/imgui

clean_libs_windows:
	@echo deleting libraries...
	@for %%G in ("$(LIB_FOLDER)/glfw", "$(LIB_FOLDER)/glm", "$(LIB_FOLDER)/imgui") do ( if exist %%G (rmdir /s/q %%G) )

clean_all: clean
clean_all: clean_libs
