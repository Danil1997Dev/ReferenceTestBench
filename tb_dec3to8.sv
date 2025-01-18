`timescale 1ns/1ps
`include "baseclass.svh"
 
typedef struct packed{
  logic [2:0] A;  
  logic [7:0] Y;
} dec_t;

class dataclass #(parameter type T = int) extends BaseVerificationClass;
  T data_inc; 
  rand T data_rand;

  function new(base_t base_set_in = 3'b100);
      super.base_set = base_set_in;
      this.data_inc = 0;
      this.data_rand = $urandom();
  endfunction

  task rand_data(input int rpt,ref bit clk,ref T data_o);
    begin
      repeat (rpt)
        begin
          @(posedge clk);
          data_rand.A = $urandom();
          data_o.A = data_rand.A;
        end
    end
  endtask

  task inc_data(input int rpt,ref bit clk,ref T data_o);
    begin
      repeat (rpt)
        begin
          @(posedge clk);
          data_o.A = data_inc.A++;
        end
    end
  endtask
endclass

module tb_dec3to8
  ();

 bit clk;
 
 dec_t data;
 base_t base_set;
 
  //logic [2:0] A;  
  //logic [7:0] Y;

 dataclass #(dec_t) cls = new();
 
 dec3to8 dut ( 
             .enable(base_set.enable),
             .A(data.A),
             .Y(data.Y) 
             );   
 
always #10 clk = ~clk;
 //assign A = data.A;
 //assign Y = data.Y;

  initial
    begin  
      //cls = new();
      cls.rst(1,clk,base_set);
      cls.rst_down(5,clk,base_set);
      cls.en_down(3,clk,base_set);
      cls.inc_data(45,clk,data);
      cls.wt(1,clk);
      cls.rand_data(45,clk,data);

       #150; 
       $stop; 
     end 
     

endmodule