# Building WAMR with Bazel

This repository includes Bazel build support using MODULE.bazel (Bazel's modern module system).

## Prerequisites

- Bazel 7.0 or later
- C compiler (gcc, clang, or MSVC)
- Standard build tools for your platform

## Building the WAMR Runtime Library

To build the main WAMR runtime library (vmlib):

```bash
bazel build //:vmlib
```

This will build the complete WAMR runtime library including:
- Fast interpreter
- AOT runtime
- WASI libc support
- Built-in libc support
- Platform abstraction layer
- Memory allocator

## Building for Specific Platforms

Bazel will automatically detect your platform and architecture. You can also explicitly specify:

```bash
# Build for Linux x86_64
bazel build --platforms=@platforms//os:linux --cpu=x86_64 //:vmlib

# Build for macOS ARM64
bazel build --platforms=@platforms//os:macos --cpu=aarch64 //:vmlib

# Build for Windows x86_64
bazel build --platforms=@platforms//os:windows --cpu=x86_64 //:vmlib
```

## Using WAMR in Your Bazel Project

To use WAMR in your Bazel project, add it as a dependency in your BUILD.bazel file:

```python
cc_binary(
    name = "my_wasm_app",
    srcs = ["main.c"],
    deps = [
        "@wamr//:vmlib",
    ],
)
```

See the `examples/simple-bazel-example` directory for a complete example.

## Running the Example

```bash
# Build the example
bazel build //examples/simple-bazel-example:wamr_example

# Run the example
bazel run //examples/simple-bazel-example:wamr_example

# Run the test
bazel test //examples/simple-bazel-example:wamr_test
```

## Configuration Options

The Bazel build includes sensible defaults:
- Fast interpreter enabled (WASM_ENABLE_FAST_INTERP=1)
- AOT support enabled (WASM_ENABLE_AOT=1)
- WASI support enabled (WASM_ENABLE_LIBC_WASI=1)
- Built-in libc enabled (WASM_ENABLE_LIBC_BUILTIN=1)
- SIMD support enabled (WASM_ENABLE_SIMD=1)
- Reference types enabled (WASM_ENABLE_REF_TYPES=1)

To customize the build, you can modify the copts in the respective BUILD.bazel files or create custom build configurations.

## Build Structure

Individual BUILD.bazel files in subdirectories allow you to:
- Build specific components independently (e.g., `bazel build //core/iwasm/aot`)
- Better understand dependencies between components
- Modify component-specific build settings without affecting others
- Follow Bazel best practices for modular builds

## Bazel Build Files

The Bazel build is organized into multiple BUILD.bazel files for better maintainability:

- `MODULE.bazel`: Defines the WAMR module and its dependencies
- `BUILD.bazel`: Main build file defining the vmlib target
- `core/shared/mem-alloc/BUILD.bazel`: Memory allocator library
- `core/shared/utils/BUILD.bazel`: Shared utility functions
- `core/shared/platform/BUILD.bazel`: Platform abstraction layer
- `core/iwasm/common/BUILD.bazel`: Core WASM runtime
- `core/iwasm/interpreter/BUILD.bazel`: Fast interpreter
- `core/iwasm/aot/BUILD.bazel`: AOT runtime
- `core/iwasm/libraries/libc-builtin/BUILD.bazel`: Built-in libc
- `core/iwasm/libraries/libc-wasi/BUILD.bazel`: WASI libc
- `.bazelrc`: Common build settings and configurations

Each component is built as a separate `cc_library` target, allowing for modular builds and dependencies.

## Supported Platforms and Architectures

### Platforms
- Linux
- macOS (Darwin)
- Windows

### Architectures
- x86_64 (AMD64)
- ARM (32-bit)
- AArch64 (ARM 64-bit)
- RISC-V 64-bit

## Differences from CMake Build

The Bazel build is designed to be as close as possible to the CMake build but with some differences:
- No JIT support in the default configuration (requires LLVM dependencies)
- No optional features like wasi-nn, debug engine by default
- Simpler dependency management through Bazel's module system

## Troubleshooting

If you encounter build issues:

1. Ensure you have a recent version of Bazel (7.0+):
   ```bash
   bazel --version
   ```

2. Clean the build cache:
   ```bash
   bazel clean --expunge
   ```

3. Verify your toolchain:
   ```bash
   bazel query @platforms//...
   ```

## Contributing

When adding new source files or features to WAMR, please update the corresponding BUILD.bazel file to maintain Bazel build support.
