
class vbase_sequence_ahb extends uvm_sequence #(uvm_sequence_item);

//facatory registration
`uvm_object_utils(vbase_sequence_ahb)

env_config env_cfg;

ahb_single_wr_xtns single_wr_xtns;

//ahb_seq_rd_xtns seq_rd_xtns;

ahb_unspecified_wr_xtns unspecified_wr_xtns;

ahb_inc_wr_xtns inc_wr_xtns;

ahb_wrap_wr_xtns wrap_wr_xtns;

virtual_sequencer v_seqrh;

ahb_sequencer m_seqrh[];

apb_sequencer s_seqrh[];


extern function new(string name="vbase_sequence_ahb");
extern task body();
endclass: vbase_sequence_ahb

function vbase_sequence_ahb::new(string name ="vbase_sequence_ahb");
	super.new(name);
endfunction

task vbase_sequence_ahb::body();

//get the env_config from database using uvm_config_db
	if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
	`uvm_fatal("VSEQ","cannot get env_config  from uvm_config_db.have you set it?")

	m_seqrh=new[env_cfg.no_of_ahb_agents];
	s_seqrh=new[env_cfg.no_of_apb_agents];

assert($cast(v_seqrh,m_sequencer)) 
else 
	begin
	`uvm_error("BODY","Error in $cast of virtual sequencer")
	end

foreach(m_seqrh[i])
	m_seqrh[i]=v_seqrh.m_seqrh[i];
foreach(s_seqrh[i])
	s_seqrh[i]=v_seqrh.s_seqrh[i];
endtask:body


//single transfer virtual sequence 

class ahb_single_vseq extends vbase_sequence_ahb;
	
	`uvm_object_utils(ahb_single_vseq)

extern function new(string name= "ahb_single_vseq");
extern task body();
endclass:ahb_single_vseq

function ahb_single_vseq::new(string name= "ahb_single_vseq");
	super.new(name);
endfunction

task ahb_single_vseq::body();
	super.body();
single_wr_xtns=ahb_single_wr_xtns::type_id::create("single_wr_xtns");
	fork
		begin
		single_wr_xtns.start(m_seqrh[0]);
		end
		
	join

endtask

//unspecified virtual sequence 
class ahb_unspecified_vseq extends vbase_sequence_ahb;
	
	`uvm_object_utils(ahb_unspecified_vseq)

extern function new(string name= "ahb_unspecified_vseq");
extern task body();	
endclass:ahb_unspecified_vseq

function ahb_unspecified_vseq::new(string name= "ahb_unspecified_vseq");
	super.new(name);
endfunction

task ahb_unspecified_vseq::body();
	super.body();
unspecified_wr_xtns=ahb_unspecified_wr_xtns::type_id::create("unspecified_wr_xtns");
	fork
		begin
		unspecified_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask


//inc sequence 
class ahb_inc_vseq extends vbase_sequence_ahb;
	
	`uvm_object_utils(ahb_inc_vseq)

extern function new(string name= "ahb_inc_vseq");
extern task body();	
endclass:ahb_inc_vseq

function ahb_inc_vseq::new(string name= "ahb_inc_vseq");
	super.new(name);
endfunction

task ahb_inc_vseq::body();
	super.body();
inc_wr_xtns=ahb_inc_wr_xtns::type_id::create("inc_wr_xtns");

	fork
		begin
		inc_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask


//wrap sequence 
class ahb_wrap_vseq extends vbase_sequence_ahb;
	
	`uvm_object_utils(ahb_wrap_vseq)

extern function new(string name= "ahb_wrap_vseq");
extern task body();	
endclass:ahb_wrap_vseq

function ahb_wrap_vseq::new(string name= "ahb_wrap_vseq");
	super.new(name);
endfunction

task ahb_wrap_vseq::body();
	super.body();
wrap_wr_xtns=ahb_wrap_wr_xtns::type_id::create("wrap_wr_xtns");
	fork
		begin
		wrap_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask

