cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

add_executable(${BINARY_NAME} WIN32
        "flutter_window.cpp"
        "main.cpp"
        "utils.cpp"
        "win32_window.cpp"
        "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
        "Runner.rc"
        "runner.exe.manifest"
)

# Apply your standard settings with /MD runtime, exceptions off, etc.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for Flutter version info
target_compile_definitions(${BINARY_NAME} PRIVATE
        "FLUTTER_VERSION=\"${FLUTTER_VERSION}\""
        "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}"
        "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}"
        "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}"
        "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}"
        "NOMINMAX"  # Disable Windows macros that collide with std lib functions
        "_HAS_EXCEPTIONS=0"
        "$<$<CONFIG:Debug>:_DEBUG>"
)

# Link libraries: Flutter, Firebase, system libs, MSVC runtime
target_link_libraries(${BINARY_NAME} PRIVATE
        flutter
        flutter_wrapper_app

        firebase_app
        firebase_auth

        dwmapi.lib
        ws2_32.lib
        userenv.lib
        crypt32.lib
        bcrypt.lib

        # MSVC runtimes
        msvcp140.lib
        vcruntime.lib
)

# Include directories if needed
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run Flutter assemble target dependency
add_dependencies(${BINARY_NAME} flutter_assemble)
