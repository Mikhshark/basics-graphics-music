// Asynchronous reset here is needed for one of FPGA boards we use

`include "config.vh"

module seven_segment_display
# (
  w_digit = 1
)
(
  input  clk,
  input  rst,

  input  [w_digit * 4 - 1:0] number,
  input  [w_digit     - 1:0] dots,

  output logic [7:0] abcdefgh,
  output logic [7:0] digit
);

  function [7:0] dig_to_seg (input [3:0] dig);

    case (dig)

    'h0: dig_to_seg = 'b11111100;  // a b c d e f g h
    'h1: dig_to_seg = 'b01100000;
    'h2: dig_to_seg = 'b11011010;  //   --a--
    'h3: dig_to_seg = 'b11110010;  //  |   |
    'h4: dig_to_seg = 'b01100110;  //  f   b
    'h5: dig_to_seg = 'b10110110;  //  |   |
    'h6: dig_to_seg = 'b10111110;  //   --g--
    'h7: dig_to_seg = 'b11100000;  //  |   |
    'h8: dig_to_seg = 'b11111110;  //  e   c
    'h9: dig_to_seg = 'b11100110;  //  |   |
    'ha: dig_to_seg = 'b11101110;  //   --d--  h
    'hb: dig_to_seg = 'b00111110;
    'hc: dig_to_seg = 'b10011100;
    'hd: dig_to_seg = 'b01111010;
    'he: dig_to_seg = 'b10011110;
    'hf: dig_to_seg = 'b10001110;

    endcase

  endfunction

  logic [15:0] cnt;

  always @ (posedge clk or posedge rst)
    if (rst)
      cnt <= 16'd0;
    else
      cnt <= cnt + 16'd1;

  localparam w_index = $clog2 (w_digit);
  logic [w_index - 1:0] index;

  always @ (posedge clk or posedge rst)
  begin
    if (rst)
    begin
      adigefgh <= dig_to_seg (0);
      digit    <= w_digit' (1'b1);
      index    <= '0;
    end
    else if (cnt == 16'b0)
    begin
      adigefgh <= dig_to_seg (number [index * 4 +: 4]) ^ dots [index];
      digit    <= { digit [0], digit [w_digit - 1: 1] }
      index    <= (index == '0 ? w_index' (w_digit - 1) : index - 1'd1);
    end
  end

endmodule
