// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <python3.6/Python.h>
#include "svdpi.h"

#include "prim_galois_mult_model_dpi.h"

void c_dpi_prim_galois_mult(int width_i, const svBitVecVal *ipoly_i,
                            const svBitVecVal *operand_a_i,
                            const svBitVecVal *operand_b_i,
                            svBitVecVal *prod_o) {
  // Check width.
  if (width_i > 256) {
    printf(
        "ERROR: We currently don't support widths > 256 in "
        "c_dpi_prim_galois_mult\n");
    return;
  }

  // Find out how many words we need to get from the simulator.
  // See: SystemVerilog LRM H.7.7:
  // "Packed arrays are represented as an array of one or more elements, each
  // element representing a group of 32 bits."
  int num_words = width_i / 32;
  if (width_i % 32) {
    num_words++;
  }

  // Get input data from simulator.
  uint32_t *ipoly = prim_galois_mult_data_get(ipoly_i, num_words);
  uint32_t *operand_a = prim_galois_mult_data_get(operand_a_i, num_words);
  uint32_t *operand_b = prim_galois_mult_data_get(operand_b_i, num_words);

  // Allocate memory for output.
  uint32_t *prod = (uint32_t *)malloc(num_words * sizeof(uint32_t));
  if (!prod) {
    printf("ERROR: malloc() for c_dpi_prim_galois_mult failed\n");
    return;
  }

  //////////////////
  // Python Setup //
  //////////////////

  // Make sure the Python script is actually found by configuring PYTHONPATH.
  // The script is located in the build folder, i.e., where the actual binary we
  // are running is.
  size_t buf_len = 128;
  ssize_t ret;
  char *buf;
  while (1) {
    buf = (char *)malloc(buf_len * sizeof(char));
    if (!buf) {
      printf("ERROR: malloc() for c_dpi_prim_galois_mult failed\n");
      return;
    }

    // Get path of executable.
    ret = readlink("/proc/self/exe", buf, buf_len);

    if (ret == -1) {
      printf("ERROR: readlink() for c_dpi_prim_galois_mult failed\n");
      return;
    } else if (ret < (ssize_t)buf_len) {
      // Success
      // Append terminating null character.
      buf[buf_len] = '\0';
      break;
    } else {
      // Path truncated to maximum length. Repeat with larger buffer.
      free(buf);
      buf_len = buf_len * 2;
    }
  }

  // Remove executable name from path.
  char *last_slash = strrchr(buf, '/');
  if (!last_slash) {
    // We execute from the directory of the binary.
    buf_len = 1;
    buf[0] = '.';
  } else {
    buf_len = (size_t)(last_slash - buf);
  }
  buf[buf_len] = '\0';

  // Append binary path to PYTHONPATH.
  char *python_path = getenv("PYTHONPATH");
  if (!python_path) {
    setenv("PYTHONPATH", buf, 1);
  } else {
    // Is the binary path already in the PYTHONPATH?
    char *bin_path = strstr(python_path, buf);
    if (!bin_path) {
      // Append
      size_t python_path_len = strlen(python_path);
      size_t path_len = buf_len + 1 + python_path_len;
      char *path = (char *)malloc(path_len * sizeof(char));
      if (!path) {
        printf("ERROR: malloc() for c_dpi_prim_galois_mult failed\n");
        return;
      }
      strcpy(path, python_path);
      path[python_path_len] = ':';
      strcpy(&path[python_path_len + 1], buf);
      setenv("PYTHONPATH", path, 1);
      free(path);
    }
  }

  // python_path = getenv("PYTHONPATH");
  // printf("This is the new PYTHONPATH: %s\n", python_path);

  //////////////
  // pyfinite //
  //////////////

  // Set up the command line arguments.
  // The actual arguments are passed as wide char strings.
  char python_script_name[32] = "prim_galois_mult_model_dpi";
  wchar_t argv_python_script_name[32] = L"prim_galois_mult_model_dpi";
  // Width is passed as hex number (max 256 = 9 bits).
  size_t len_width = 3 + 3;
  wchar_t argv_width[len_width];
  swprintf(argv_width, len_width, L"%#x", width_i);

  // Polynomial and operands are passed as hex numbers (max 256 bits)
  size_t len_numbers = 256 / 32 * 8 + 3;
  wchar_t argv_ipoly[len_numbers];
  wchar_t argv_operand_a[len_numbers];
  wchar_t argv_operand_b[len_numbers];
  swprintf(argv_ipoly, 3, L"0x");
  swprintf(argv_operand_a, 3, L"0x");
  swprintf(argv_operand_b, 3, L"0x");
  // Print one word (8 characters) per iteration, start with most signitficant
  // word.
  for (int i = 0; i < num_words; ++i) {
    swprintf(&argv_ipoly[2 + i * 8], 9, L"%0x", ipoly[num_words - 1 - i]);
    swprintf(&argv_operand_a[2 + i * 8], 9, L"%0x",
             operand_a[num_words - 1 - i]);
    swprintf(&argv_operand_b[2 + i * 8], 9, L"%0x",
             operand_b[num_words - 1 - i]);
  }

  int argc = 5;
  wchar_t *argv[argc];
  argv[0] = argv_python_script_name;
  argv[1] = argv_width;
  argv[2] = argv_ipoly;
  argv[3] = argv_operand_a;
  argv[4] = argv_operand_b;

  // Do the call.
  Py_Initialize();
  PySys_SetArgv(argc, argv);
  PyObject *python_script = PyImport_ImportModule(python_script_name);
  if (!python_script) {
    printf("ERROR: Python script %s failed\n", python_script_name);
    PyErr_Print();
    return;
  }

  // Get back the result.
  PyObject *python_product =
      PyObject_GetAttrString(python_script, "product_string");
  if (!python_product) {
    printf("ERROR: Could not get reference to Python product\n");
    PyErr_Print();
    return;
  }
  if (!PyUnicode_Check(python_product)) {
    printf("ERROR: Python product is not unicode\n");
    PyErr_Print();
    return;
  }
  PyObject *python_bytes =
      PyUnicode_AsEncodedString(python_product, "UTF-8", "strict");
  char *product_string;
  if (python_bytes) {
    product_string = PyBytes_AsString(python_bytes);
    product_string = strdup(product_string);
  } else {
    printf("ERROR: Could not get Python product\n");
    PyErr_Print();
    return;
  }

  // Debug print
  // printf("%s\n", product_string);

  // Free memory.
  Py_DECREF(python_bytes);
  Py_DECREF(python_product);
  Py_DECREF(python_script);
  Py_Finalize();

  // Convert product_string back into an array of uint32_t for simulator.
  size_t len_product = strlen(product_string);
  // We start from the back of the string (least significant word)
  size_t idx_start = len_product;
  for (int i = 0; i < num_words - 1; ++i) {
    idx_start = -8;
    prod[i] = strtol((const char *)&product_string[idx_start], NULL, 16);
    // Move the terminating null character
    product_string[idx_start] = '\0';

    // Debug print
    // printf("%s\n", product_string);
  }
  // The last word might need padding.
  idx_start = 2;
  prod[num_words - 1] =
      strtol((const char *)&product_string[idx_start], NULL, 16);

  // Debug print
  // for (int i = 0; i < num_words; ++i) {
  //  printf("%#x\n", ipoly[i]);
  //}
  // printf("\n");
  // for (int i = 0; i < num_words; ++i) {
  //  printf("%#x\n", operand_a[i]);
  //}
  // printf("\n");
  // for (int i = 0; i < num_words; ++i) {
  //  printf("%#x\n", operand_b[i]);
  //}
  // printf("\n");
  // for (int i = 0; i < num_words; ++i) {
  //  printf("%#x\n", prod[i]);
  //}
  // printf("\n");

  // Write output data back to simulator, free prod.
  prim_galois_mult_data_put(prod_o, prod, num_words);

  // Free memory.
  free(product_string);
  free(buf);
  free(ipoly);
  free(operand_a);
  free(operand_b);

  return;
}

uint32_t *prim_galois_mult_data_get(const svBitVecVal *data_i, int num_words) {
  uint32_t *data;
  svBitVecVal value;

  // Alloc data buffer.
  data = (uint32_t *)malloc(num_words * sizeof(uint32_t));
  if (!data) {
    printf("ERROR: malloc() for prim_galois_mult_data_get failed\n");
    return 0;
  }

  // Get data from simulator.
  for (int i = 0; i < num_words; ++i) {
    value = data_i[i];
    data[i] = (uint32_t)value;
  }

  return data;
}

void prim_galois_mult_data_put(svBitVecVal *data_o, uint32_t *data,
                               int num_words) {
  svBitVecVal value;

  // Write output data to simulator.
  for (int i = 0; i < num_words; ++i) {
    value = (svBitVecVal)data[i];
    data_o[i] = value;
  }

  // Write remaining (unused) MSBs to 0.
  for (int i = num_words; i < 256 / 32; ++i) {
    data_o[i] = 0;
  }

  // Free data buffer.
  free(data);

  return;
}
