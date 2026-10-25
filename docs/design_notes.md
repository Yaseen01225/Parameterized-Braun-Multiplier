# Professional Design Notes — No-for-Loop Parameterized Multiplier

**Developer:** Ghulam Yaseen Nangraj | **Date:** 2026-10-24  
**Language:** Verilog-2001 | **Tool flow:** Vivado 2025.2.1 / xsim

## Functional equation
For unsigned A and B, `product = A × B`. The output width is `2*WIDTH`, which can represent the maximum product `(2^WIDTH-1)^2`.

## Partial-product operation
Each multiplier bit gates every bit of A. The resulting row is zero when that multiplier bit is zero, or a copy of A when it is one. The row is shifted left by its index and added to the running sum.

## How the design avoids `for`
The top module supplies a zero sum to stage zero. Each stage calculates one partial-product row and instantiates a stage with `ROW_INDEX+1`. A generate-time conditional terminates when `ROW_INDEX` reaches `WIDTH`. This is elaboration-time recursive module instantiation, not runtime software recursion. No `for` statement is used in the RTL or testbench.

## Braun architecture distinction
A textbook Braun multiplier is a regular unsigned array of partial-product AND gates and half/full adders. This RTL uses a recursive accumulation chain instead of explicitly wiring the canonical HA/FA grid. Do not claim identical cell topology or timing without examining the synthesized netlist.

## Width and example
For WIDTH=4, operands range 0–15 and the maximum product is 225 (`8'b11100001`). A WIDTH-bit result would truncate valid high bits.

## Verification
The WIDTH=4 testbench uses nested `while` loops to check 16×16=256 input pairs. It compares the DUT to a reference multiplication computed in the testbench and uses `!==` to catch X/Z mismatches. Wider configurations should use directed/random tests because exhaustive vectors grow exponentially.

Useful cases: 0×0, 0×max, 1×max, max×max, powers of two, and alternating-bit patterns.

## Synthesis and timing
The module is combinational. Delay depends on the accumulation path and target mapping. FPGA synthesis may use LUTs, carry chains, DSP blocks, or a mixture. Compare architectures only with the same FPGA part, width, timing constraints, and synthesis settings. Record LUTs, DSPs, timing, and warnings.

## Signed arithmetic
This design is unsigned. Signed two's-complement multiplication needs correctly sized signed expressions or a dedicated architecture such as Baugh–Wooley.

## Checklist
- [ ] WIDTH >= 1
- [ ] Product width = 2*WIDTH
- [ ] All 256 WIDTH=4 tests pass
- [ ] No X/Z mismatches
- [ ] Synthesis warnings reviewed
- [ ] Schematic inspected if canonical Braun topology is required
