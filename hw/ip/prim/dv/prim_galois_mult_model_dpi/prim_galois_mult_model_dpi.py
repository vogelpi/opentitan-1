#!/usr/bin/env python3
# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
r"""Command-line tool to perfrom a multiplication in GF(2^Width)

"""

import sys
from pyfinite import ffield

# Check number of command line arguments
if (len(sys.argv) < 5):
  raise(Exception('Usage: prim_galois_mult_model_dpi.py Width polynomial operand_a operand_b'))

# Parse command line arguments
width = int(sys.argv[1],0)
poly = 2**width + int(sys.argv[2],0)
operand_a = int(sys.argv[3],0)
operand_b = int(sys.argv[4],0)

# Generate the field
field = ffield.FField(width, poly)

# Do the multiplication
product = field.Multiply(operand_a, operand_b)

# Convert to string for C
product_string = hex(product)

# Debug print
#print(str(sys.argv))
#print(field.ShowPolynomial(field.generator))
#print(field.ShowPolynomial(operand_a))
#print(field.ShowPolynomial(operand_b))
#print(field.ShowPolynomial(product))
#print(product_string)
