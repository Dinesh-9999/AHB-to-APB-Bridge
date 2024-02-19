
//apb_agt_config extends from uvm_object
 class apb_agt_config extends uvm_object;

	// UVM Factory Registration Macro
	`uvm_object_utils(apb_agt_config)

	virtual apb_if vif;
	uvm_active_passive_enum is_active;

	static int drv_data_count = 0;
        static int mon_data_count = 0;

	//Standard UVM Method
	extern function new(string name = "apb_agt_config");

endclass

//--------------- constructor -------------------//
	function apb_agt_config::new(string name = "apb_agt_config");
		super.new(name);
endfunction


