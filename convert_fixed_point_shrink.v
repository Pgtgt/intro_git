module convert_fixed_point_shrink #(
    parameter X_DATA_WIDTH = 47,
    parameter X_DATA_WIDTH_INT = 5, // contain signd bit
    parameter Y_DATA_WIDTH = 31,
    parameter Y_DATA_WIDTH_INT = 1 // contain signd bit

) (
    input wire [X_DATA_WIDTH-1:0] x,
//    output wire [Y_DATA_WIDTH-1:0] y
    output reg [Y_DATA_WIDTH-1:0] y,
    output reg over1_warning = 1'b0

);
    reg [Y_DATA_WIDTH-1:0] y_upper;
    reg [Y_DATA_WIDTH-1:0] y_lower;
    reg [2:0] debug = 3'b000;
    initial begin
        y_upper = {1'b0, {(Y_DATA_WIDTH-1){1'b1}}};
        y_lower = {1'b1, {(Y_DATA_WIDTH-1){1'b0}}};
    end

always @(*) begin
    if ((x[X_DATA_WIDTH-1]==1'b0) & !(x[X_DATA_WIDTH-2:X_DATA_WIDTH-X_DATA_WIDTH_INT]=={(X_DATA_WIDTH_INT-1){1'b0}})) begin
        y = y_upper;    
        over1_warning = 1'b1;
    end else if ((x[X_DATA_WIDTH-1]==1'b1) & !(x[X_DATA_WIDTH-2:X_DATA_WIDTH-X_DATA_WIDTH_INT]=={(X_DATA_WIDTH_INT-1){1'b1}})) begin
        y = y_lower;
        over1_warning = 1'b1;
    end else begin
        y = {x[X_DATA_WIDTH-1], x[X_DATA_WIDTH-X_DATA_WIDTH_INT-1:X_DATA_WIDTH-X_DATA_WIDTH_INT-(Y_DATA_WIDTH-Y_DATA_WIDTH_INT) ]};
        over1_warning = 1'b0;
    end
end

endmodule