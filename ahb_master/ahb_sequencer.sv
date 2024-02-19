
//ahb_sequencer extends from uvm_sequencer
class ahb_sequencer extends uvm_sequencer #(ahb_xtn);

	//Factory Registration
        `uvm_component_utils(ahb_sequencer)

	//Standard UVM Methods
        extern function new(string name = "ahb_sequencer", uvm_component parent);

endclass


//------------Constructor---------//
	function ahb_sequencer::new(string name = "ahb_sequencer", uvm_component parent);
        	super.new(name,parent);
endfunction


