# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Smoke Tests
###############################################################################
pwrmgr_usbdev_smoketest_lib = declare_dependency(
  link_with: static_library(
    'pwrmgr_usbdev_smoketest_lib',
    sources: ['pwrmgr_usbdev_smoketest.c'],
    dependencies: [
      sw_lib_dif_pwrmgr,
      sw_lib_usb,
      sw_lib_mmio,
      sw_lib_runtime_log,
      sw_lib_testing_pwrmgr_testutils,
    ],
  ),
)
sw_tests += {
  'pwrmgr_usbdev_smoketest': {
    'library': pwrmgr_usbdev_smoketest_lib,
  }
}

###############################################################################
# IP Integration Tests
###############################################################################
uart_tx_rx_test_lib = declare_dependency(
  link_with: static_library(
    'uart_tx_rx_test_lib',
    sources: [
      hw_ip_lc_ctrl_reg_h,
      hw_ip_clkmgr_reg_h,
      # TODO, remove it once pinout configuration is provided
      hw_top_earlgrey_pinmux_reg_h,
      'uart_tx_rx_test.c'],
    dependencies: [
      sw_lib_dif_uart,
      sw_lib_dif_rv_plic,
      sw_lib_dif_lc_ctrl,
      sw_lib_dif_clkmgr,
      sw_lib_irq,
      sw_lib_mmio,
      sw_lib_runtime_log,
      sw_lib_runtime_hart,
      sw_lib_testing_test_status,
      top_earlgrey,
    ],
  ),
)
sw_tests += {
  'uart_tx_rx_test': {
    'library': uart_tx_rx_test_lib,
    'dv_frames': true,
  }
}

gpio_test_lib = declare_dependency(
  link_with: static_library(
    'gpio_test_lib',
    sources: ['gpio_test.c'],
    dependencies: [
      sw_lib_dif_gpio,
      sw_lib_dif_rv_plic,
      sw_lib_irq,
      sw_lib_mmio,
      sw_lib_pinmux,
      sw_lib_runtime_log,
      sw_lib_runtime_hart,
      sw_lib_testing_test_status,
      top_earlgrey,
    ],
  ),
)
sw_tests += {
  'gpio_test': {
    'library': gpio_test_lib,
  }
}

# Keymgr Tests
keymgr_key_derivation_test_lib = declare_dependency(
  link_with: static_library(
    'keymgr_key_derivation_test_lib',
    sources: [
      hw_ip_keymgr_reg_h,
      hw_ip_kmac_reg_h,
      'keymgr_key_derivation.c'],
    dependencies: [
      sw_lib_dif_keymgr,
      sw_lib_dif_kmac,
      sw_lib_dif_rstmgr,
      sw_lib_dif_otp_ctrl,
      sw_lib_dif_flash_ctrl,
      sw_lib_testing_flash_ctrl_testutils,
      sw_lib_testing_keymgr_testutils,
      sw_lib_testing_otp_ctrl_testutils,
      sw_lib_testing_test_status,
      top_earlgrey,
    ],
  ),
)
sw_tests += {
  'keymgr_key_derivation_test': {
    'library': keymgr_key_derivation_test_lib,
  }
}

lc_ctrl_transition_test_lib = declare_dependency(
  link_with: static_library(
    'lc_ctrl_transition_test_lib',
    sources: [
      'lc_ctrl_transition_test.c',
    ],
    dependencies: [
      sw_lib_dif_lc_ctrl,
      sw_lib_runtime_log,
      sw_lib_mmio,
      sw_lib_runtime_hart,
    ],
  ),
)
sw_tests += {
  'lc_ctrl_transition_test': {
    'library': lc_ctrl_transition_test_lib,
  }
}

pwrmgr_main_power_glitch_test_lib = declare_dependency(
  link_with: static_library(
    'pwrmgr_main_power_glitch_test_lib',
    sources: ['pwrmgr_main_power_glitch_test.c'],
    dependencies: [
      sw_lib_dif_pwrmgr,
      sw_lib_dif_rstmgr,
      sw_lib_mmio,
      sw_lib_runtime_log,
      sw_lib_testing_pwrmgr_testutils,
      sw_lib_testing_rstmgr_testutils,
    ],
  ),
)
sw_tests += {
  'pwrmgr_main_power_glitch_test': {
    'library': pwrmgr_main_power_glitch_test_lib,
  }
}

spi_tx_rx_test_lib = declare_dependency(
  link_with: static_library(
    'spi_tx_rx_test_lib',
    sources: ['spi_tx_rx_test.c'],
    dependencies: [
      sw_lib_dif_spi_device,
      sw_lib_dif_rv_plic,
      sw_lib_irq,
      sw_lib_mmio,
      sw_lib_runtime_log,
      sw_lib_runtime_hart,
      sw_lib_testing_test_status,
      top_earlgrey,
    ],
  ),
)
sw_tests += {
  'spi_tx_rx_test': {
    'library': spi_tx_rx_test_lib,
  }
}

flash_ctrl_lc_rw_en_test_lib = declare_dependency(
  link_with: static_library(
    'flash_ctrl_lc_rw_en_test_lib',
    sources: ['flash_ctrl_lc_rw_en_test.c'],
    dependencies: [
      sw_lib_mmio,
      sw_lib_dif_flash_ctrl,
      sw_lib_dif_lc_ctrl,
      sw_lib_dif_otp_ctrl,
      sw_lib_dif_kmac,
      sw_lib_dif_keymgr,
      sw_lib_testing_flash_ctrl_testutils,
      sw_lib_runtime_log,
    ],
  ),
)
sw_tests += {
  'flash_ctrl_lc_rw_en_test': {
    'library': flash_ctrl_lc_rw_en_test_lib,
  }
}

rom_ctrl_integrity_check_test_lib = declare_dependency(
  link_with: static_library(
    'rom_ctrl_integrity_check_test_lib',
    sources: [
      hw_ip_rom_ctrl_reg_h,
      'rom_ctrl_integrity_check_test.c',
    ],
    dependencies: [
      sw_lib_dif_lc_ctrl,
      sw_lib_dif_rom_ctrl,
      sw_lib_runtime_log,
      sw_lib_mmio,
    ],
  ),
)
sw_tests += {
  'rom_ctrl_integrity_check_test': {
    'library': rom_ctrl_integrity_check_test_lib,
  }
}

# SRAM Controller execution from Main SRAM test.
sram_ctrl_execution_test_main_lib = declare_dependency(
  link_with: static_library(
    'sram_ctrl_execution_test_main_lib',
    sources: [
      hw_ip_otp_ctrl_reg_h,
      'sram_ctrl_execution_test_main.c',
    ],
    dependencies: [
      sw_lib_bitfield,
      sw_lib_dif_sram_ctrl,
      sw_lib_runtime_ibex,
      sw_lib_runtime_log,
      sw_lib_testing_lc_ctrl_testutils,
      sw_lib_testing_otp_ctrl_testutils,
      sw_lib_testing_sram_ctrl_testutils,
      top_earlgrey,
    ],
  ),
)
sw_tests += {
  'sram_ctrl_execution_test_main': {
    'library': sram_ctrl_execution_test_main_lib,
  }
}
