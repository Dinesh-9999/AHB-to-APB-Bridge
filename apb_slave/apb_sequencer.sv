
// Extend apb_sequencer from uvm_sequencer parameterized by apb_xtn
 class apb_sequencer extends uvm_sequencer #(apb_xtn);

	// Factory registration 
        `uvm_component_utils(apb_sequencer)

	//Standard UVM Methods
        extern function new(string name = "apb_sequencer", uvm_component parent);

endclass

//-------------------------Constructor-----------------------------//
	function apb_sequencer::new(string name = "apb_sequencer", uvm_component parent);
        	super.new(name,parent);
endfunction



