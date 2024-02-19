//class base_test extends from uvm_test
class base_test extends uvm_test;

	//Factory Registration
	`uvm_component_utils(base_test)

	//Declared the handles
	env_config m_cfg;
	env e_cfg;
	//ahb_seqs seq;

	ahb_agt_config ahb_cfg[];
	apb_agt_config apb_cfg[];

	//Parameters
	int no_of_ahb_agents=1;
	int no_of_apb_agents=1;
	//bit has_scoreboard=1;
	bit has_virtual_sequencer=1;

	//Standard UVM Methods
	extern function new(string name="base_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);


endclass : base_test

//----------Constructor-----------//
	function base_test::new(string name="base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------Build Phase----------//
	function void base_test::build_phase(uvm_phase phase);
		super.build_phase(phase);	

		m_cfg = env_config::type_id::create("env_config", this);
        	e_cfg = env::type_id::create("env", this);
	//these shud be written before declaring dynamic array

		if(m_cfg.has_ahb_agent)
		begin
			m_cfg.ahb_cfg=new[no_of_ahb_agents];
		end
	
		if(m_cfg.has_apb_agent)
		begin
			m_cfg.apb_cfg=new[no_of_apb_agents];
		end
	
	//m_cfg = env_config::type_id::create("env_config", this);
	//e_cfg = env::type_id::create("env", this);

		ahb_cfg=new[no_of_ahb_agents];
		apb_cfg=new[no_of_apb_agents];
	
		foreach(apb_cfg[i])
		begin
			apb_cfg[i]=apb_agt_config::type_id::create($sformatf("apb_cfg[%0d]",i));
			if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_vif",apb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");

			apb_cfg[i].is_active=UVM_ACTIVE;
			m_cfg.apb_cfg[i]=apb_cfg[i];

		end
	
		foreach(ahb_cfg[i])
		begin
			ahb_cfg[i]=ahb_agt_config::type_id::create($sformatf("ahb_cfg[%0d]",i));
			if(!uvm_config_db #(virtual ahb_if)::get(this,"","ahb_vif",ahb_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");

			ahb_cfg[i].is_active=UVM_ACTIVE;
			m_cfg.ahb_cfg[i]=ahb_cfg[i];
	
		end
		
		m_cfg.no_of_ahb_agents=no_of_ahb_agents;
		m_cfg.no_of_apb_agents=no_of_apb_agents;
	//	m_cfg.has_scoreboard=has_scoreboard;
		m_cfg.has_virtual_sequencer=has_virtual_sequencer;
	
		uvm_config_db#(env_config)::set(this,"*","env_config",m_cfg);
endfunction

//-------------end_of_elaboration_phase------------------//
	function void base_test::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology;
endfunction
//single transfer write base_test

class single_write_test extends base_test;

//factory registration
`uvm_component_utils(single_write_test)

ahb_single_vseq single_vseq;

//standard UVM methods
extern function new(string name= "single_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function single_write_test::new(string name="single_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void single_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task single_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	single_vseq=ahb_single_vseq::type_id::create("single_vseq");

	single_vseq.start(e_cfg.v_sequencer);

	#30;
	phase.drop_objection(this);
endtask



//unspecified length transfer write base_test

class unspecified_write_test extends base_test;

//factory registration
`uvm_component_utils(unspecified_write_test)

ahb_unspecified_vseq unspecified_vseq;

//standard UVM methods
extern function new(string name= "unspecified_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function unspecified_write_test::new(string name="unspecified_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void unspecified_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task unspecified_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	unspecified_vseq=ahb_unspecified_vseq::type_id::create("unspecified_vseq");

	unspecified_vseq.start(e_cfg.v_sequencer);

	phase.drop_objection(this);
endtask



//increment transfer write base_test

class inc_write_test extends base_test;

//factory registration
`uvm_component_utils(inc_write_test)

ahb_inc_vseq inc_vseq;

//standard UVM methods
extern function new(string name= "inc_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function inc_write_test::new(string name="inc_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void inc_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task inc_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	inc_vseq=ahb_inc_vseq::type_id::create("inc_vseq");

	inc_vseq.start(e_cfg.v_sequencer);

	phase.drop_objection(this);
endtask


//wrap transfer write base_test

class wrap_write_test extends base_test;

//factory registration
`uvm_component_utils(wrap_write_test)

ahb_wrap_vseq wrap_vseq;

//standard UVM methods
extern function new(string name= "wrap_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function wrap_write_test::new(string name="wrap_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void wrap_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task wrap_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	wrap_vseq=ahb_wrap_vseq::type_id::create("wrap_vseq");

	wrap_vseq.start(e_cfg.v_sequencer);

	phase.drop_objection(this);
endtask
