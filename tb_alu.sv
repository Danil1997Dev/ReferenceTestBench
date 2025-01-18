`timescale 1ns/1ps

typedef enum{
  RESET,
  INIT,
  ENABLE,
  WHAIT,
//USER BEGIN
  INC_TEST,
  RAND_TEST,
  INIT_DATA
//USER END
} state_test_t;


/*
baseclass include following four task for using of user:
  rst_down - all reset signals will be passive state after 'rpt' clock cycle
  rst - all reset signals will be active state after 'rpt' clock cycle
  en_down - enable signal will be active state after 'rpt' clock cycle
  wt - task wait 'rpt' number of clock cycle
*/
`include "baseclass.svh"
 
typedef struct packed {
//USER BEGIN
  logic [1:0] slct;
  logic [3:0] A,B; 
  logic signed [3:0] Y;
//USER END
} data_t;
 
class dataclass #(parameter type T = int) extends BaseVerificationClass #(state_test_t);
  rand T data; 

  function new(base_t base_set_in = 3'b100);
      super.base_set = base_set_in;
//USER BEGIN
      this.data = 0;
//USER END
  endfunction

  task init_data(ref T data_o);
    begin  
      data_o = data;
	  super.test_state = INIT_DATA;
    end
  endtask

  task rand_data(input int rpt,ref bit clk,ref T data_o);
    begin
      repeat (rpt)
        begin
          @(posedge clk);
//USER BEGIN
          data.A = $urandom();
          data.B = $urandom();
          data.slct++;
//USER END
          data_o = data;
          super.test_state = RAND_TEST;
        end
    end
  endtask

  task inc_data(input int rpt,ref bit clk,ref T data_o);
    begin
      repeat (rpt)
        begin
          @(posedge clk);
//USER BEGIN
          data_o.A = data.A++;
          data_o.B = data.B++;
          data_o.slct = data.slct++;
//USER END
          super.test_state = INC_TEST;
        end
    end
  endtask

//USER BEGIN
 
//USER END
endclass

module tb_alu
  ();

 bit clk;
 
 data_t data, chek_data;
 base_t base_set;
 

 dataclass #(data_t) cls = new();

//USER BEGIN
  logic [1:0] slct;
  logic [3:0] A,B; 
  logic [3:0] Y;

 alu dut ( .* );
 
always @*
  begin
    slct = data.slct;
	A = data.A;
	B = data.B;
	data.Y = Y;
  end
//USER END

chek_module chk (.*);

assign chek_data = data;

always #10 clk = ~clk;
 
 
  initial
    begin  
//USER BEGIN
      cls.rst(1,clk,base_set);
	  cls.init_data(data);
      cls.rst_down(5,clk,base_set);
      cls.en_down(3,clk,base_set);
      cls.inc_data(45,clk,data);
      cls.wt(1,clk);
      cls.rand_data(45,clk,data);
//USER END
       #150; 
       $stop; 
     end 
     

endmodule

module chek_module(
 input clk,
 ref base_t base_set,data_t chek_data
 );
 
 
//USER BEGIN 
 logic signed [3:0] sub_s;
 logic [3:0] and_s,or_s,sum_s; 

 assign sub_s = chek_data.A - chek_data.B;
 assign and_s = chek_data.A & chek_data.B;
 assign or_s = chek_data.A | chek_data.B;
 assign sum_s = chek_data.A + chek_data.B;
 
          property sum_p;
            @(negedge clk) disable iff (chek_data.slct != 0 || base_set.enable != 1)
              chek_data.Y == sum_s
          endproperty
          property sub_p;
            @(negedge clk) disable iff (chek_data.slct != 1 || base_set.enable != 1)
              chek_data.Y == sub_s
          endproperty
          property and_p;
            @(negedge clk) disable iff (chek_data.slct != 2 || base_set.enable != 1)
              chek_data.Y == and_s
          endproperty
          property or_p;
            @(negedge clk) disable iff (chek_data.slct != 3 || base_set.enable != 1)
              chek_data.Y == or_s
          endproperty
 
  always @(posedge clk)
    begin

                 assert property (sum_p);

                 assert property (sub_p);

                 assert property (and_p);

                 assert property (or_p);

    end
//USER END
 
     

endmodule