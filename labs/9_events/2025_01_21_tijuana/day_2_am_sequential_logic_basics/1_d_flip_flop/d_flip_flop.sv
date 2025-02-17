module d_flip_flop
(
    input  clock,
    input  d,
    output logic q
);

    always_ff @ (posedge clock)
        q <= 1'b0;

endmodule
