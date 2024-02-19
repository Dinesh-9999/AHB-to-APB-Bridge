
//Base sequence is extend from uvm_sequenc with parameterized class
//----------------------Base sequence------------------------//
class base_sequence_ahb extends uvm_sequence #(ahb_xtn);

	//Factory Registration
        `uvm_object_utils(base_sequence_ahb)
             
		//ahb_signals(local varaibales/signal)
	        logic [31:0] haddr;
                logic [2:0] hsize;
                logic [2:0] hburst;
		logic hwrite;
		logic [9:0]hlength;	

	//Standard UVM methods
        extern function new(string name = "base_sequence_ahb");

endclass

//--------------- Constructor method----------------------//
	function base_sequence_ahb::new(string name = "base_sequence_ahb");
        	super.new(name);
endfunction


//single transfer sequence

class ahb_single_wr_xtns extends base_sequence_ahb;

	`uvm_object_utils(ahb_single_wr_xtns)

extern function new(string name= "ahb_single_wr_xtns");
extern task body();
endclass

function ahb_single_wr_xtns::new(string name= "ahb_single_wr_xtns");
	super.new(name);
endfunction

task ahb_single_wr_xtns::body();

	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst==3'b000;
				   Hwrite==1;});
	finish_item(req);
endtask

//unspecified length sequence 

class ahb_unspecified_wr_xtns extends base_sequence_ahb;

	`uvm_object_utils(ahb_unspecified_wr_xtns)

extern function new(string name= "ahb_unspecified_wr_xtns");
extern task body();
endclass

function ahb_unspecified_wr_xtns::new(string name= "ahb_unspecified_wr_xtns");
	super.new(name);
endfunction

task ahb_unspecified_wr_xtns::body();

	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst==3'b001;
				   Hwrite==1;});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;
	hlength = req.length;	
if(hburst==3'b001)
begin
for(int i=0;i<hlength;i++)
	begin	
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	else if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	else if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end
	
	finish_item(req);
	haddr=req.Haddr;
	end
end
endtask

//increment Burst operation with 1 byte,2 bytes and 4 bytes transfer sequence

class ahb_inc_wr_xtns extends base_sequence_ahb;

	`uvm_object_utils(ahb_inc_wr_xtns)

extern function new(string name= "ahb_inc_wr_xtns");
extern task body();
endclass
function ahb_inc_wr_xtns::new(string name= "ahb_inc_wr_xtns");
	super.new(name);
endfunction

task ahb_inc_wr_xtns::body();

	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   //Hsize==3'b000;//test
				   Hwrite==1'b1;//test
				   Hburst inside {3,5,7};});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

if(hburst==3'b011)//increment-4
begin
for(int i=0;i<3;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b101)//increment-8
begin
for(int i=0;i<7;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b111)//increment-16
begin
for(int i=0;i<15;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+1'b1;
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+2'b10;
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr==haddr+3'b100;
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end

	//start_item(req);
	//assert(req.randomize with {Htrans==2'b00;});
	//finish_item(req);

endtask



//wrapping burst operation 1byte,2byte & 4 bytes 
class ahb_wrap_wr_xtns extends base_sequence_ahb;

	`uvm_object_utils(ahb_wrap_wr_xtns)

extern function new(string name= "ahb_wrap_wr_xtns");
extern task body();
endclass
function ahb_wrap_wr_xtns::new(string name= "ahb_wrap_wr_xtns");
	super.new(name);
endfunction

task ahb_wrap_wr_xtns::body();

	req=ahb_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {Htrans==2'b10;
				   Hburst inside {2,4,6};
				   Hwrite==1;
					});
	finish_item(req);

	haddr = req.Haddr;
        hsize = req.Hsize;
        hburst = req.Hburst;
        hwrite = req.Hwrite;

if(hburst==3'b010)//wrap-4
begin
for(int i=0;i<3;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b100)//wrap-8
begin
for(int i=0;i<7;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end


if(hburst==3'b110)//wrap-16
begin
for(int i=0;i<15;i++)
	begin
	start_item(req);
	if(hsize==3'b000)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:2],haddr[1:0]+1'b1};
				   Hsize==hsize;});
	end

	if(hsize==3'b001)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:3],haddr[2:1]+1'b1,haddr[0]};
				   Hsize==hsize;});
	end

	if(hsize==3'b010)
	begin
	assert(req.randomize with {Htrans==2'b11;
				   Hburst==hburst;
				   Hwrite==hwrite;
				   Haddr=={haddr[31:4],haddr[3:2]+1'b1,haddr[1:0]};
				   Hsize==hsize;});
	end

	finish_item(req);
	haddr=req.Haddr;
	end
end

endtask


