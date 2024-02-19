 
//AHB_Driver extends from uvm_driver
 class ahb_driver extends uvm_driver #(ahb_xtn);
	
	//factory registration
	`uvm_component_utils (ahb_driver)
	
	//interface
	virtual ahb_if.AHB_DR_MP vif;
	
	//ahb_xtn xtn;
	ahb_agt_config ahb_cfg;

	//Standard UVM Methods	
	extern function new (string name = "ahb_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase (uvm_phase phase);
	extern task send_to_dut(ahb_xtn xtn);
	extern function void report_phase (uvm_phase phase);

endclass

//-----------Constructor----------//
	function ahb_driver::new (string name = "ahb_driver", uvm_component parent);
		super.new (name, parent);
endfunction

//-----------Build Phase---------//
	function void ahb_driver::build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_agt_config)::get(this, "", "ahb_agt_config", ahb_cfg))
		`uvm_fatal("CONFIG","Cannot get() m_cfg from uvm_config_db. Have you set it?")
endfunction

//----------Connect Phase---------//
	function void ahb_driver::connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		//interface connection
		vif=ahb_cfg.vif;

endfunction 	
//--------------------------Run Phase--------------------------//
task ahb_driver::run_phase(uvm_phase phase);


        //Active low reset
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0;

        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;

        forever
                begin
                        seq_item_port.get_next_item(req); //get the data from sequencer
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask


//------------------send to dut---------------------//
task ahb_driver::send_to_dut(ahb_xtn xtn);

        vif.ahb_drv_cb.Hwrite  <= xtn.Hwrite;
        vif.ahb_drv_cb.Htrans <= xtn.Htrans;
        vif.ahb_drv_cb.Hsize   <= xtn.Hsize;
        vif.ahb_drv_cb.Haddr   <= xtn.Haddr;
        vif.ahb_drv_cb.Hreadyin<= 1'b1;
	vif.ahb_drv_cb.Hburst  <= xtn.Hburst;
		
      	 	@(vif.ahb_drv_cb);

	wait(vif.ahb_drv_cb.Hreadyout)
	
		if(xtn.Hwrite)
                vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;
		else
		vif.ahb_drv_cb.Hwdata<=32'bz;
	//xtn.print();
	
	//`uvm_info("AHB_MASTER_DRIVER", $sformatf("printing the data from master_driver \n %s", xtn.sprint()), UVM_LOW)
	//write_xtns_count++;
      // @(vif.ahb_drv_cb);
endtask

//----------------------- report phase ---------------------//
	function void ahb_driver::report_phase (uvm_phase phase);
			`uvm_info(get_type_name(), $sformatf("Report: AHB_DRIVER sent %0d transaction", ahb_cfg.drv_data_count), UVM_LOW)
endfunction


