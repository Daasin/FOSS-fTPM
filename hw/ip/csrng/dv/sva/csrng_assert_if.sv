// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Interface: csrng_assert_if
// Description: Asserts interface to turn off assertions that have long paths

`define PATH1 \
    tb.dut.u_csrng_core.gen_cmd_stage[2].u_csrng_cmd_stage.u_prim_count_cmd_gen_cntr
`define PATH2 \
    tb.dut.u_csrng_core.u_csrng_block_encrypt.u_aes_cipher_core.u_aes_cipher_control
`define PATH2_1 \
    gen_fsm[0].gen_fsm_p.u_aes_cipher_control_fsm_i.u_aes_cipher_control_fsm
`define PATH2_2 \
    gen_fsm[1].gen_fsm_p.u_aes_cipher_control_fsm_i.u_aes_cipher_control_fsm
`define PATH2_3 \
    gen_fsm[2].gen_fsm_n.u_aes_cipher_control_fsm_i.u_aes_cipher_control_fsm
`define PATH3 \
    tb.dut.u_csrng_core.u_prim_mubi4_sync_cs_enable
`define PATH4 \
    tb.dut.u_csrng_core.u_prim_mubi4_sync_sw_app_enable
`define PATH5 \
    tb.dut.u_csrng_core.u_prim_mubi4_sync_read_int_state

interface csrng_assert_if
(
  input csrng_cmd_i
);

  task automatic assert_off ();
    $assertoff(0, `PATH1.MaxUpCntStable_A);
    $assertoff(0, `PATH1.SimulClrSet_A);
    $assertoff(0, `PATH1.OutSet_A);
    $assertoff(0, `PATH1.gen_cross_cnt_hardening.CrossCntErrBackward_A);
    $assertoff(0, `PATH2.`PATH2_1.AesCipherControlStateValid);
    $assertoff(0, `PATH2.`PATH2_2.AesCipherControlStateValid);
    $assertoff(0, `PATH2.`PATH2_3.AesCipherControlStateValid);
  endtask // assert_off

  task automatic assert_on ();
    $asserton(0, `PATH1.MaxUpCntStable_A);
    $asserton(0, `PATH1.SimulClrSet_A);
    $asserton(0, `PATH1.OutSet_A);
    $asserton(0, `PATH1.gen_cross_cnt_hardening.CrossCntErrBackward_A);
    $asserton(0, `PATH2.`PATH2_1.AesCipherControlStateValid);
    $asserton(0, `PATH2.`PATH2_2.AesCipherControlStateValid);
    $asserton(0, `PATH2.`PATH2_3.AesCipherControlStateValid);
  endtask // assert_on

  task automatic assert_off_alert ();
    $assertoff(0, `PATH3.PrimMubi4SyncCheckTransients_A);
    $assertoff(0, `PATH3.PrimMubi4SyncCheckTransients0_A);
    $assertoff(0, `PATH3.PrimMubi4SyncCheckTransients1_A);

    $assertoff(0, `PATH4.PrimMubi4SyncCheckTransients_A);
    $assertoff(0, `PATH4.PrimMubi4SyncCheckTransients0_A);
    $assertoff(0, `PATH4.PrimMubi4SyncCheckTransients1_A);

    $assertoff(0, `PATH5.PrimMubi4SyncCheckTransients_A);
    $assertoff(0, `PATH5.PrimMubi4SyncCheckTransients0_A);
    $assertoff(0, `PATH5.PrimMubi4SyncCheckTransients1_A);
  endtask // assert_off_alert

  task automatic assert_on_alert ();
    $asserton(0, `PATH3.PrimMubi4SyncCheckTransients_A);
    $asserton(0, `PATH3.PrimMubi4SyncCheckTransients0_A);
    $asserton(0, `PATH3.PrimMubi4SyncCheckTransients1_A);

    $asserton(0, `PATH4.PrimMubi4SyncCheckTransients_A);
    $asserton(0, `PATH4.PrimMubi4SyncCheckTransients0_A);
    $asserton(0, `PATH4.PrimMubi4SyncCheckTransients1_A);

    $asserton(0, `PATH5.PrimMubi4SyncCheckTransients_A);
    $asserton(0, `PATH5.PrimMubi4SyncCheckTransients0_A);
    $asserton(0, `PATH5.PrimMubi4SyncCheckTransients1_A);
  endtask // assert_on_alert
endinterface
