"""
Bazel extensions for WAMR

This file provides module extensions and build configurations for optional WAMR features.
"""

# Label flag for enabling JIT support
# This can be set by downstream projects to enable JIT compilation
def _jit_mode_impl(ctx):
    return ctx.attr.build_setting_value

jit_mode = rule(
    implementation = _jit_mode_impl,
    build_setting = config.bool(flag = True),
    doc = "Build setting to enable WAMR JIT mode",
)

# Helper function to create WAMR build variants
def wamr_copts(jit_enabled = False):
    """
    Returns compiler options for WAMR based on build configuration.
    
    Args:
        jit_enabled: Whether to enable JIT support (requires LLVM)
    
    Returns:
        List of compiler options
    """
    base_opts = [
        "-std=gnu99",
        "-ffunction-sections",
        "-fdata-sections",
        "-fvisibility=hidden",
    ]
    
    if jit_enabled:
        return base_opts + [
            "-DWASM_ENABLE_JIT=1",
            "-DWASM_ENABLE_FAST_JIT=0",
            "-DWASM_ENABLE_INTERP=1",  # JIT requires interpreter
            "-DWASM_ENABLE_AOT=1",      # JIT implies AOT
            "-DWASM_ENABLE_LAZY_JIT=1",
        ]
    else:
        return base_opts + [
            "-DWASM_ENABLE_INTERP=1",
            "-DWASM_ENABLE_FAST_INTERP=1",
            "-DWASM_ENABLE_AOT=1",
        ]

def wamr_defines(jit_enabled = False):
    """
    Returns preprocessor defines for WAMR based on build configuration.
    
    Args:
        jit_enabled: Whether to enable JIT support (requires LLVM)
    
    Returns:
        List of preprocessor defines
    """
    base_defines = [
        "WASM_ENABLE_LIBC_BUILTIN=1",
        "WASM_ENABLE_LIBC_WASI=1",
        "WASM_ENABLE_SIMD=1",
        "WASM_ENABLE_REF_TYPES=1",
    ]
    
    if jit_enabled:
        return base_defines + [
            "WASM_ENABLE_JIT=1",
            "WASM_ENABLE_LAZY_JIT=1",
        ]
    else:
        return base_defines + [
            "WASM_ENABLE_FAST_INTERP=1",
        ]
