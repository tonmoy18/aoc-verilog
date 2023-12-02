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

logic [3:0] first_digit, last_digit, string_dig;
logic [3:0] first_digit_next, last_digit_next;
logic [63:0] result_next;

logic string_dig_found;

logic [7:0] char_fifo[5];
logic [7:0] fifo_mem[4];

enum logic [2:0] {
  FIRST_DIGIT,
  LAST_DIGIT
} state, next_state;


logic [7:0] zero_chars[4]   = '{111, 114, 101, 122};
logic [7:0] one_chars[3]    = '{101, 110, 111};
logic [7:0] two_chars[3]    = '{111, 119, 116};
logic [7:0] three_chars[5]  = '{101, 101, 114, 104, 116};
logic [7:0] four_chars[4]   = '{114, 117, 111, 102};
logic [7:0] five_chars[4]   = '{101, 118, 105, 102};
logic [7:0] six_chars[3]    = '{120, 105, 115};
logic [7:0] seven_chars[5]  = '{110, 101, 118, 101, 115};
logic [7:0] eight_chars[5]  = '{116, 104, 103, 105, 101};
logic [7:0] nine_chars[4]   = '{101, 110, 105, 110};


always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    output_valid <= '0;
  end else begin
    output_valid <= ~input_valid;
  end
end


always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    for (int i = 0; i < 5; i++)
      fifo_mem[i] = '0;
  end else if (input_valid) begin
    for (int i = 3; i > 0; i--)
      fifo_mem[i] = fifo_mem[i-1];
    fifo_mem[0] = char_in;
  end
end



always_comb begin
  
  char_fifo[0] = char_in;
  for (int i = 1; i < 5; i++)
    char_fifo[i] = fifo_mem[i-1];


  string_dig_found = 1'b0;
  string_dig = 15;

  string_dig = 0;
  // zero
  for (int i = 0; i < 4; i++)
    if (char_fifo[i] != zero_chars[i])
      string_dig = 15;

  // one
  if (string_dig == 15) begin
    string_dig = 1;
    for (int i = 0; i < 3; i++)
      if (char_fifo[i] != one_chars[i])
        string_dig = 15;
  end

  // two
  if (string_dig == 15) begin
    string_dig = 2;
    for (int i = 0; i < 3; i++)
      if (char_fifo[i] != two_chars[i])
        string_dig = 15;
  end

  // three
  if (string_dig == 15) begin
    string_dig = 3;
    for (int i = 0; i < 5; i++)
      if (char_fifo[i] != three_chars[i])
        string_dig = 15;
  end

  // four
  if (string_dig == 15) begin
    string_dig = 4;
    for (int i = 0; i < 4; i++)
      if (char_fifo[i] != four_chars[i])
        string_dig = 15;
  end

  // five
  if (string_dig == 15) begin
    string_dig = 5;
    for (int i = 0; i < 4; i++)
      if (char_fifo[i] != five_chars[i])
        string_dig = 15;
  end

  // six
  if (string_dig == 15) begin
    string_dig = 6;
    for (int i = 0; i < 3; i++)
      if (char_fifo[i] != six_chars[i])
        string_dig = 15;
  end

  // seven
  if (string_dig == 15) begin
    string_dig = 7;
    for (int i = 0; i < 5; i++)
      if (char_fifo[i] != seven_chars[i])
        string_dig = 15;
  end
  
  // eight
  if (string_dig == 15) begin
    string_dig = 8;
    for (int i = 0; i < 5; i++)
      if (char_fifo[i] != eight_chars[i])
        string_dig = 15;
  end

  // nine
  if (string_dig == 15) begin
    string_dig = 9;
    for (int i = 0; i < 4; i++)
      if (char_fifo[i] != nine_chars[i])
        string_dig = 15;
  end

  if (string_dig != 15) string_dig_found = 1;

  first_digit_next = first_digit;
  last_digit_next  = last_digit;
  result_next      = result;
  next_state       = state;

  case (state) 
    FIRST_DIGIT: begin
      if (input_valid && ((char_in >= 48 && char_in <= 57) || string_dig_found)) begin
        if (string_dig_found) begin
          first_digit_next = string_dig;
          last_digit_next  = string_dig;
        end else begin
          first_digit_next = (char_in - 48);
          last_digit_next = (char_in - 48);
        end
        next_state = LAST_DIGIT;
        // $display("fdn: %d", first_digit_next);
      end
    end
    LAST_DIGIT: begin
      if (input_valid && ((char_in >= 48 && char_in <= 57) || string_dig_found)) begin
        if (string_dig_found) begin
          last_digit_next = string_dig;
        end else begin
          last_digit_next = (char_in - 48);
        end
        // $display("ldn: %d", last_digit_next);
      end
      if (input_valid && char_in == 10) begin
        next_state  = FIRST_DIGIT;
        result_next =  result + 'd10 * first_digit_next + last_digit_next;
        $display("%d%d - %d", first_digit_next, last_digit_next, result_next);
        // $display("OPT2 %d%d - %d", first_digit, last_digit, 'd10 * first_digit + last_digit);
        // $display("INFO: sum after line: %d", result_next);
      end
    end
  endcase
end


always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    state <= FIRST_DIGIT;
  end else begin
    state <= next_state;
  end
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

endmodule
