BUILD_FOLDER=$(CURDIR)/build
INSTALL_FOLDER=$(CURDIR)/install
CMAKE_FOLDER=$(CURDIR)/util/cmake

BUILD_TYPE=Visual Studio 15 2017 Win64

ifeq ($(OS),Windows_NT)
BUILD_RULE=build_windows
CLEAN_RULE=clean_windows
else
BUILD_RULE=build_linux
CLEAN_RULE=clean_linux
endif

default: nmake

nmake: BUILD_FOLDER=$(CURDIR)/build-nmake
nmake: CMAKE_FLAGS+=-G"NMake Makefiles"
nmake: CMAKE_FLAGS+=-B"$(BUILD_FOLDER)"
nmake: CMAKE_FLAGS+=-B"$(BUILD_FOLDER)"
nmake: call_cmake
	cd "$(BUILD_FOLDER)" & nmake

vsproject15: BUILD_TYPE=Visual Studio 14 2015 Win64
vsproject15: vsproject

vsproject: BUILD_FOLDER=$(CURDIR)/build-vsproject
vsproject: CMAKE_FLAGS+=-G"$(BUILD_TYPE)"
vsproject: CMAKE_FLAGS+=-B"$(BUILD_FOLDER)"
vsproject: CMAKE_FLAGS+=-DCMAKE_INSTALL_PREFIX="$(INSTALL_FOLDER)"
vsproject: call_cmake

call_cmake:
	-mkdir "$(BUILD_FOLDER)"
	cd "$(BUILD_FOLDER)" & cmake $(CMAKE_FLAGS) "$(CMAKE_FOLDER)"

### Clean ######################################################################

clean: $(CLEAN_RULE)

clean_linux:
	@rm -Rf $(INSTALL_FOLDER)

clean_windows:
	-@rd /s /q "$(INSTALL_FOLDER)"