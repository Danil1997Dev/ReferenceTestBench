`timescale 1ns/1ps
`include "baseclass.svh"

class dataclass #(parameter type T = int) extends BaseVerificationClass;
  T data;

  function new(bit reset = 1,bit reset_l = 0,bit enable = 0);
      super.new(reset,reset_l,enable);
      this.data = 0;
  endfunction

  task start_data(input int rpt,ref bit clk,ref T data_o);
    begin
      repeat (rpt)
        begin
          @(posedge clk);
          data_o = data++;
        end
    end
  endtask
endclass

module tb
  ();

 bit clk;
 bit rst,rst_l;
 logic [7:0] data;

 dataclass #(logic [7:0]) cls;
 
//  Gray dut ( .* );   
 
always #10 clk = ~clk;
assign rst_l = ~rst;

  initial
    begin  
      cls = new();
      cls.rst_down(5,clk);
      cls.wt(5,clk);
      cls.reset_l = 0;
      cls.wt(3,clk);
      cls.reset_l = 1;
      cls.wt(10,clk);
      cls.start_data(7,clk,data);
      cls.reset = 1;
      rst = cls.reset;
       #150; 
       $stop; 
     end 
     

endmodule