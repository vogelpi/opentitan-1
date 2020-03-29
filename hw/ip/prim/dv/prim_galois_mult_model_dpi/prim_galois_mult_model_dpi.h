// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef _PRIM_GALOIS_MULT_MODEL_DPI_H_
#define _PRIM_GALOIS_MULT_MODEL_DPI_H_

#include "svdpi.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Perform multiplication of operand_a_i and operand_b_i over Galois field
 * with irreducable, field-generating polynomial ipoly_i.
 *
 * All arguments except for width_i are represented by a 1D packed array
 * in SystemVerilog.
 *
 * @param  width_i     Input width or degree of the Galois field
 * @param  ipoly_i     Input field-generating, irreducible polynomial
 * @param  operand_b_i Input operand A
 * @param  operand_b_i Input operand B
 * @param  prod_o      Output product
 */
void c_dpi_prim_galois_mult(int width_i, const svBitVecVal *ipoly_i,
                            const svBitVecVal *operand_a_i,
                            const svBitVecVal *operand_b_i,
                            svBitVecVal *prod_o);

/**
 * Get packed data block from simulation.
 *
 * @param  data_i    Input data from simulation
 * @param  num_words Number of 32-bit words to get
 * @return Pointer to data copied to memory, 0 in case of an error
 */
uint32_t *prim_galois_mult_data_get(const svBitVecVal *data_i, int num_words);

/**
 * Write packed data block to simulation and free the source buffer afterwards.
 *
 * @param  data_o    Output data for simulation
 * @param  data      Data to be copied to simulation, freed after the operation
 * @param  num_words Number of 32-bit words to put
 */
void prim_galois_mult_data_put(svBitVecVal *data_o, uint32_t *data,
                               int num_words);

#ifdef __cplusplus
}  // extern "C"
#endif
#endif  // _PRIM_GALOIS_MULT_MODEL_DPI_H_
