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

enum logic [2:0] {
  FIRST_DIGIT,
  LAST_DIGIT
} state, next_state;


enum logic [6:0] {
  IDLE,
  S_Z, S_ZE, S_ZER, S_ZERO,
  S_O, S_ON, S_ONE,
  S_T, S_TW, S_TWO, S_TH, S_THR, S_THRE, S_THREE,
  S_F, S_FO, S_FOU, S_FOUR,
  S_FI, S_FIV, S_FIVE,
  S_S, S_SI, S_SIX,
  S_SE, S_SEV, S_SEVE, S_SEVEN,
  S_E, S_EI, S_EIG, S_EIGH, S_EIGHT,
  S_N, S_NI, S_NIN, S_NINE
} string_dig_state, next_string_dig_state;

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    string_dig_state <= IDLE;
  end else begin
    string_dig_state <= next_string_dig_state;
  end
end

always_comb begin
  next_string_dig_state = string_dig_state;
  string_dig_found = 1'b0;
  string_dig = 15;

  if (input_valid) begin
    case (string_dig_state)
      IDLE:
        next_string_dig_state = IDLE;

      // zero
      S_Z:
        if (char_in ==  101) next_string_dig_state = S_ZE;
        else                 next_string_dig_state = IDLE;
      S_ZE:
        if (char_in ==  114) next_string_dig_state = S_ZER;
        else                 next_string_dig_state = IDLE;
      S_ZER:
        if (char_in ==  111) next_string_dig_state = S_ZERO;
        else                 next_string_dig_state = IDLE;
      S_ZERO: begin
        next_string_dig_state = IDLE;
        string_dig_found = 1'b1;
        string_dig = 0;
      end

      // one
      S_O:
        if (char_in ==  110) next_string_dig_state = S_ON;
        else                 next_string_dig_state = IDLE;
      S_ON:
        if (char_in ==  101) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 1;
        end
        else                 next_string_dig_state = IDLE;

      // two, three
      S_T:
        if (char_in ==  119) next_string_dig_state = S_TW;
        else if (char_in ==  104) next_string_dig_state = S_TH;
        else                 next_string_dig_state = IDLE;
      S_TW:
        if (char_in ==  111) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 2;
        end
        else                 next_string_dig_state = IDLE;
      S_TH:
        if (char_in ==  114) next_string_dig_state = S_THR;
        else                 next_string_dig_state = IDLE;
      S_THR:
        if (char_in ==  101) next_string_dig_state = S_THRE;
        else                 next_string_dig_state = IDLE;
      S_THRE:
        if (char_in ==  101)  begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 3;
        end
        else                 next_string_dig_state = IDLE;

      // four, five
      S_F:
        if (char_in ==  111) next_string_dig_state = S_FO;
        else if (char_in ==  105) next_string_dig_state = S_FI;
        else                 next_string_dig_state = IDLE;
      S_FO:
        if (char_in ==  117) next_string_dig_state = S_FOU;
        else                 next_string_dig_state = IDLE;
      S_FOU:
        if (char_in ==  114) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 4;
        end
        else                 next_string_dig_state = IDLE;
      S_FI:
        if (char_in ==  118) next_string_dig_state = S_FIV;
        else                 next_string_dig_state = IDLE;
      S_FIV:
        if (char_in ==  101) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 5;
        end
        else                 next_string_dig_state = IDLE;

      // six, seven
      S_S:
        if (char_in ==  105) next_string_dig_state = S_SI;
        else if (char_in ==  101) next_string_dig_state = S_SE;
        else                 next_string_dig_state = IDLE;
      S_SI:
        if (char_in ==  120) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 6;
        end
        else                 next_string_dig_state = IDLE;
      S_SE:
        if (char_in ==  118) next_string_dig_state = S_SEV;
        else                 next_string_dig_state = IDLE;
      S_SEV:
        if (char_in ==  101) next_string_dig_state = S_SEVE;
        else                 next_string_dig_state = IDLE;
      S_SEVE:
        if (char_in ==  110) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 7;
        end
        else                 next_string_dig_state = IDLE;

      // eight
      S_E:
        if (char_in ==  105) next_string_dig_state = S_EI;
        else                 next_string_dig_state = IDLE;
      S_EI:
        if (char_in ==  103) next_string_dig_state = S_EIG;
        else                 next_string_dig_state = IDLE;
      S_EIG:
        if (char_in ==  104) next_string_dig_state = S_EIGH;
        else                 next_string_dig_state = IDLE;
      S_EIGH:
        if (char_in ==  116) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 8;
        end
        else                 next_string_dig_state = IDLE;

      // nine
      S_N:
        if (char_in ==  105) next_string_dig_state = S_NI;
        else                 next_string_dig_state = IDLE;
      S_NI:
        if (char_in ==  110) next_string_dig_state = S_NIN;
        else                 next_string_dig_state = IDLE;
      S_NIN:
        if (char_in ==  101) begin
          next_string_dig_state = IDLE;
          string_dig_found = 1'b1;
          string_dig = 9;
        end
        else                 next_string_dig_state = IDLE;

    endcase

    if (next_string_dig_state == IDLE || string_dig_found) begin
      case (char_in)
        122: next_string_dig_state = S_Z; 
        111: next_string_dig_state = S_O; 
        116: next_string_dig_state = S_T; 
        102: next_string_dig_state = S_F; 
        115: next_string_dig_state = S_S; 
        101: next_string_dig_state = S_E; 
        110: next_string_dig_state = S_N; 
      endcase
    end
  end

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

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    output_valid <= '0;
  end else begin
    output_valid <= ~input_valid;
  end
end


endmodule
