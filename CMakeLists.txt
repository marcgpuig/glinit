# https://jacquesh.github.io/post/basic-cmake/
# Project definition
cmake_minimum_required(VERSION 3.8.0)
project(opengl_project)

#set(PRE ${CMAKE_STATIC_LIBRARY_PREFIX})
#set(SUF ${CMAKE_STATIC_LIBRARY_SUFFIX})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /nologo")

# Source directorioes and files
set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(LIB_DIR ${CMAKE_SOURCE_DIR}/lib)
set(BIN_DIR ${CMAKE_SOURCE_DIR}/bin)

# Executable output directory
set(EXECUTABLE_OUTPUT_PATH ${BIN_DIR})

# All needed source files
file(GLOB_RECURSE SOURCES
	${SRC_DIR}/*.cpp
	${SRC_DIR}/*.h
)

# External glad source file
set(EXTERNAL_SOURCES 
    ${LIB_DIR}/glad/src/glad.c
)

# More external source files.
# In this case, this must be apart because the "ExternalProject_Add"
# that will add imgui, must specify the files that will be generated
# by it with the "BUILD_BYPRODUCTS" option.
set(EXTERNAL_IMGUI_SOURCES
    ${LIB_DIR}/imgui/imgui.cpp
    ${LIB_DIR}/imgui/imgui_draw.cpp
    ${LIB_DIR}/imgui/examples/imgui_impl_glfw.cpp
)

include(ExternalProject)

# -- GLAD ----------------------------------------------------------
set(GLAD_INCLUDE ${LIB_DIR}/glad/include)
# ------------------------------------------------------------------

# -- GLFW ----------------------------------------------------------
set(GLFW_DIR ${LIB_DIR}/glfw)
set(GLFW_INCLUDE ${GLFW_DIR}/include)
set(GLFW_LIB ${GLFW_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}glfw3${CMAKE_STATIC_LIBRARY_SUFFIX})
ExternalProject_Add(glfw
    GIT_REPOSITORY https://github.com/glfw/glfw.git
    GIT_SHALLOW 1
    GIT_TAG 3.2.1
    CMAKE_ARGS
    	-DGLFW_BUILD_EXAMPLES=OFF
    	-DGLFW_BUILD_TESTS=OFF
    	-DGLFW_BUILD_DOCS=OFF
    	-DGLFW_VULKAN_STATIC=OFF
    	-DBUILD_SHARED_LIBS=OFF
    	-DCMAKE_INSTALL_PREFIX=${GLFW_DIR}
    SOURCE_DIR ${GLFW_DIR}
    UPDATE_COMMAND ""
)
# ------------------------------------------------------------------

# -- GLM -----------------------------------------------------------
set(GLM_DIR ${LIB_DIR}/glm)
set(GLM_INCLUDE ${GLM_DIR})
ExternalProject_Add(glm
    GIT_REPOSITORY https://github.com/g-truc/glm.git
    GIT_SHALLOW 1
    GIT_TAG 0.9.9.0
    SOURCE_DIR ${GLM_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    UPDATE_COMMAND ""
)
# ------------------------------------------------------------------

# -- Imgui----------------------------------------------------------
set(IMGUI_DIR ${LIB_DIR}/imgui)
set(IMGUI_INCLUDE ${IMGUI_DIR})
set(IMGUI_IMPL_INCLUDE ${IMGUI_INCLUDE}/examples) # imgui implementation for OpenGL3+
ExternalProject_Add(imgui
    GIT_REPOSITORY https://github.com/ocornut/imgui.git
    GIT_SHALLOW 1
    GIT_TAG v1.62
    CMAKE_ARGS -DGLM_INSTALL_ENABLE=OFF
    SOURCE_DIR ${IMGUI_DIR}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS ${EXTERNAL_IMGUI_SOURCES}
)
# ------------------------------------------------------------------

# Mian executable
add_executable(${PROJECT_NAME}
    ${EXTERNAL_SOURCES}
    ${EXTERNAL_IMGUI_SOURCES}
    ${SOURCES}
)

# glfw glm and imgui must be download and built before the project
add_dependencies(${PROJECT_NAME} glfw glm imgui)

# Find OpenGL
include(FindOpenGL)

# Add the (.a/.lib) libraries
target_link_libraries(${PROJECT_NAME}
    ${OPENGL_gl_LIBRARY}
    ${GLFW_LIB}
)

include_directories(${PROJECT_NAME}
    ${GLAD_INCLUDE}
    ${GLFW_INCLUDE}
    ${GLM_INCLUDE}
    ${IMGUI_INCLUDE}
    ${IMGUI_IMPL_INCLUDE}
)
