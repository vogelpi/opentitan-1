// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Masked AND gate according to LUT-Masked Dual-Rail Precharge Logic (LMDPL) scheme. See
// [1] Leiserson et al., “Gate-Level Masking Under a Path-Based Leakage Metric”, 2014 and
// [2] Sasdrich et al., "Low-Latency Hardware Masking with Application to AES", 2020

// The generic LMDPL non-linear gate
// This processes the second share only. The first shares are used to generate the table
// values t in the single-rail domain. The precharging is performed via table values t.
module lmdpl_non_linear (
  input  logic [7:0] t_i,
  input  logic       a1_i,
  input  logic       a1_not_i,
  input  logic       b1_i,
  input  logic       b1_not_i,
  output logic       c1_o,
  output logic       c1_not_o
);

  // Operation layer - see Figure 2 [1]
  // The eight AND3 gates.
  (* keep = "true" *) logic [7:0] and3;
  assign and3[7] = t_i[7] & a1_i     & b1_i;
  assign and3[6] = t_i[6] & a1_not_i & b1_i;
  assign and3[5] = t_i[5] & a1_i     & b1_not_i;
  assign and3[4] = t_i[4] & a1_not_i & b1_not_i;

  assign and3[3] = t_i[3] & a1_i     & b1_i;
  assign and3[2] = t_i[2] & a1_not_i & b1_i;
  assign and3[1] = t_i[1] & a1_i     & b1_not_i;
  assign and3[0] = t_i[0] & a1_not_i & b1_not_i;

  // The two OR4 gates.
  (* keep = "true" *) logic c1, c1_not;
  assign c1     = |and3[7:4];
  assign c1_not = |and3[3:0];

  assign c1_o     = c1;
  assign c1_not_o = c1_not;

endmodule

// The actual LMDPL AND gate
// The single-2-dual rail conversion and back is performed internally. The precharging of the
// LMDPL non-linear gate is performed via table values t.
// We have (a0_i ^ a1_i) & (b0_i ^ b1_i) = c0_i ^ c1_i .
module lmdpl_and (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic a0_i,   // a, Share 0
  input  logic a1_i,   // a, Share 1
  input  logic b0_i,   // b, Share 0
  input  logic b1_i,   // b, Share 1
  input  logic r_i,    // mask bit
  output logic c0_o,   // c, Share 0
  output logic c1_o    // c, Share 1
);

  logic a1_not, b1_not;
  logic c1_int, c1_not;
  logic c0, c1;

  // Single-2-dual rail
  assign a1_not = ~a1_i;
  assign b1_not = ~b1_i;

  // Phase tracking
  logic phase_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      phase_q <= 1'b1;
    end else begin
      phase_q <= ~phase_q;
    end
  end

  // LUT-based mask table generator layer - see Table 1 [1].
  assign c0 = r_i;
  (* keep = "true" *) logic [7:0] t, t_q;
  always_comb begin : mask_table_gen
    unique case ( {c0, b0_i, a0_i} )
      3'b000:  t = 8'h87;
      3'b001:  t = 8'h4b;
      3'b010:  t = 8'h2d;
      3'b011:  t = 8'h1e;
      3'b100:  t = 8'h78;
      3'b101:  t = 8'hb4;
      3'b110:  t = 8'hd2;
      3'b111:  t = 8'he1;
      default: t = 8'h87;
    endcase
  end

  // Table registers
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      t_q <= 8'h00;
    end else if (phase_q == 1'b0) begin // precharge & table gen phase
      t_q <= t;
    end else begin // operation phase
      t_q <= 8'h00;
    end
  end

  // Operation layer - see Figure 2 [1].
  lmdpl_non_linear lmdpl_non_linear (
    .t_i      ( t_q    ),
    .a1_i     ( a1_i   ),
    .a1_not_i ( a1_not ),
    .b1_i     ( b1_i   ),
    .b1_not_i ( b1_not ),
    .c1_o     ( c1_int ),
    .c1_not_o ( c1_not )
  );

  // Dual-2-single rail - not sure if that's the right way to do it.
  assign c1 = (c1_int == 1'b1) && (c1_not == 1'b0) ? 1'b1 :
              (c1_int == 1'b0) && (c1_not == 1'b1) ? 1'b0 : 1'b1;

  // Outputs
  assign c0_o = c0;
  assign c1_o = c1;

endmodule
