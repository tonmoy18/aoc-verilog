module sol(
input clk,
input rst_n,
input input_valid,
input [7:0] char_in,
output input_ready,

output reg [63:0] result,
output output_valid
);

logic [63:0] result_next;

logic char_dot;
logic char_valid_digit;
logic [7:0] char_digit;
logic char_sp_char;

logic prev_char_dot;
logic prev_char_valid_digit;
logic prev_char_sp_char;

logic [8:0] num_start_positions[70];
logic [8:0] num_end_positions[70];
logic [9:0] numbers[70];

logic [8:0] prev_num_start_positions[70];
logic [8:0] prev_num_end_positions[70];
logic [9:0] prev_numbers[70];


logic flag_first_line;

assign input_ready = 1;

logic [63:0] next_result;

logic [9:0] current_num;

logic [7:0] prev_c;

logic [8:0] idx;

logic [8:0] current_num_idx;

enum logic [2:0] {
  DOT         = 0,
  NUM         = 1,
  SP_CHAR     = 2
} state, next_state;

assign char_dot = (char_in == 46);
assign char_valid_digit = (char_in >= 48 && char_in <= 57);
assign char_digit = char_in - 48;
assign char_sp_char = !char_dot & !char_valid_digit & !(char_in == 10);

assign prev_char_dot = (prev_c == 46);
assign prev_char_valid_digit = (prev_c >= 48 && prev_c <= 57);
assign prev_char_sp_char = !prev_char_dot & !prev_char_valid_digit & !(prev_c == 10);


always_comb begin
  next_state = state;

  case (state)
    DOT: begin
      if (input_valid) begin
        if (char_valid_digit) begin
          next_state = NUM;
        end
        else if (char_in != 46) begin
          next_state = SP_CHAR;
        end
      end
    end
    NUM: begin
      if (input_valid) begin
        if (char_dot) begin    // .
          next_state = DOT;
        end else if (!char_valid_digit) begin  // sp_char
          next_state = SP_CHAR;
        end
      end
    end
    SP_CHAR:
      if (input_valid) begin
        if (char_dot) begin    // .
          next_state = DOT;
        end else if (char_valid_digit) begin
          next_state = NUM;
        end
      end
  endcase
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    current_num <= '0;
  end else if (char_valid_digit) begin
    current_num <= 'd10 * current_num + char_digit;
  end else begin
    current_num <= '0;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    prev_c <= 46;
  end else if (input_valid) begin
    prev_c <= char_in;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    idx <= 0;
  end else if (input_valid) begin
    if (char_in == 10) idx <= 0;
    else idx <= idx + 1;
  end
end

logic flag_symbol_before_num_reg;
logic flag_symbol_before_num_next;
logic flag_symbol_before_num;

logic prev_line_had_symbol_in_range;

logic clr_prev_num;
logic prev_num_extra;
logic [8:0] prev_scan_idx;

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    flag_symbol_before_num_reg <= 0;
  end else begin
    flag_symbol_before_num_reg <= flag_symbol_before_num_next;
  end
end

assign flag_symbol_before_num = flag_symbol_before_num_reg | flag_symbol_before_num_next;

always_comb begin
  flag_symbol_before_num_next = flag_symbol_before_num_reg;
  if (input_valid) begin
    if (char_in == 10) flag_symbol_before_num_next = 0;
    else if (prev_char_sp_char && char_valid_digit) flag_symbol_before_num_next = 1;
    else if (!char_valid_digit) flag_symbol_before_num_next = 0;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    current_num_idx <= 0;
  end else if (input_valid) begin
    if (char_in == 10)
      current_num_idx <= 0;
    else if(current_num > 0 && char_dot && !flag_symbol_before_num) begin
      current_num_idx <= current_num_idx + 1;
    end
  end
end


always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    for (int i = 0; i < 70; i++) begin
      prev_num_start_positions[i] = '1;
      prev_num_end_positions[i]   = '1;
      prev_numbers[i]             = 0;
      num_start_positions[i] = '1;
      num_end_positions[i] = '1;
      numbers[i] = '0;
    end
  end else if (input_valid) begin
    if (char_in == 10) begin
      for (int i = 0; i < 70; i++) begin
        prev_num_start_positions[i] = num_start_positions[i];
        prev_num_end_positions[i]   = num_end_positions[i];
        prev_numbers[i]             = numbers[i];
        num_start_positions[i] = '1;
        num_end_positions[i] = '1;
        numbers[i] = '0;
      end
    end else
      if (clr_prev_num) begin
        prev_numbers[prev_scan_idx] <= '0;
      end
      if (prev_num_extra) begin
        prev_numbers[prev_scan_idx+1] <= '0;
      end
      if (char_valid_digit & ~prev_char_valid_digit) begin
        num_start_positions[current_num_idx] = idx;
      end
      if (current_num > 0 & char_dot & ~prev_line_had_symbol_in_range) begin
        num_end_positions[current_num_idx] = idx;
        numbers[current_num_idx] = current_num;
      end
  end
end


always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    for (int i = 0; i < 70; i++) begin
    end
  end else if (input_valid && char_in == 10) begin
    for (int i = 0; i < 70; i++) begin
    end
  end else if (input_valid & char_valid_digit & ~prev_char_valid_digit) begin
  end
end

// FIXME
assign prev_line_had_symbol_in_range = 0;

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    flag_first_line <= 1;
  end
  else if (input_valid & char_in == 10) begin
    flag_first_line <= 0;
    $display("New line");
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    prev_scan_idx <= '0;
  end else if (input_valid) begin
    if (char_in == 10) begin
      prev_scan_idx <= '0;
    end else if (!flag_first_line & idx > prev_num_end_positions[prev_scan_idx] & prev_num_end_positions[prev_scan_idx] != '1 & prev_scan_idx < 69) begin
      if (prev_num_extra)
        prev_scan_idx <= prev_scan_idx + 2;
      else
        prev_scan_idx <= prev_scan_idx + 1;
    end
  end
end

always_comb begin
  prev_num_extra = 0;
  clr_prev_num = 0;
  result_next = result;
  if (input_valid) begin
    if ((char_sp_char & current_num > 0) | (!char_valid_digit & flag_symbol_before_num)) begin
      // immediately before/after
      $display("Becasue of immediate before/after, at idx: %d, adding %d to result", idx, current_num);
      result_next = result_next + current_num;
    end
    if (char_sp_char & !flag_first_line & idx+1 >= prev_num_start_positions[prev_scan_idx] & idx < prev_num_end_positions[prev_scan_idx]+1) begin
      $display("Becasue of number at prev line, at idx: %d, adding %d to result", idx, prev_numbers[prev_scan_idx]);
      result_next = result_next + prev_numbers[prev_scan_idx];
      clr_prev_num = 1;
      if (prev_scan_idx < 68 & prev_num_start_positions[prev_scan_idx+1] <= idx+1) begin
        $display("Becasue of another number at prev line, at idx: %d, adding %d to result", idx, prev_numbers[prev_scan_idx+1]);
        result_next = result_next + prev_numbers[prev_scan_idx+1];
        prev_num_extra = 1;
      end
    end
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    result <= '0;
  end else  begin
    result <= result_next;
  end
end

endmodule
