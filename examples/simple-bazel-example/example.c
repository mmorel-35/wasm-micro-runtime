/*
 * Copyright (C) 2019 Intel Corporation.  All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

/*
 * Simple example demonstrating WAMR library usage with Bazel.
 * This is a minimal example that initializes and cleans up the WAMR runtime.
 */

#include <stdio.h>
#include <stdlib.h>
#include "wasm_export.h"

int main(int argc, char *argv[])
{
    /* Initialize the WASM runtime */
    if (!wasm_runtime_init()) {
        fprintf(stderr, "Failed to initialize WASM runtime\n");
        return 1;
    }

    printf("WAMR runtime initialized successfully with Bazel build!\n");

    /* Clean up */
    wasm_runtime_destroy();
    
    printf("WAMR runtime destroyed successfully\n");
    
    return 0;
}
