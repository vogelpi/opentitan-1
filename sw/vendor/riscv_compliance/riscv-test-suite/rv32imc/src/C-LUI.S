# RISC-V Compliance Test RV32IMC-C.LUI-01
#
# Copyright (c) 2018, Imperas Software Ltd.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#      * Redistributions of source code must retain the above copyright
#        notice, this list of conditions and the following disclaimer.
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#      * Neither the name of the Imperas Software Ltd. nor the
#        names of its contributors may be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Imperas Software Ltd. BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Specification: RV32IMC Base Integer Instruction Set, Version 2.0
# Description: Testing instruction C.LUI.

#include "test_macros.h"
#include "compliance_test.h"
#include "compliance_io.h"

RV_COMPLIANCE_RV32M

RV_COMPLIANCE_CODE_BEGIN

	RVTEST_IO_INIT
	RVTEST_IO_ASSERT_GPR_EQ(x31, x0, 0x00000000)
	RVTEST_IO_WRITE_STR(x31, "Test Begin Reserved regs ra(x1) a0(x10) t0(x5)\n")

	# ---------------------------------------------------------------------------------------------

	RVTEST_IO_WRITE_STR(x31, "# Test number 1 - corner cases\n")

	# address for test results
	la	x2, test_1_res

	TEST_CI_OP(c.lui, x3, 0x1000, 0x0, 0x1, x2, 0)
	TEST_CI_OP(c.lui, x4, 0x2000, 0x0, 0x2, x2, 4)
	TEST_CI_OP(c.lui, x8, 0xf000, 0x0, 0xf, x2, 8)
	TEST_CI_OP(c.lui, x9, 0x0001f000, 0x0, 0x1f, x2, 12)
	TEST_CI_OP(c.lui, x11, 0xfffff000, 0x0, 0xfffff, x2, 16)

	# ---------------------------------------------------------------------------------------------

	RVTEST_IO_WRITE_STR(x31, "# Test number 2 - corner cases\n")

	# address for test results
	la	x2, test_2_res

	TEST_CI_OP(c.lui, x12, 0x1000, 0x1, 0x1, x2, 0)
	TEST_CI_OP(c.lui, x13, 0x2000, 0x1, 0x2, x2, 4)
	TEST_CI_OP(c.lui, x14, 0xf000, 0x1, 0xf, x2, 8)
	TEST_CI_OP(c.lui, x15, 0x0001f000, 0x1, 0x1f, x2, 12)
	TEST_CI_OP(c.lui, x16, 0xfffff000, 0x1, 0xfffff, x2, 16)

	# ---------------------------------------------------------------------------------------------

	RVTEST_IO_WRITE_STR(x31, "# Test number 3 - corner cases\n")

	# address for test results
	la	x2, test_3_res

	TEST_CI_OP(c.lui, x17, 0x1000, -0x1, 0x1, x2, 0)
	TEST_CI_OP(c.lui, x18, 0x2000, -0x1, 0x2, x2, 4)
	TEST_CI_OP(c.lui, x19, 0xf000, -0x1, 0xf, x2, 8)
	TEST_CI_OP(c.lui, x20, 0x0001f000, -0x1, 0x1f, x2, 12)
	TEST_CI_OP(c.lui, x21, 0xfffff000, -0x1, 0xfffff, x2, 16)

	# ---------------------------------------------------------------------------------------------

	RVTEST_IO_WRITE_STR(x31, "# Test number 4 - corner cases\n")

	# address for test results
	la	x2, test_4_res

	TEST_CI_OP(c.lui, x22, 0x1000, 0x7ffff, 0x1, x2, 0)
	TEST_CI_OP(c.lui, x23, 0x2000, 0x7ffff, 0x2, x2, 4)
	TEST_CI_OP(c.lui, x24, 0xf000, 0x7ffff, 0xf, x2, 8)
	TEST_CI_OP(c.lui, x25, 0x0001f000, 0x7ffff, 0x1f, x2, 12)
	TEST_CI_OP(c.lui, x26, 0xfffff000, 0x7ffff, 0xfffff, x2, 16)

	# ---------------------------------------------------------------------------------------------

	RVTEST_IO_WRITE_STR(x31, "# Test number 5 - corner cases\n")

	# address for test results
	la	x2, test_5_res

	TEST_CI_OP(c.lui, x27, 0x1000, 0x80000, 0x1, x2, 0)
	TEST_CI_OP(c.lui, x28, 0x2000, 0x80000, 0x2, x2, 4)
	TEST_CI_OP(c.lui, x29, 0xf000, 0x80000, 0xf, x2, 8)
	TEST_CI_OP(c.lui, x30, 0x0001f000, 0x80000, 0x1f, x2, 12)
	TEST_CI_OP(c.lui, x21, 0xfffff000, 0x80000, 0xfffff, x2, 16)

	RVTEST_IO_WRITE_STR(x31, "Test End\n")

	# ---------------------------------------------------------------------------------------------

	RV_COMPLIANCE_HALT

RV_COMPLIANCE_CODE_END

# Input data section.
	.data

# Output data section.
RV_COMPLIANCE_DATA_BEGIN
test_1_res:
	.fill 5, 4, -1
test_2_res:
	.fill 5, 4, -1
test_3_res:
	.fill 5, 4, -1
test_4_res:
	.fill 5, 4, -1
test_5_res:
	.fill 5, 4, -1

RV_COMPLIANCE_DATA_END
