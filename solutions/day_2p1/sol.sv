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

localparam logic [7:0] RED_CNT_MAX = 12;
localparam logic [7:0] GREEN_CNT_MAX = 13;
localparam logic [7:0] BLUE_CNT_MAX = 14;

logic [63:0] next_result;

logic [7:0] game_id, next_game_id;

logic char_valid_digit;
logic [7:0] char_digit;

logic [7:0] red_count, green_count, blue_count;
logic [7:0] next_cube_count;
logic [7:0] cube_count;

logic valid_game, valid_game_next;

enum logic [2:0] {
  IDLE        = 0,
  GAME_ID     = 1,
  PRE_NUM     = 2,
  NUM         = 3,
  COLOR       = 4,
  POST_COL    = 5
} state, next_state;

enum logic [1:0] {
  RED   = 0,
  GREEN = 1,
  BLUE  = 2
} char_color;

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always_comb begin
  next_result      = result;
  next_state       = state;

  if (input_valid) begin
    case (state) 
      IDLE: if (char_in == 32) next_state = GAME_ID;
      GAME_ID: if (char_in == 58) next_state = PRE_NUM;
      PRE_NUM: if (char_in == 32) next_state = NUM;
      NUM: if (char_in == 32) next_state = COLOR;
      COLOR: next_state = POST_COL;
      POST_COL: if (char_in == 44 || char_in == 59) next_state = PRE_NUM;
                else if (char_in == 10) next_state = IDLE;
    endcase
  end

end

assign char_valid_digit = (char_in >= 48 && char_in <= 57);
assign char_digit = char_in - 48;

always_comb begin
  next_game_id = game_id;
  if (input_valid) begin
      if (state == IDLE) next_game_id = 0;
      else if (state == GAME_ID && char_valid_digit) next_game_id = 8'd10 * game_id + char_digit;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    game_id <= '0;
  end else begin
    game_id <= next_game_id;
  end
end

always_comb begin
  next_cube_count = cube_count;
  if (input_valid) begin
    if (state == PRE_NUM) next_cube_count = 0;
    else if (state == NUM && char_valid_digit) next_cube_count = 8'd10 * cube_count + char_digit;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    cube_count <= '0;
  end else begin
    cube_count <= next_cube_count;
  end
end

always_comb begin
  char_color = RED;
  if (input_valid) begin
    if (state == COLOR) begin
      if (char_in == 114) char_color = RED;
      else if (char_in == 103) char_color = GREEN;
      else if (char_in == 98) char_color = BLUE;
    end
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    red_count <= '0;
    green_count <= '0;
    blue_count <= '0;
  end else if (state == IDLE) begin
    red_count <= '0;
    green_count <= '0;
    blue_count <= '0;
  end else if (state == COLOR) begin
    if (char_color == RED)
      red_count <= cube_count;
    if (char_color == GREEN)
      green_count <= cube_count;
    if (char_color == BLUE)
      blue_count <= cube_count;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    output_valid <= '0;
  end else begin
    output_valid <= ~input_valid;
  end
end

always_comb begin
  valid_game_next = valid_game;

  if (state == IDLE) begin
    valid_game_next = 1;
  end else if (state == POST_COL) begin
    if (~valid_game || red_count > RED_CNT_MAX || green_count > GREEN_CNT_MAX || blue_count > BLUE_CNT_MAX) begin
      valid_game_next = 0;
    end
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    valid_game <= 1'b0;
  end else begin
    valid_game <= valid_game_next;
  end
end

always_comb begin
  next_result = result;
  if (state == POST_COL && next_state == IDLE && valid_game) begin
    $display("INFO: valid game_id: %d", game_id);
    next_result = result + game_id;
  end
end

always_ff @ (posedge clk, negedge rst_n) begin
  if (!rst_n) begin
    result <= '0;
  end else begin
    result <= next_result;
  end
end

endmodule
