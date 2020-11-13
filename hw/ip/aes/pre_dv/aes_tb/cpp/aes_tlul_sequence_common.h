// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_COMMON_H_
#define OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_COMMON_H_

#define AES_KEY_SHARE0_0 0x4
#define AES_KEY_SHARE1_0 0x24
#define AES_IV_0 0x44
#define AES_DATA_IN_0 0x54
#define AES_DATA_OUT_0 0x64
#define AES_CONFIG 0x74
#define AES_TRIGGER 0x78
#define AES_STATUS 0x7c

#define AES_CTRL_KEY_LEN_OFFSET 7
#define AES_CTRL_MANUAL_OPERATION_OFFSET 10
#define AES_CTRL_FORCE_ZERO_MASKS_OFFSET 11

#endif  // OPENTITAN_HW_IP_AES_PRE_DV_AES_TB_CPP_AES_TLUL_SEQUENCE_COMMON_H_
