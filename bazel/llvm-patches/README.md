# LLVM 19.1.0 Support with archive_override

This directory contains BCR overlay patches for LLVM that enable bzlmod support.

## Current Status

WAMR currently uses LLVM 17.0.3.bcr.4 from the Bazel Central Registry, which has full bzlmod support out of the box.

## LLVM 19.1.0 Support (Future Work)

To use LLVM 19.1.0, you can use `archive_override` in MODULE.bazel with adapted patches:

```python
archive_override(
    module_name = "llvm-project",
    urls = ["https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.0/llvm-project-19.1.0.src.tar.xz"],
    integrity = "sha256-UEJSK0mUW8Vg/5IG8l+4eYCpuJuRQZPKANlhUR/wZzw=",
    strip_prefix = "llvm-project-19.1.0.src",
    patches = [
        "//bazel/llvm-patches:0001-Add-Bazel-files-to-.gitignore.patch",
        "//bazel/llvm-patches:0002-Add-LLVM-Bazel-overlay-files.patch",  # Needs adaptation for 19.1.0
        "//bazel/llvm-patches:0003-Add-MODULE.bazel.patch",
        "//bazel/llvm-patches:0004-Add-BUILD.bazel.patch",
        "//bazel/llvm-patches:0005-Add-Bazel-LLVM-targets.patch",
    ],
    patch_strip = 1,
)
```

**Note**: The patches in this directory are from BCR's llvm-project 17.0.3.bcr.4 and need to be adapted for LLVM 19.1.0. Specifically, patch 0002 (LLVM Bazel overlay files) fails to apply cleanly because the Bazel overlay has changed between LLVM 17 and 19.

## Adapting Patches

To create patches that work with LLVM 19.1.0:

1. Download LLVM 19.1.0 source
2. Apply each patch manually and resolve conflicts
3. Generate new patches with the resolved changes
4. Update the `archive_override` in MODULE.bazel to use the adapted patches

Alternatively, wait for LLVM 19.x to be added to the Bazel Central Registry with proper overlays.

## Patch Sources

These patches come from: https://github.com/bazelbuild/bazel-central-registry/tree/main/modules/llvm-project/17.0.3.bcr.4/patches
