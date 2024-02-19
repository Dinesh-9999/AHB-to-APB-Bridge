
//Extends apb_agt_top from uvm_env
 class apb_agt_top extends uvm_env;
	
	//factory reg
	`uvm_component_utils(apb_agt_top)

	env_config m_cfg;
	apb_agent agt[];

	//Standard UVM methods
        extern function new(string name = "apb_agt_top" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass


//------------------- Constructor------------------//
	function apb_agt_top::new(string name="apb_agt_top",uvm_component parent);
		super.new(name,parent);
endfunction


//----------------- build_phase ------------------//
	function void apb_agt_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() cfg from uvm_config_db. Have you set() it?")

		agt =new[m_cfg.no_of_apb_agents];
		foreach(agt[i])
		begin
			agt[i]=apb_agent::type_id::create($sformatf("agt[%0d]", i),this);
			uvm_config_db #(apb_agt_config)::set(this,$sformatf("agt[%0d]*", i), "apb_agt_config", m_cfg.apb_cfg[i]);
		end
endfunction


