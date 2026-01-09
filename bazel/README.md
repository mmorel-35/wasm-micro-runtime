# WAMR Bazel Configuration

This directory contains Bazel-specific configuration files for WAMR.

## Files

- `extensions.bzl`: Module extensions for optional WAMR features (e.g., JIT with LLVM)
- `BUILD.bazel`: Build configuration for this directory

## LLVM/JIT Support

The WAMR Bazel build does not include LLVM by default to keep dependencies minimal. Most use cases (interpreter and AOT) do not require LLVM.

If you need JIT support, you must add LLVM as a dependency in your project's `MODULE.bazel`:

### Option 1: Using git_override (Development)

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

git_override(
    module_name = "llvm-project",
    remote = "https://github.com/llvm/llvm-project.git",
    commit = "llvmorg-18.1.8",
)
```

### Option 2: Using archive_override (Production)

```python
# In your MODULE.bazel
bazel_dep(name = "wamr", version = "2.4.3")

archive_override(
    module_name = "llvm-project", 
    urls = ["https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-18.1.8.tar.gz"],
    strip_prefix = "llvm-project-llvmorg-18.1.8",
)
```

### Supported LLVM Versions

WAMR supports LLVM 18.x and 19.x. The default version used in CMake builds is LLVM 18.x (release/18.x branch).

## Why is LLVM optional?

1. **Large dependency**: LLVM is a very large project (~2GB source)
2. **Build time**: Building LLVM can take significant time
3. **Not always needed**: Interpreter and AOT modes don't require LLVM
4. **User choice**: Let users decide if they need JIT support

## Future Improvements

In the future, we may provide:
- Pre-built LLVM binaries as Bazel modules
- Simplified LLVM integration scripts
- JIT-specific build targets

For now, users needing JIT should follow LLVM's Bazel build documentation and configure WAMR accordingly.
