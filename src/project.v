`default_nettype none

module tt_um_james_5bit_comb_adder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs

    input  wire [7:0] uio_in,   // Bidirectional inputs
    output wire [7:0] uio_out,  // Bidirectional outputs
    output wire [7:0] uio_oe,   // Bidirectional output enables

    input  wire       ena,      // Always 1 when design is selected
    input  wire       clk,      // Unused: combinational design
    input  wire       rst_n     // Unused: combinational design
);

    // Inputs:
    //   ui_in[4:0]  = A[4:0]
    //   uio_in[4:0] = B[4:0]
    //   ui_in[5]    = carry-in
    //
    // Outputs:
    //   uo_out[4:0] = SUM[4:0]
    //   uo_out[5]   = carry-out
    //   uo_out[6]   = signed overflow flag
    //   uo_out[7]   = zero flag

    wire [4:0] a;
    wire [4:0] b;
    wire       cin;
    wire [5:0] sum;

    assign a   = ui_in[4:0];
    assign b   = uio_in[4:0];
    assign cin = ui_in[5];

    assign sum = {1'b0, a} + {1'b0, b} + {5'b00000, cin};

    assign uo_out[4:0] = sum[4:0];
    assign uo_out[5]   = sum[5];

    // Signed overflow for 5-bit two's-complement addition.
    assign uo_out[6] = (a[4] == b[4]) && (sum[4] != a[4]);

    // Zero flag for the 5-bit result.
    assign uo_out[7] = (sum[4:0] == 5'b00000);

    // Keep all bidirectional pins as inputs.
    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;

    // Mark unused inputs as intentionally unused.
    wire _unused = &{ena, clk, rst_n, ui_in[7:6], uio_in[7:5], 1'b0};

endmodule
