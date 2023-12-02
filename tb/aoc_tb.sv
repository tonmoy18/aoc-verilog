module aoc_tb(
input clk,
input rst_n
);

logic input_valid;
logic [7:0] char_in;
logic input_ready;

logic [63:0] result;
logic output_valid;

sol sol(
.clk                    (clk),
.rst_n                  (rst_n),
.input_valid            (input_valid),
.char_in                (c),
.input_ready            (input_ready),
.result                 (result),
.output_valid           (output_valid)
);

int fid;
string input_filename;
string fname_base;
bit eof;

logic [7:0] c;

initial begin
  if ($value$plusargs("IN_FILENAME=%s", input_filename)) begin
    $display("INFO: opening file %s", input_filename);
    fid = $fopen(input_filename, "r");
  end else begin
    $display("ERROR opening input file");  
  end

  if (!fid) begin
    $display("ERROR opening input file");  
  end

end

always_ff @ (negedge clk, negedge rst_n) begin
  if (rst_n == 1'b0) begin
    eof = 1'b0;
    c = '0;
    input_valid = 0;
  end else begin
    eof = $feof(fid);
    if (input_ready) begin
      if (!eof) begin
        c = $fgetc(fid);
        input_valid = 1;
      end else begin
        input_valid = 0;
      end
    end
    if (eof && output_valid) begin
      $fclose(fid);
      $display("RESULT: %d", result);
      $finish();
    end
  end
end

always_comb begin
end


endmodule
