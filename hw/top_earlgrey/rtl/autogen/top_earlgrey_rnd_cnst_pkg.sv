// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// ------------------- W A R N I N G: A U T O - G E N E R A T E D   C O D E !! -------------------//
// PLEASE DO NOT HAND-EDIT THIS FILE. IT HAS BEEN AUTO-GENERATED WITH THE FOLLOWING COMMAND:
//
// util/topgen.py -t hw/top_earlgrey/data/top_earlgrey.hjson \
//                -o hw/top_earlgrey/ \
//                --rnd_cnst_seed 4881560218908238235


package top_earlgrey_rnd_cnst_pkg;

  ////////////////////////////////////////////
  // otp_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter otp_ctrl_pkg::lfsr_seed_t RndCnstOtpCtrlLfsrSeed = {
    40'hF45DEF7861
  };

  // Compile-time random permutation for LFSR output
  parameter otp_ctrl_pkg::lfsr_perm_t RndCnstOtpCtrlLfsrPerm = {
    240'h5D294061E29A7C404F4593035A19097666E37072064153623855022D39E0
  };

  ////////////////////////////////////////////
  // lc_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivInvalid = {
    64'h4440722325A93144
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivTestDevRma = {
    64'hFDB92558E2D9C5D2
  };

  // Compile-time random bits for lc state group diversification value
  parameter lc_ctrl_pkg::lc_keymgr_div_t RndCnstLcCtrlLcKeymgrDivProduction = {
    64'hD1C09F5C02B2C8D1
  };

  ////////////////////////////////////////////
  // alert_handler
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter alert_pkg::lfsr_seed_t RndCnstAlertHandlerLfsrSeed = {
    32'h2BCCD612
  };

  // Compile-time random permutation for LFSR output
  parameter alert_pkg::lfsr_perm_t RndCnstAlertHandlerLfsrPerm = {
    160'hB265E7161A57CD840E2D9B32B38A840DC1C7F6BB
  };

  ////////////////////////////////////////////
  // sram_ctrl_ret_aon
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlRetAonSramKey = {
    128'h9FBB73A9BF8C393C12965C7DE10023EC
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlRetAonSramNonce = {
    128'h1D7D9D0CE1DD7D7C60C06703B494B3FF
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlRetAonSramLfsrPerm = {
    160'h8C24F71703EDA8A2378916B6BF80C76651EBCEA1
  };

  ////////////////////////////////////////////
  // flash_ctrl
  ////////////////////////////////////////////
  // Compile-time random bits for default address key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlAddrKey = {
    128'h48BAE844C87B69111A24D5E4442BCFB7
  };

  // Compile-time random bits for default data key
  parameter flash_ctrl_pkg::flash_key_t RndCnstFlashCtrlDataKey = {
    128'hEEC5E43D4B16446726A27B8F0B30AD50
  };

  // Compile-time random bits for initial LFSR seed
  parameter flash_ctrl_pkg::lfsr_seed_t RndCnstFlashCtrlLfsrSeed = {
    32'h369AE283
  };

  // Compile-time random permutation for LFSR output
  parameter flash_ctrl_pkg::lfsr_perm_t RndCnstFlashCtrlLfsrPerm = {
    160'hB0DD7870FFED25342F40F3D8926051DA8B96D426
  };

  ////////////////////////////////////////////
  // aes
  ////////////////////////////////////////////
  // Default seed of the PRNG used for register clearing.
  parameter aes_pkg::clearing_lfsr_seed_t RndCnstAesClearingLfsrSeed = {
    64'hED204633871CB178
  };

  // Permutation applied to the LFSR of the PRNG used for clearing.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingLfsrPerm = {
    128'h99B01E35560F2EB97E3047685D6B7BD8,
    256'h7B029229DA078DF923F7D0F46154C34BA9D43C734AF2A1EAA8E0F3270944E4D9
  };

  // Permutation applied to the clearing PRNG output for clearing the second share of registers.
  parameter aes_pkg::clearing_lfsr_perm_t RndCnstAesClearingSharePerm = {
    128'h7D9CF783C36C02E6CBD0C89A7299BAC2,
    256'h45B9FB80C85367BB5E53C511341509877FB72286F4E9E3047871A354AFAD126A
  };

  // Default seed of the PRNG used for masking.
  parameter aes_pkg::masking_lfsr_seed_t RndCnstAesMaskingLfsrSeed = {
    104'h8C93C933AA7733B0A12CA43BFD,
    256'h7E257220CD6A8BF51BED7DB0D6E49C544BA9DCDFF0245E84D6F5F03ECAEF7217
  };

  // Permutation applied to the LFSR chunks of the PRNG used for masking.
  parameter aes_pkg::mskg_chunk_lfsr_perm_t RndCnstAesMskgChunkLfsrPerm = {
    216'hA08541C67D84568DD4886D540E70524A2C030D5DE4CF0C16446A2
  };

  ////////////////////////////////////////////
  // keymgr
  ////////////////////////////////////////////
  // Compile-time random bits for initial LFSR seed
  parameter keymgr_pkg::lfsr_seed_t RndCnstKeymgrLfsrSeed = {
    64'h8CCEC99F160326DB
  };

  // Compile-time random permutation for LFSR output
  parameter keymgr_pkg::lfsr_perm_t RndCnstKeymgrLfsrPerm = {
    128'hCF870453F91542EF5274D2F1D8505388,
    256'hEF296FA988DC32651DA3E7D2D60CB2AF828D1ED7D6F2995B07E086BCA81B901E
  };

  // Compile-time random permutation for entropy used in share overriding
  parameter keymgr_pkg::rand_perm_t RndCnstKeymgrRandPerm = {
    160'hA63904C7E8B7AE11C88E9E45B3754C5E8AF054ED
  };

  // Compile-time random bits for revision seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrRevisionSeed = {
    256'h603C2154BE52121D214556318C84C8EC175DAB2F18800440BD414D266DE08FC4
  };

  // Compile-time random bits for creator identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrCreatorIdentitySeed = {
    256'h2144F3EEFEEDD9D57E3F829A880463A023CA0C5E653FADB4AEE4626498A4C647
  };

  // Compile-time random bits for owner intermediate identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIntIdentitySeed = {
    256'hC3B7D06751F2882DF8F3259134067E7A112FFDB3D5C72146D889ACA6973A1327
  };

  // Compile-time random bits for owner identity seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrOwnerIdentitySeed = {
    256'h52213B7A034816103A781D0A4F5A0A911C1BCAFE7663F6D1FBE7E4402C0329CA
  };

  // Compile-time random bits for software generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrSoftOutputSeed = {
    256'hADA112F1235EE7DBA5042C13061068C02CEF00B70BC5F1A88628458527616033
  };

  // Compile-time random bits for hardware generation seed
  parameter keymgr_pkg::seed_t RndCnstKeymgrHardOutputSeed = {
    256'h262A6E3AB1655D42B3090AE475A2DF4171FDFD7C63DD2AF7CA1C6AE78EFCBDC6
  };

  // Compile-time random bits for generation seed when aes destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrAesSeed = {
    256'hA710B72B92E47F6E0845F450EAD8F3095FF32C3256289223D7E05DB35983FE5A
  };

  // Compile-time random bits for generation seed when hmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrHmacSeed = {
    256'h96AE771B3A1955E3D4549F3608232D03F93EED0FE9D1B1F891DCAB64F5A52883
  };

  // Compile-time random bits for generation seed when kmac destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrKmacSeed = {
    256'h74487A86B6FEE0311AF608B7123F603C251A36AB2E658548C5420BE549DA272D
  };

  // Compile-time random bits for generation seed when no destination selected
  parameter keymgr_pkg::seed_t RndCnstKeymgrNoneSeed = {
    256'hA07DB44FE8C330CA072829F9970F91074501568220E25BA7743095F2C1194FB
  };

  ////////////////////////////////////////////
  // sram_ctrl_main
  ////////////////////////////////////////////
  // Compile-time random reset value for SRAM scrambling key.
  parameter otp_ctrl_pkg::sram_key_t RndCnstSramCtrlMainSramKey = {
    128'h3AC42FA70CB942155264F8C121B7387A
  };

  // Compile-time random reset value for SRAM scrambling nonce.
  parameter otp_ctrl_pkg::sram_nonce_t RndCnstSramCtrlMainSramNonce = {
    128'h52F1C7741DD6E62190D79F1230D02F64
  };

  // Compile-time random permutation for LFSR output
  parameter sram_ctrl_pkg::lfsr_perm_t RndCnstSramCtrlMainSramLfsrPerm = {
    160'hA64E55DF527BB916110187C69DF7D66E260AA8C2
  };

endpackage : top_earlgrey_rnd_cnst_pkg
