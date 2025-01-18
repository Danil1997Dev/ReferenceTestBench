typedef struct packed{
  bit reset;
  bit reset_l;
  bit enable;
} base_t;

class BaseVerificationClass #(parameter type tset_t = int);
  base_t base_set;
  tset_t test_state;
  
  function new(base_t base_set_in = 3'b100);
      this.base_set = base_set_in;
      this.test_state = RESET;
  endfunction

  function start(base_t base_set_in = 3'b011,ref base_t base_set_out);
      this.base_set = base_set_in;
      base_set_out = this.base_set;
      this.test_state = INIT;
  endfunction

  task rst_down(int rpt,ref bit clk,ref base_t base_set_out);
    begin 
      repeat (rpt)
        begin
          @(posedge clk);
        end
      start(3'b010,base_set_out);
      this.test_state = INIT;
    end
  endtask

  task rst(int rpt,ref bit clk,ref base_t base_set_out);
    begin 
      repeat (rpt)
        begin
          @(posedge clk);
        end
      start(3'b100,base_set_out);
      this.test_state = RESET;
    end
  endtask

  task en_down(int rpt,ref bit clk,ref base_t base_set_out);
    begin 
      repeat (rpt)
        begin
          @(posedge clk);
        end
      start(3'b011,base_set_out);
      this.test_state = ENABLE;
    end
  endtask

  task wt(int rpt,ref bit clk);
    begin 
      repeat (rpt)
        begin
          @(posedge clk);
          this.test_state = WHAIT;
        end
    end
  endtask
endclass