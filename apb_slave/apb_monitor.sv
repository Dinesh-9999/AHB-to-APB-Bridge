
// Extend ram_wr_monitor from uvm_monitor
 class apb_monitor extends uvm_monitor;

        //Factory registration
        `uvm_component_utils (apb_monitor)

        virtual apb_if.APB_MON_MP vif;

        apb_agt_config apb_cfg;

        //Analysis port to send the data to SB
 	 uvm_analysis_port #(apb_xtn) monitor_port;

        // apb_xtn xtn;

	//Standard UVM Methods
        extern function new(string name="APB_MONITOR",uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
        extern task collect_data;    

endclass

//------------------Constructor----------------------//
	function apb_monitor::new(string name="APB_MONITOR",uvm_component parent);
        	super.new(name,parent);
       		 monitor_port=new("monitor_port",this);
endfunction

//-----------------------Build Phase-----------------------//
	function void apb_monitor::build_phase(uvm_phase phase);
        	if(!uvm_config_db #(apb_agt_config)::get(this,"","apb_agt_config",apb_cfg))
                `uvm_fatal("MONITOR","cannot get config data");
        	super.build_phase(phase);
endfunction


//-------------- connect_phase ----------------------//
	function void apb_monitor::connect_phase(uvm_phase phase);
        	super.connect_phase(phase);
		vif=apb_cfg.vif;
endfunction


task apb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
endtask


task apb_monitor::collect_data();
        apb_xtn xtn;
        xtn = apb_xtn::type_id::create("xtn");

        wait(vif.apb_mon_cb.Penable)
                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite; 

                xtn.Pselx = vif.apb_mon_cb.Pselx;

        if(xtn.Pwrite == 1)
		xtn.Pwdata = vif.apb_mon_cb.Pwdata; 
        else
                xtn.Prdata = vif.apb_mon_cb.Prdata;

        @(vif.apb_mon_cb);
	
	xtn.print();

        monitor_port.write(xtn);

        `uvm_info("apb_monitor", "Displaying apb_monitor data", UVM_LOW)
        apb_cfg.mon_data_count++;
endtask
