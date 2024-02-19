class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

//factory registration
`uvm_component_utils(virtual_sequencer)

ahb_sequencer m_seqrh[];
apb_sequencer s_seqrh[];

env_config env_cfg;

extern function new(string name = "virtual_sequencer",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function virtual_sequencer::new(string name="virtual_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction

function void virtual_sequencer::build_phase(uvm_phase phase);

//get the config object ahb2apb_env_config using uvm_config_db
if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
	`uvm_fatal("CONFIG","cannot get env_cfg from uvm_config_db.have you set it ?")
	
	super.build_phase(phase);

	m_seqrh=new[env_cfg.no_of_ahb_agents];
	
	s_seqrh=new[env_cfg.no_of_apb_agents];

endfunction

