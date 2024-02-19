
// Extend apb_driver from uvm driver parameterized by apb_xtn
 class apb_driver extends uvm_driver #(apb_xtn);

	//factory registration
	`uvm_component_utils(apb_driver)

	virtual apb_if.APB_DR_MP vif;

	//apb_xtn xtn;
	apb_agt_config apb_cfg;

	//Standard UVM Methods
	extern function new(string name="apb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();	

endclass

//---------Constructor-----------//
	function apb_driver::new(string name="apb_driver",uvm_component parent);
		super.new(name,parent);
endfunction

//----------Build Phase---------//
	function void apb_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
		`uvm_fatal("DRIVER","cannot get config data");
	
endfunction

//---------------Connect Phase-------------//
	function void apb_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		vif=apb_cfg.vif;
endfunction



//////---Run Phase-----/////
task apb_driver::run_phase(uvm_phase phase);


        
                begin
                        
                        send_to_dut();
                        
                end
endtask

///----send to dut------/////
task apb_driver::send_to_dut();
 apb_xtn xtn;
 xtn = apb_xtn::type_id::create("xtn", this);
	
forever
	begin
        wait(vif.apb_drv_cb.Pselx !== 0); //wait for Psel to be high
	$display("ok");
	if(vif.apb_drv_cb.Pwrite == 0) //the moment Psel is high, check for Pwrite signal
	    begin
	        xtn.Prdata={$random};
		vif.apb_drv_cb.Prdata <= xtn.Prdata;
	    end
	else
		vif.apb_drv_cb.Prdata<=0;

        repeat(2)
	@(vif.apb_drv_cb); 
        `uvm_info("apb_driver", "Displaying apb_driver data", UVM_LOW)
	xtn.print();
        apb_cfg.drv_data_count++;
	end
endtask