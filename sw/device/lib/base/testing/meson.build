# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

sw_lib_testing_bitfield = declare_dependency(
  link_with: static_library(
    'bitfield',
    sources: [
      meson.project_source_root() / 'sw/device/lib/base/bitfield.c',
      meson.project_source_root() / 'sw/device/lib/base/math.c',
    ],
    native: true,
  )
)

sw_lib_testing_memory = declare_dependency(
  link_with: static_library(
    'memory',
    sources: [
      meson.project_source_root() / 'sw/device/lib/base/memory.c',
    ],
    c_args: ['-fno-builtin'],
    native: true,
  ),
)

sw_lib_testing_mock_abs_mmio = declare_dependency(
  link_with: static_library(
    'mock_abs_mmio',
    sources: [
      'mock_abs_mmio.h',
    ],
    dependencies: [
      sw_vendor_gtest,
      sw_lib_testing_bitfield,
    ],
    native: true,
    c_args: ['-DMOCK_ABS_MMIO'],
    cpp_args: ['-DMOCK_ABS_MMIO'],
  )
)

sw_lib_testing_hardened = declare_dependency(
  link_with: static_library(
    'hardened',
    sources: [
      meson.project_source_root() / 'sw/device/lib/base/hardened.c',
    ],
    native: true,
  )
)

sw_lib_base_testing_mock_mmio = declare_dependency(
  link_with: static_library(
    'mock_mmio',
    sources: [
      meson.project_source_root() / 'sw/device/lib/base/mmio.c',
      'mock_mmio.cc',
    ],
    dependencies: [
      sw_vendor_gtest,
      sw_lib_testing_bitfield,
      sw_lib_testing_memory,
    ],
    native: true,
    c_args: ['-DMOCK_MMIO'],
    cpp_args: ['-DMOCK_MMIO'],
  )
)

# Example test using mock_mmio.h, which also serves to
# test that mock_mmio.h works correctly.
test('mock_mmio_test', executable(
  'mock_mmio_test',
  sources: ['mock_mmio_test.cc'],
  dependencies: [
    sw_vendor_gtest,
    sw_lib_base_testing_mock_mmio,
  ],
  native: true,
  cpp_args: ['-DMOCK_MMIO'],
))
