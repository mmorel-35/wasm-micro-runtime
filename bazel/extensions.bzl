"""
Bazel extensions for WAMR

This file provides module extensions for optional WAMR features like JIT support.
"""

def _llvm_repository_impl(repository_ctx):
    """
    Repository rule for LLVM project.
    This is a placeholder that users can override with their LLVM source.
    """
    # Create a minimal BUILD file
    repository_ctx.file("BUILD.bazel", """
# LLVM repository
# Users should override this with their actual LLVM source using git_override
# or archive_override in their MODULE.bazel

# Example BUILD file for LLVM
# See LLVM documentation for building LLVM with Bazel
""")

llvm_repository = repository_rule(
    implementation = _llvm_repository_impl,
    doc = "Creates a placeholder LLVM repository that users can override",
)

def _wamr_jit_impl(module_ctx):
    """
    Extension for WAMR JIT support configuration.
    Users can use this to configure LLVM dependency for JIT builds.
    """
    # Create LLVM repository placeholder
    llvm_repository(name = "llvm")
    
    return module_ctx.extension_metadata(
        root_module_direct_deps = ["llvm"],
        root_module_direct_dev_deps = [],
    )

wamr_jit = module_extension(
    implementation = _wamr_jit_impl,
    doc = """
    Extension for configuring WAMR JIT support.
    
    Example usage in MODULE.bazel:
        wamr_jit = use_extension("@wamr//bazel:extensions.bzl", "wamr_jit")
        use_repo(wamr_jit, "llvm")
    """,
)
