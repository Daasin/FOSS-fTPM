// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// AUTOGENERATED. Do not edit this file by hand.
// See the crypto/tests README for details.

#ifndef OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_SIGVERIFY_TESTS_SIGVERIFY_TESTVECTORS_H_
#define OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_SIGVERIFY_TESTS_SIGVERIFY_TESTVECTORS_H_

#include "sw/device/silicon_creator/lib/sigverify/sigverify_rsa_key.h"

#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus

// A test vector for RSA-3072 verify (message hashed with SHA-256)
typedef struct sigverify_test_vector_t {
  sigverify_rsa_key_t key;     // The public key
  sigverify_rsa_buffer_t sig;  // The signature to verify
  uint32_t encoded_msg[96];    // Encoded message (PKCSv1,5, SHA-256)
  bool valid;                  // Expected result (true if signature valid)
  char *comment;               // Any notes about the test vector
} sigverify_test_vector_t;

static const size_t SIGVERIFY_NUM_TESTS = ${len(tests)};

static const sigverify_test_vector_t sigverify_tests[${len(tests)}] = {
% for idx, t in enumerate(tests):
    {
        .key =
            {
                .n = {.data =
                          {
  % for i in range(0, len(t["n_hexwords"]), 4):
                              ${', '.join(t["n_hexwords"][i:i + 4])},
  % endfor
                          }},
                .n0_inv = {
  % for i in range(0, len(t["n0_inv_hexwords"]), 4):
                              ${', '.join(t["n0_inv_hexwords"][i:i + 4])},
  % endfor
                          },
            },
        .sig =
            {.data =
                 {
  % for i in range(0, len(t["sig_hexwords"]), 5):
                     ${', '.join(t["sig_hexwords"][i:i + 5])},
  % endfor
                 }},
        .encoded_msg = {
  % for i in range(0, len(t["encoded_msg_hexwords"]), 5):
                        ${', '.join(t["encoded_msg_hexwords"][i:i + 5])},
  % endfor
                      },
        .valid = ${"true" if t["valid"] else "false"},
        .comment = "${t["comment"]}",
    },
% endfor
};

#ifdef __cplusplus
}  // extern "C"
#endif  // __cplusplus

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_SIGVERIFY_TESTS_SIGVERIFY_TESTVECTORS_H_
