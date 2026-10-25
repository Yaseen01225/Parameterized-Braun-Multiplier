
`timescale 1ns / 1ps

module tb_braun_multiplier;

    // Testbench signals: 4-bit inputs and 8-bit output.
    reg  [3:0] a;
    reg  [3:0] b;
    wire [7:0] product;

    integer error_count;

    // Design Under Test.
    braun_multiplier dut (
        .a       (a),
        .b       (b),
        .product (product)
    );

    initial begin

        // Initialize signals.
        a = 4'd0;
        b = 4'd0;
        error_count = 0;

        $display("====================================");
        $display("  4-Bit Multiplier Verification");
        $display("====================================");

        // TEST 1: 3 x 5 = 15
        a = 4'd3;
        b = 4'd5;
        #10;

        if (product !== 8'd15) begin
            error_count = error_count + 1;
            $display("FAIL TEST 1: Got %0d, Expected 15", product);
        end
        else
            $display("PASS TEST 1: 3 x 5 = %0d", product);

        // TEST 2: 7 x 9 = 63
        a = 4'd7;
        b = 4'd9;
        #10;

        if (product !== 8'd63) begin
            error_count = error_count + 1;
            $display("FAIL TEST 2: Got %0d, Expected 63", product);
        end
        else
            $display("PASS TEST 2: 7 x 9 = %0d", product);

        // TEST 3: 14 x 15 = 182
        a = 4'd14;
        b = 4'd13;
        #10;

        if (product !== 8'd182) begin
            error_count = error_count + 1;
            $display("FAIL TEST 3: Got %0d, Expected 0", product);
        end
        else
            $display("PASS TEST 3: 14 x 13 = %0d", product);

        // TEST 4: 15 x 15 = 225
        a = 4'd15;
        b = 4'd15;
        #10;

        if (product !== 8'd225) begin
            error_count = error_count + 1;
            $display("FAIL TEST 4: Got %0d, Expected 225", product);
        end
        else
            $display("PASS TEST 4: 15 x 15 = %0d", product);
            
        // TEST 5: 15 x 0 = 0
        a = 4'd0;
        b = 4'd10;
        #10;

        if (product !== 8'd0) begin
            error_count = error_count + 1;
            $display("FAIL TEST 4: Got %0d, Expected 225", product);
        end
        else
            $display("PASS TEST 4: 10 x 0 = %0d", product);

        // Display final result.
        $display("------------------------------------");
        $display("Tests Executed : 4");
        $display("Errors Detected: %0d", error_count);

        if (error_count == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: VERIFICATION FAILED");

        $display("====================================");

        $finish;

    end

endmodule
