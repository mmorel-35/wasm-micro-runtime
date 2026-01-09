# WAMR Bazel Configuration

This directory contains Bazel-specific configuration files for WAMR.

## Files

- `extensions.bzl`: Module extensions for optional WAMR features (e.g., JIT with LLVM)
- `BUILD.bazel`: Build configuration for this directory

## LLVM/JIT Support

The WAMR Bazel build does not include LLVM by default to keep dependencies minimal. Most use cases (interpreter and AOT) do not require LLVM.

If you need JIT support, add LLVM from the Bazel Central Registry (BCR):

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
