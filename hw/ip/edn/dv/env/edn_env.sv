// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

class edn_env extends cip_base_env #(
    .CFG_T              (edn_env_cfg),
    .COV_T              (edn_env_cov),
    .VIRTUAL_SEQUENCER_T(edn_virtual_sequencer),
    .SCOREBOARD_T       (edn_scoreboard)
  );
  `uvm_component_utils(edn_env)

  csrng_agent   m_csrng_agent;
  push_pull_agent#(.HostDataWidth(edn_pkg::FIPS_ENDPOINT_BUS_WIDTH))
       m_endpoint_agent[MAX_NUM_ENDPOINTS];

  `uvm_component_new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // create components
    m_csrng_agent = csrng_agent::type_id::create("m_csrng_agent", this);
    uvm_config_db#(csrng_agent_cfg)::set(this, "m_csrng_agent*", "cfg", cfg.m_csrng_agent_cfg);
    cfg.m_csrng_agent_cfg.if_mode = dv_utils_pkg::Device;
    cfg.m_csrng_agent_cfg.en_cov  = cfg.en_cov;

    for (int i = 0; i < MAX_NUM_ENDPOINTS; i++) begin
      string endpoint_agent_name = $sformatf("m_endpoint_agent[%0d]", i);
      m_endpoint_agent[i] = push_pull_agent#(.HostDataWidth(edn_pkg::FIPS_ENDPOINT_BUS_WIDTH))::
                            type_id::create(endpoint_agent_name, this);
      uvm_config_db#(push_pull_agent_cfg#(.HostDataWidth(edn_pkg::FIPS_ENDPOINT_BUS_WIDTH)))::
          set(this, $sformatf("%0s*", endpoint_agent_name), "cfg", cfg.m_endpoint_agent_cfg[i]);
      cfg.m_endpoint_agent_cfg[i].agent_type = push_pull_agent_pkg::PullAgent;
      cfg.m_endpoint_agent_cfg[i].if_mode    = dv_utils_pkg::Host;
      cfg.m_endpoint_agent_cfg[i].en_cov     = cfg.en_cov;
      // TODO: Move these
      cfg.m_endpoint_agent_cfg[i].zero_delays = 1'b1;
    end

    // config edn path virtual interface
    if (!uvm_config_db#(virtual edn_path_if)::get(this, "", "edn_path_vif", cfg.edn_path_vif)) begin
      `uvm_fatal(`gfn, "failed to get edn_path_vif from uvm_config_db")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    virtual_sequencer.csrng_sequencer_h = m_csrng_agent.sequencer;

    if (cfg.en_scb) begin
      m_csrng_agent.m_genbits_push_agent.monitor.analysis_port.connect
          (scoreboard.genbits_fifo.analysis_export);

      m_csrng_agent.m_cmd_push_agent.monitor.analysis_port.connect
          (scoreboard.cs_cmd_fifo.analysis_export);

      for (int i = 0; i < cfg.num_endpoints; i++) begin
        m_endpoint_agent[i].monitor.analysis_port.connect
            (scoreboard.endpoint_fifo[i].analysis_export);
      end
    end

    for (int i = 0; i < cfg.num_endpoints; i++) begin
      if (cfg.m_endpoint_agent_cfg[i].is_active) begin
        virtual_sequencer.endpoint_sequencer_h[i] = m_endpoint_agent[i].sequencer;
      end
    end
  endfunction

endclass
