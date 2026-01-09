# WAMR Bazel Configuration

This directory contains Bazel-specific configuration files for WAMR.

## Files

- `extensions.bzl`: Build configuration helpers for optional WAMR features (e.g., JIT with LLVM)
- `BUILD.bazel`: Build configuration for this directory

## LLVM/JIT Support

The WAMR Bazel build does not include LLVM by default to keep dependencies minimal. Most use cases (interpreter and AOT) do not require LLVM.

### Using JIT in Your Project

WAMR provides two build targets:
- `//:vmlib` - Default build (Interpreter + AOT, no JIT)
- `//:vmlib_jit` - JIT-enabled build (requires LLVM)

To use JIT support in your project:

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

# Add LLVM from Bazel Central Registry
bazel_dep(name = "llvm-project", version = "17.0.3.bcr.4")
```

Then in your BUILD file:

```python
cc_binary(
    name = "my_wasm_app",
    srcs = ["main.c"],
    deps = [
        "@wamr//:vmlib_jit",  # Use vmlib_jit instead of vmlib
    ],
)
```

### For proxy-wasm-cpp-host Integration

If you're integrating WAMR with proxy-wasm-cpp-host or similar projects:

1. Add LLVM dependency in your MODULE.bazel (as shown above)
2. Use conditional deps in your BUILD file:

```python
cc_library(
    name = "wamr_engine",
    deps = select({
        "//bazel:engine_wamr_jit": ["@wamr//:vmlib_jit"],
        "//conditions:default": ["@wamr//:vmlib"],
    }),
)
```

This allows you to switch between JIT and non-JIT builds based on your build configuration.

### Recommended: Using Bazel Central Registry

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

# Add LLVM from Bazel Central Registry
bazel_dep(name = "llvm-project", version = "17.0.3.bcr.4")
```

LLVM is available in BCR with Bazel build support already configured. Check the [Bazel Central Registry](https://registry.bazel.build/modules/llvm-project) for available versions.

### Alternative: Using git_override for newer versions

If you need LLVM 18.x or 19.x (not yet in BCR):

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

git_override(
    module_name = "llvm-project",
    remote = "https://github.com/llvm/llvm-project.git",
    commit = "llvmorg-18.1.8",
)
```

### Supported LLVM Versions

- **BCR**: LLVM 17.0.3.bcr.4 (ready to use)
- **Compatible**: LLVM 17.x, 18.x, 19.x
- **WAMR default (CMake)**: LLVM 18.x (release/18.x branch)

## Why is LLVM optional?

1. **Large dependency**: LLVM is a very large project (~2GB source)
2. **Build time**: Building LLVM can take significant time
3. **Not always needed**: Interpreter and AOT modes don't require LLVM
4. **User choice**: Let users decide if they need JIT support
5. **Available in BCR**: LLVM is properly packaged in Bazel Central Registry

## LLVM Bazel Support

LLVM has official Bazel build support with overlays maintained in the Bazel Central Registry. This means:
- No foreign_cc needed
- Native Bazel cc_library targets
- Proper dependency management
- Pre-configured build settings

For detailed LLVM Bazel documentation, see the [LLVM Bazel documentation](https://llvm.org/docs/GettingStarted.html#checkout-llvm-from-git) and the [BCR llvm-project module](https://registry.bazel.build/modules/llvm-project).
