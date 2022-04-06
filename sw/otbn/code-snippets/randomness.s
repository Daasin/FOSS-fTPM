/* Copyright lowRISC contributors. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

/* Test access to randomness from OTBN. */

.section .text.start
/* Test entry point, no arguments need to be passed in nor results returned */
.globl main
main:
  jal x1, test_rnd
  jal x1, test_urnd

  jal x0, exit_success


.text
/**
 * Tests access to cryptographic-strength randomness.
 *
 * Test reading from the RND CSR and WSR, as well as prefetching randomness
 * through RND_PREFETCH.
 *
 * This test increases confidence in the functional correctness of the RND
 * functionality, but isn't free of false positives or negatives.
 *
 * - The test considers it a failure if two consecutive values read from RND
 *   are equal. In rare cases, this could happen and the test should be
 *   re-executed.
 * - The randomness prefetch is an optimization to hide unknown and highly
 *   variable latency from the EDN. This, plus the fact that OTBN software
 *   cannot measure its own execution time, makes it impossible to automate
 *   a test for RND_PREFETCH. The instruction is kept nonetheless to help
 *   debugging with waveforms.
 */
test_rnd:
  /* Initial read. */
  csrrs x2, 0xfc0 /* RND */, x0

  /* Read again, should block for a while. */
  csrrs x3, 0xfc0 /* RND */, x0

  /* If two consecutive reads return the same random number that's most likely
     a bug. (But it doesn't have to be a bug! Re-run the test if it fails.) */
  addi x31, x0, 1
  beq x2, x3, exit_fail

  /* Request a RND value from the EDN by writing to RND_PREFETCH. */
  csrrw x0, 0x7d8 /* RND_PREFETCH */, x0

  /* Give the prefetch a while to complete. */
  /* An EDN request for a random number can take up to around 5 ms. Do not
     expect the following RND read to return immediately. */
  loopi 1023, 1
    nop

  /* Read RND again, should block less. */
  csrrs x2, 0xFC0 /* RND */, x0

  /* Compare to previous value again to detect RND getting stuck. */
  addi x31, x0, 2
  beq x3, x2, exit_fail


  /* Read the RND WSR. */
  bn.wsrr w0, 0x1 /* RND */

  /* Write w0 to DMEM. */
  la x11, rnd_out
  bn.sid x0, 0(x11)

  /* Read the RND WSR again. */
  bn.wsrr w1, 0x1 /* RND */

  /* Fail the test if the two numbers read from RND are equal. */
  bn.cmp w0, w1
  csrrs x2, 0x7c0 /* FG0 */, x0
  andi x2, x2, 8 /* filter out Z (zero) bit */
  addi x31, x0, 3
  bne x2, x0, exit_fail

  ret

/**
 * Tests access to "unlimited" randomness (URND).
 *
 * The test considers it a failure if two consecutive values read from RND
 * are equal. In rare cases, this could happen and the test should be
 * re-executed.
 */
test_urnd:
  /* Read the URND CSR. */
  csrrs x2, 0xfc1 /* URND */, x0

  /* Read again. */
  csrrs x3, 0xfc1 /* URND */, x0

  /* If two consecutive reads return the same random number that's most likely
     a bug. (But it doesn't have to be a bug! Re-run the test if it fails.) */
  addi x31, x0, 32
  beq x2, x3, exit_fail


  /* Read the URND WSR. */
  bn.wsrr w0, 0x2 /* URND */

  /* Write w0 to DMEM. */
  la x11, urnd_out
  bn.sid x0, 0(x11)

  /* Read the URND WSR again. */
  bn.wsrr w1, 0x2 /* URND */

  /* Fail the test if the two numbers read from URND are equal. */
  bn.cmp w0, w1
  csrrs x2, 0x7c0 /* FG0 */, x0
  andi x2, x2, 8 /* filter out Z (zero) bit */
  addi x31, x0, 33
  bne x2, x0, exit_fail

  ret

/* Terminate the program with a 0 (SUCCESS) return code. */
exit_success:
  li x10, 0
  la x11, rv
  sw x10, 0(x11)
  ecall

/* Terminate the program with a 1 (FAIL) return code. */
exit_fail:
  li x10, 1
  la x11, rv
  sw x10, 0(x11)

  la x11, fail_idx
  sw x31, 0(x11)

  ecall

.data
/* Return value. */
.globl rv
.balign 4
rv:
  .word 0xFFFFFFFF

/* Test status. */
.globl fail_idx
.balign 4
fail_idx:
  .word 0x0

/* One of the values read from RND. */
.globl rnd_out
.balign 32
rnd_out:
  .zero 32

/* One of the values read from URND. */
.globl urnd_out
.balign 32
urnd_out:
  .zero 32
