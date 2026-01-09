# WAMR Bazel Configuration

This directory contains Bazel-specific configuration files for WAMR.

## Files

- `extensions.bzl`: Build configuration helpers for optional WAMR features (e.g., JIT with LLVM)
- `BUILD.bazel`: Build configuration for this directory

## LLVM/JIT Support

WAMR now includes LLVM as an optional dependency, making JIT support much easier to use!

### Using JIT in Your Project

WAMR provides two build targets:
- `//:vmlib` - Default build (Interpreter + AOT, no JIT, no LLVM)
- `//:vmlib_jit` - JIT-enabled build (LLVM automatically included)

**Simple JIT usage:**

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

# In your BUILD file
cc_binary(
    name = "my_wasm_app",
    srcs = ["main.c"],
    deps = [
        "@wamr//:vmlib_jit",  # LLVM is automatically available!
    ],
)
```

LLVM 17.0.3.bcr.4 from Bazel Central Registry is automatically included as an optional dependency. You don't need to add it manually to your MODULE.bazel!

### For proxy-wasm-cpp-host Integration

If you're integrating WAMR with proxy-wasm-cpp-host or similar projects, it's now even simpler:

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")
# No need to add llvm-project separately!

# In your BUILD file - use conditional deps
cc_library(
    name = "wamr_engine",
    deps = select({
        "//bazel:engine_wamr_jit": ["@wamr//:vmlib_jit"],
        "//conditions:default": ["@wamr//:vmlib"],
    }),
)
```

This allows you to switch between JIT and non-JIT builds based on your build configuration.

### Using a Different LLVM Version (Optional)

WAMR includes LLVM 17.0.3.bcr.4 by default. If you need a different version:

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

# Override with a newer LLVM version
git_override(
    module_name = "llvm-project",
    remote = "https://github.com/llvm/llvm-project.git",
    commit = "llvmorg-18.1.8",
)
```

### Supported LLVM Versions

- **Included by default**: LLVM 17.0.3.bcr.4 from BCR (ready to use)
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
