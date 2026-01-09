/*
 * Copyright (C) 2019 Intel Corporation.  All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

/*
 * Simple test for WAMR library built with Bazel.
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "wasm_export.h"

int main(int argc, char *argv[])
{
    /* Test: Initialize the WASM runtime */
    int result = wasm_runtime_init();
    assert(result == 1);
    
    printf("Test passed: WAMR runtime initialized\n");

    /* Test: Clean up */
    wasm_runtime_destroy();
    
    printf("Test passed: WAMR runtime destroyed\n");
    printf("All tests passed!\n");
    
    return 0;
}
