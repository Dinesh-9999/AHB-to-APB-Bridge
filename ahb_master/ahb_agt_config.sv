
//ahb_agent_config extend from uvm_object
class ahb_agt_config extends uvm_object;

	//factory registration
	`uvm_object_utils (ahb_agt_config)

	virtual ahb_if vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	static int drv_data_count = 0;
        static int mon_data_count = 0;

	//Standard UVM Methods
	extern function new (string name = "ahb_agt_config");
endclass

//---------------- Constructor--------------------//
	function ahb_agt_config::new(string name = "ahb_agt_config");
		super.new(name);
endfunction



