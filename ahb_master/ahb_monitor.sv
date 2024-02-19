
 //AHB_Monitor extends from uvm_monitor
 class ahb_monitor extends uvm_monitor;
	
	//factory registration
	`uvm_component_utils (ahb_monitor)
	
	//interface
	virtual ahb_if.AHB_MON_MP vif;
	
	ahb_xtn xtn;
	ahb_agt_config ahb_cfg;
	
	//Analysis port to send the data to SB
	uvm_analysis_port #(ahb_xtn) monitor_port;

	//Standard UVM Methods	
	extern function new (string name = "ahb_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass


//-----------Constructor----------//
	function ahb_monitor::new (string name = "ahb_monitor", uvm_component parent);
		super.new (name, parent);
		monitor_port = new("monitor_port", this);
endfunction


//-----------Build Phase---------//
	function void ahb_monitor::build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(ahb_agt_config)::get(this, "", "ahb_agt_config", ahb_cfg))
		`uvm_fatal("CONFIG","Cannot get() m_cfg from uvm_config_db. Have you set it?")
endfunction


//----------Connect Phase---------//
	function void ahb_monitor::connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		//interface connection
		vif=ahb_cfg.vif;
endfunction

//-----------------------Run Phase---------------------//

task ahb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
endtask


//--------------------collect data-----------------------------//
task ahb_monitor::collect_data();
	ahb_xtn xtn;
        xtn = ahb_xtn::type_id::create("xtn");

         wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
         xtn.Htrans = vif.ahb_mon_cb.Htrans;
         xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
         xtn.Hsize  = vif.ahb_mon_cb.Hsize;
         xtn.Haddr  = vif.ahb_mon_cb.Haddr;
         xtn.Hburst = vif.ahb_mon_cb.Hburst;



	@(vif.ahb_mon_cb);

        wait(vif.ahb_mon_cb.Hreadyout)

		if(vif.ahb_mon_cb.Hwrite)
		     xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
		else
        	    xtn.Hrdata = vif.ahb_mon_cb.Hrdata;
		//xtn.print();
		monitor_port.write(xtn);

	 //monitor_port.write(xtn);
   //`uvm_info("AHB_MASTER_MONITOR", $sformatf("printing the data from master_monitor \n %s", xtn.sprint()), UVM_LOW)

endtask

//------------------- report phase ---------------------//
	function void ahb_monitor::report_phase(uvm_phase phase);
    		`uvm_info(get_type_name(), $sformatf("Report: AHB_Write Monitor Collected %0d Transactions", ahb_cfg.mon_data_count), UVM_LOW)
endfunction
 



