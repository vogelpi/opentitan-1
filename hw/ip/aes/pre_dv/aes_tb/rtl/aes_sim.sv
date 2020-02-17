// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AES simulation wrapper

module aes_sim #(
  parameter bit AES192Enable = 1,
  parameter     SBoxImpl     = "lut"
) (
  input                     clk_i,
  input                     rst_ni,

  // Bus Interface
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o
);

  import aes_reg_pkg::*;

  // Instantiate top-level
  aes #(
    .AES192Enable ( AES192Enable ),
    .SBoxImpl     ( SBoxImpl     )
  ) aes (
    .clk_i,
    .rst_ni,
    .tl_i,
    .tl_o
  );

  // Signals for controlling model checker
  logic        start /*verilator public_flat*/;
  logic        init  /*verilator public_flat*/;
  logic        done  /*verilator public_flat*/;
  logic        busy  /*verilator public_flat*/;

  assign start = ({aes.aes_core.aes_cipher_core.aes_cipher_control.aes_cipher_ctrl_ns} == 3'b001);  // IDLE -> INIT
  assign init  = ({aes.aes_core.aes_cipher_core.aes_cipher_control.aes_cipher_ctrl_cs} == 3'b001);  // INIT
  assign done  = ({aes.aes_core.aes_cipher_core.aes_cipher_control.aes_cipher_ctrl_ns} == 3'b000) & // FINISH -> IDLE
                 ({aes.aes_core.aes_cipher_core.aes_cipher_control.aes_cipher_ctrl_cs} == 3'b011);
  assign busy  = ~aes.aes_core.aes_control.idle_o &
                 ({aes.aes_core.aes_control.aes_ctrl_ns} != 2'b11) & // CLEAR
                 ({aes.aes_core.aes_control.aes_ctrl_cs} != 2'b11);

  // Make internal signals directly accessible
  // control
  logic        cipher_op     /*verilator public_flat*/;
  logic        key_expand_op /*verilator public_flat*/;
  logic  [2:0] key_len       /*verilator public_flat*/;
  logic  [3:0] round         /*verilator public_flat*/;

  assign cipher_op     = {aes.aes_core.aes_cipher_core.op_i};
  assign key_expand_op = {aes.aes_core.aes_cipher_core.aes_key_expand.op_i};
  assign key_len       = {aes.aes_core.aes_cipher_core.key_len_i};
  assign round         = aes.aes_core.aes_cipher_core.aes_cipher_control.round_q;

  // data
  logic [31:0] data_in[4]            /*verilator public_flat*/;
  logic  [7:0] state_d[16]           /*verilator public_flat*/;
  logic  [7:0] state_q[16]           /*verilator public_flat*/;
  logic  [7:0] sub_bytes_out[16]     /*verilator public_flat*/;
  logic  [7:0] shift_rows_out[16]    /*verilator public_flat*/;
  logic  [7:0] mix_columns_out[16]   /*verilator public_flat*/;
  logic  [7:0] add_round_key_out[16] /*verilator public_flat*/;
  logic [31:0] data_out_d[4]         /*verilator public_flat*/;

  logic [31:0] key_full_q[8] /*verilator public_flat*/;
  logic  [7:0] round_key[16] /*verilator public_flat*/;

  logic  [7:0] rcon_q /*verilator public_flat*/;

  // bytes
  for (genvar j=0; j<4; j++) begin : columns
    for (genvar i=0; i<4; i++) begin : rows
      assign state_d[4*j+i]           = aes.aes_core.aes_cipher_core.state_d[i][j];
      assign state_q[4*j+i]           = aes.aes_core.aes_cipher_core.state_q[i][j];
      assign sub_bytes_out[4*j+i]     = aes.aes_core.aes_cipher_core.sub_bytes_out[i][j];
      assign shift_rows_out[4*j+i]    = aes.aes_core.aes_cipher_core.shift_rows_out[i][j];
      assign mix_columns_out[4*j+i]   = aes.aes_core.aes_cipher_core.mix_columns_out[i][j];
      assign add_round_key_out[4*j+i] = aes.aes_core.aes_cipher_core.add_round_key_out[i][j];
      assign round_key[4*j+i]         = aes.aes_core.aes_cipher_core.round_key[i][j];
    end
  end

  // words - data
  for (genvar i = 0; i<4; i++) begin : gen_access_to_words_data
    assign data_in[i]           = aes.aes_core.data_in[i];
    assign data_out_d[i]        = aes.aes_core.data_out_d[i];
  end

  // words - key
  for (genvar i = 0; i<8; i++) begin : gen_access_to_words_key
    assign key_full_q[i]        = aes.aes_core.aes_cipher_core.key_full_q[i];
  end

  assign rcon_q = aes.aes_core.aes_cipher_core.aes_key_expand.rcon_q;

endmodule