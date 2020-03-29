// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

package prim_galois_mult_model_dpi_pkg;

  localparam int WidthMax = 256;

  // DPI-C imports
  import "DPI-C" context function void c_dpi_prim_galois_mult(
    input  int               width_i,
    input  bit[WidthMax-1:0] ipoly_i,
    input  bit[WidthMax-1:0] operand_a_i,
    input  bit[WidthMax-1:0] operand_b_i,
    output bit[WidthMax-1:0] prod_o,
  );

endpackage
