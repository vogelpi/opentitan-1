// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Scratch verification testbench for Galois multiplier primitive

module prim_galois_mult_tb #(
) (
  input  logic clk_i,
  input  logic rst_ni,

  output logic test_done_o,
  output logic test_passed_o
);

  import prim_galois_mult_model_dpi_pkg::*;

  localparam int Width = 32;
  localparam logic [Width-1:0] Polynomial = (32'b1 << 15 |
                                             32'b1 << 9  |
                                             32'b1 << 7  |
                                             32'b1 << 4  |
                                             32'b1 << 3  |
                                             32'b1 << 0);

  localparam int NumTransactions = 2;

  logic [Width-1:0] operand_a, operand_b;
  logic [Width-1:0] product;
  logic             req, ack;

  logic             handshake;
  logic             rst_done;

  logic     [255:0] product_exp, unused_product_exp;

  // Depending on the Width, the MSBs of product_exp won't be used.
  assign unused_product_exp = product_exp;

  // Instantiate DUT
  prim_gf_mult #(
    .Width         (Width),
    .StagesPerCycle(Width/2),
    .IPoly         (Polynomial)
  ) prim_gf_mult (
    .clk_i      (clk_i),
    .rst_ni     (rst_ni),
    .req_i      (req),
    .operand_a_i(operand_a),
    .operand_b_i(operand_b),
    .ack_o      (ack),
    .prod_o     (product)
  );

  assign handshake = req & ack;

  // Make sure we do not apply stimuli before the reset.
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rst_done <= '1;
    end else begin
      rst_done <= rst_done;
    end
  end

  // For now we just use a counter
  logic [7:0] count_d, count_q;

  assign count_d = (handshake || (rst_done && rst_ni && count_q == '0)) ? count_q + 8'h1 : count_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : reg_count
    if (!rst_ni) begin
      count_q <= '0;
    end else begin
      count_q <= count_d;
    end
  end

  // Apply stimuli
  // TODO apply random stimuli
  always_comb begin
    req       = 1'b0;
    operand_a = '0;
    operand_b = '0;

    if (count_q == 1) begin
      req       = 1'b1;
      operand_a = 32'hFEDCBA98;
      operand_b = 32'h76543210;
    end else if (count_q == 2) begin
      req       = 1'b1;
      operand_a = 32'hA0A05050;
      operand_b = 32'h0A0A0505;
    end else begin
      req       = 1'b0;
      operand_a = 32'hDEADBEEF;
      operand_b = 32'hDEADBEEF;
    end
  end

  // Check responses, signal end of simulation
  always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl
    test_done_o   <= 1'b0;
    test_passed_o <= 1'b1;

    if (req && ack) begin

      // Do the DPI call.
      c_dpi_prim_galois_mult(Width,
        {{{256-Width}{1'b0}},Polynomial},
        {{{256-Width}{1'b0}},operand_a},
        {{{256-Width}{1'b0}},operand_b},
        product_exp);

      if (product_exp[Width-1:0] != product) begin // Failed
        $display("\nERROR: Mismatch between RTL implementation and DPI model detected.");
        $display("RTL impl:  0x%x", product);
        $display("DPI model: 0x%x\n", product_exp[Width-1:0]);

        test_passed_o <= 1'b0;
        test_done_o   <= 1'b1;
      end else if (int'(count_q) < NumTransactions) begin // Success
        $display("SUCCESS: RTL implementation and DPI model match.");
      end else begin // Test passed
        $display("SUCCESS: RTL implementation and DPI model match.");
        $display("Finishing simulation now.\n");
        test_passed_o <= 1'b1;
        test_done_o   <= 1'b1;
      end
    end
  end

endmodule
