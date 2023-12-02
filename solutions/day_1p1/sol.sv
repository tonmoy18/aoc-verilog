module sol(
input clk,
input rst_n,
input input_valid,
input [7:0] char_in,
output input_ready,

output reg [63:0] result,
output output_valid
);

assign input_ready = 1;

logic [3:0] first_digit, last_digit;
logic [3:0] first_digit_next, last_digit_next;
logic [63:0] result_next;

enum logic [2:0] {
  FIRST_DIGIT,
  LAST_DIGIT
} state, next_state;

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    state <= FIRST_DIGIT;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  first_digit_next = first_digit;
  last_digit_next  = last_digit;
  result_next      = result;
  next_state       = state;

  case (state) 
    FIRST_DIGIT: begin
      if (input_valid && char_in >= 48 && char_in <= 57) begin
        first_digit_next = (char_in - 48);
        last_digit_next = (char_in - 48);
        next_state = LAST_DIGIT;
        // $display("fdn: %d", first_digit_next);
      end
    end
    LAST_DIGIT: begin
      if (input_valid && char_in >= 48 && char_in <= 57) begin
        last_digit_next = (char_in - 48);
        // $display("ldn: %d", last_digit_next);
      end
      if (input_valid && char_in == 10) begin
        next_state  = FIRST_DIGIT;
        result_next =  result + 'd10 * first_digit + last_digit;
        $display("%d%d - %d", first_digit, last_digit, result_next);
        // $display("INFO: sum after line: %d", result_next);
      end
    end
  endcase
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    result <= '0;
    first_digit <= '0;
    last_digit <= '0;
  end else begin
    result <= result_next;
    first_digit <= first_digit_next;
    last_digit  <= last_digit_next ;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    output_valid <= '0;
  end else begin
    output_valid <= ~input_valid;
  end
end


endmodule
