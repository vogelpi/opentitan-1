// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// LMDPL AND testbench

module lmdpl_and_tb #(
) (
  input  logic clk_i,
  input  logic rst_ni,

  output logic test_done_o,
  output logic test_passed_o
);

  logic [2:0] pre_count_d, pre_count_q;
  logic [4:0] count_d, count_q;
  logic       a, b, c, c_exp;
  logic       a0, a1, b0, b1, r, c0, c1;
  logic       output_ready;

  // Counter to controlling the response checking and kick starting the stimuli generator.
  assign pre_count_d = (pre_count_q != 3'h7) ? pre_count_q + 3'h1 : pre_count_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : reg_pre_count
    if (!rst_ni) begin
      pre_count_q <= '0;
    end else begin
      pre_count_q <= pre_count_d;
    end
  end

  assign output_ready = lmdpl_and.phase_q;

  // Generate the stimuli
  assign count_d = (pre_count_q == 3'h7) ? count_q + 5'h1 : count_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : reg_count
    if (!rst_ni) begin
      count_q <= '0;
    end else if (output_ready == 1'b1) begin
      count_q <= count_d;
    end
  end

  assign a0 = count_q[0];
  assign a1 = count_q[1];
  assign b0 = count_q[2];
  assign b1 = count_q[3];
  assign r  = count_q[4];

  // Expected repsonse
  assign a     = a0 ^ a1;
  assign b     = b0 ^ b1;
  assign c_exp = a & b;

  // Instantiate LMDPL gate
  lmdpl_and lmdpl_and (
    .clk_i  ( clk_i  ),
    .rst_ni ( rst_ni ),
    .a0_i   ( a0     ),   // a, Share 0
    .a1_i   ( a1     ),   // a, Share 1
    .b0_i   ( b0     ),   // b, Share 0
    .b1_i   ( b1     ),   // b, Share 1
    .r_i    ( r      ),   // mask bit
    .c0_o   ( c0     ),   // c, Share 0
    .c1_o   ( c1     )    // c, Share 1
  );

  // Unmask response
  assign c = c0 ^ c1;

  // Check responses, signal end of simulation
  always_ff @(posedge clk_i or negedge rst_ni) begin : tb_ctrl
    test_done_o   <= 1'b0;
    test_passed_o <= 1'b1;

    if ((pre_count_q == 3'h7) && (output_ready && (c != c_exp))) begin
      $display("\nERROR: Mismatch between LMDPL AND gate and unmasked AND gate found.");
      $display("count_q = %0d, a0 = %0d, a1 = %0d, b0 = %0d, b1 = %0d, c_exp = %0d",
          count_q, a0, a1, b0, b1, c_exp);
      $display("c0 = %0d, c1 = %0d, c = %0d", c0, c1, c);
      test_passed_o <= 1'b0;
      test_done_o   <= 1'b1;
    end

    if (count_q == 5'h1F) begin
      $display("\nSUCCESS: All inputs lead to the correct output.");
      test_done_o <= 1'b1;
    end
  end

endmodule
