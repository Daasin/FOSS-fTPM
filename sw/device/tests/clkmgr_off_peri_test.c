// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "sw/device/lib/base/memory.h"
#include "sw/device/lib/dif/dif_aon_timer.h"
#include "sw/device/lib/dif/dif_base.h"
#include "sw/device/lib/dif/dif_clkmgr.h"
#include "sw/device/lib/dif/dif_pwrmgr.h"
#include "sw/device/lib/dif/dif_rstmgr.h"
#include "sw/device/lib/dif/dif_uart.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/aon_timer_testutils.h"
#include "sw/device/lib/testing/check.h"
#include "sw/device/lib/testing/rstmgr_testutils.h"
#include "sw/device/lib/testing/test_framework/ottf.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

/**
 * The peripherals used to test when the peri clocks are disabled are
 * bit 0: clk_io_div4_peri: uart0
 * bit 1: clk_io_div2_peri: spi_host1
 * bit 2: clk_usb_peri: usbdev
 * bit 3: clk_io_peri: spi_host0
 */

const test_config_t kTestConfig;

static dif_aon_timer_t aon_timer;
static dif_uart_t uart0;

static const uint32_t bite_us = 200;

/**
 * Send CSR access to uart0, expecting to timeout.
 */
static void uart0_csr_access(void) {
  CHECK_DIF_OK(dif_uart_watermark_rx_set(&uart0, kDifUartWatermarkByte1));
}

/**
 * Test that disabling a 'gateable' unit's clock causes the unit to become
 * unresponsive to CSR accesses. Configure a watchdog reset, and if it triggers
 * the test is successful.
 */
static void test_gateable_clocks_off(const dif_clkmgr_t *clkmgr,
                                     dif_clkmgr_gateable_clock_t clock) {
  // Make sure the clock for the unit is on.
  CHECK_DIF_OK(
      dif_clkmgr_gateable_clock_set_enabled(clkmgr, clock, kDifToggleEnabled));

  // The unit is enabled. Set the aon timer to bite, disable it, and issue a
  // CSR read.
  uint32_t bite_cycles = aon_timer_testutils_get_aon_cycles_from_us(bite_us);
  LOG_INFO("Setting bite reset for %u us (%u cycles)", bite_us, bite_cycles);

  aon_timer_testutils_watchdog_config(&aon_timer, UINT32_MAX, bite_cycles,
                                      false);
  CHECK_DIF_OK(
      dif_clkmgr_gateable_clock_set_enabled(clkmgr, clock, kDifToggleDisabled));
  uart0_csr_access();
}

bool test_main() {
  dif_clkmgr_t clkmgr;
  dif_pwrmgr_t pwrmgr;
  dif_rstmgr_t rstmgr;

  CHECK_DIF_OK(dif_rstmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_RSTMGR_AON_BASE_ADDR), &rstmgr));

  CHECK_DIF_OK(dif_clkmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_CLKMGR_AON_BASE_ADDR), &clkmgr));

  CHECK_DIF_OK(dif_pwrmgr_init(
      mmio_region_from_addr(TOP_EARLGREY_PWRMGR_AON_BASE_ADDR), &pwrmgr));

  // Initialize aon timer.
  CHECK_DIF_OK(dif_aon_timer_init(
      mmio_region_from_addr(TOP_EARLGREY_AON_TIMER_AON_BASE_ADDR), &aon_timer));

  // Initialize uart0.
  CHECK_DIF_OK(dif_uart_init(
      mmio_region_from_addr(TOP_EARLGREY_UART0_BASE_ADDR), &uart0));

  if (rstmgr_testutils_is_reset_info(&rstmgr, kDifRstmgrResetInfoPor)) {
    // Enable watchdog bite reset.
    CHECK_DIF_OK(dif_pwrmgr_set_request_sources(&pwrmgr, kDifPwrmgrReqTypeReset,
                                                kDifPwrmgrResetRequestSourceTwo,
                                                true));
    rstmgr_testutils_pre_reset(&rstmgr);
    test_gateable_clocks_off(&clkmgr, 0);

    // This should never be reached.
    LOG_ERROR("This is unreachable since a reset should have been triggered");
    return false;
  } else if (rstmgr_testutils_is_reset_info(&rstmgr,
                                            kDifRstmgrResetInfoWatchdog)) {
    return true;
  } else {
    dif_rstmgr_reset_info_bitfield_t reset_info;
    CHECK_DIF_OK(dif_rstmgr_reset_info_get(&rstmgr, &reset_info));
    LOG_ERROR("Unexpected reset_info 0x%x", reset_info);
  }
  return false;
}
