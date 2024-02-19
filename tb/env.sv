
//Extends env class from  uvm_env
class env extends uvm_env;

	//Factory Registration
        `uvm_component_utils(env)

        ahb_agt_top ahb_top;
        apb_agt_top apb_top;
	virtual_sequencer v_sequencer;
	scoreboard sb;
 
        env_config e_cfg;

	//Standard UVM Methods
        extern function new(string name = "env", uvm_component parent);
        extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);       

endclass

//-----------Constructor-----------//
	function env::new(string name = "env", uvm_component parent);
        	super.new(name, parent);
endfunction

//-----------Build Phase-----------//
	function void  env::build_phase(uvm_phase phase);
        	super.build_phase(phase);

        	if(!uvm_config_db #(env_config)::get(this, "", "env_config", e_cfg))
                `uvm_fatal("env", "cannot get the env_config")

        	if(e_cfg.has_ahb_agent)
        	begin
                	ahb_top = ahb_agt_top::type_id::create("ahb_top", this);
 	  //             uvm_config_db #(ahb_agt_config)::set(this, "*agt*", "ahb_agt_config", e_cfg.ahb_cfg);
        	end
		if(e_cfg.has_apb_agent)
       		 begin
                	apb_top = apb_agt_top::type_id::create("apb_top", this);
   	 //             uvm_config_db #(apb_agt_config)::set(this, "agt*", "apb_agt_config", e_cfg.apb_cfg);
        	end
		if(e_cfg.has_virtual_sequencer)
		v_sequencer=virtual_sequencer::type_id::create("v_sequnecer",this);
		if(e_cfg.has_virtual_scoreboard)
		sb=scoreboard::type_id::create("scoreboard",this);


endfunction
function void env::connect_phase(uvm_phase phase);
	if(e_cfg.has_virtual_sequencer)begin
	if(e_cfg.has_ahb_agent)
		foreach(ahb_top.agt[i])
		v_sequencer.m_seqrh[i]=ahb_top.agt[i].ahb_seqr;
		
	if(e_cfg.has_apb_agent)
		foreach(apb_top.agt[i])
		v_sequencer.s_seqrh[i]=apb_top.agt[i].apb_seqr;

	if(e_cfg.has_scoreboard)
		begin
		if(e_cfg.has_ahb_agent)
		begin
		foreach(e_cfg.ahb_cfg[i])
			begin
			ahb_top.agt[i].ahb_mon.monitor_port.connect(sb.fifo_ahb[i].analysis_export);
			end
		end
		if(e_cfg.has_apb_agent)
		begin
		foreach(e_cfg.apb_cfg[i])
		apb_top.agt[i].apb_mon.monitor_port.connect(sb.fifo_apb[i].analysis_export);
		end
		end
	
	end
	endfunction



