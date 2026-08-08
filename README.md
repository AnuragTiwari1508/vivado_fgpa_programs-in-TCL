# FPGA Boolean Board — Complete Digital Circuits Package

## 0. Source-of-truth statement (read this first)

Every pin number in this package is copied **verbatim** from the RealDigital Boolean
Board's official master constraints file:

> `https://www.realdigital.org/downloads/8d5c167add28c014173edcf51db78bb9.txt`
> (linked from the official tutorial: "Controlling LEDs using Slide Switches",
> `https://www.realdigital.org/doc/d5e87b98c28ed5add0a790efd6b19e66`)

No pin was guessed. Two things are **not** confirmed by RealDigital's own documentation
and are flagged explicitly below and in code comments — treat them as assumptions to
verify on the physical board, not facts:

| Item | Status |
|---|---|
| Switch/LED polarity (active-high) | **CONFIRMED** — official tutorial drives `led = sw` directly with no inversion. |
| Clock pin/frequency (F14, 100 MHz) | **CONFIRMED** — stated directly in the official master XDC comment. |
| Pushbutton polarity (assumed active-HIGH, pressed=1) | **ASSUMED**, not published in RealDigital's docs. Matches the convention of every other board in this family. Verify with a multimeter or the `led_sw`-style one-line test before trusting it in a design where polarity matters. |
| Dedicated reset pin | **DOES NOT EXIST on this board.** Independently confirmed by the open-source board-files repo `github.com/proto17/RealDigital_BooleanBoard`: *"There is no reset port on this board, so when creating block designs the user will need to specify a reset port by hand."* This package uses `btn[0]` as a **functional** reset — a design choice, not a board-defined reset pin. |

---

## 1. Hardware

| Item | Value |
|---|---|
| Board | RealDigital Boolean Board |
| FPGA family | Xilinx/AMD Spartan-7 |
| FPGA part (Vivado string) | `xc7s50csga324-1` (XC7S50-1CSGA324) |
| On-board clock | 100 MHz oscillator, pin **F14**, `LVCMOS33` |
| I/O standard (all digital I/O in this package) | `LVCMOS33` |
| Switches | 16 slide switches, active-HIGH |
| LEDs | 16 discrete LEDs, active-HIGH |
| Pushbuttons | 4 buttons, assumed active-HIGH (see §0) |
| RGB LEDs | 2 (RGB0, RGB1) — not used by default demos, pins listed below for reference |
| 7-segment displays | 2 four-digit displays (D0, D1); this package only drives D0 |
| Reset | **No dedicated reset pin** — `btn[0]` used as functional reset throughout |

## 2. Pin Mapping (verified, from official master XDC)

| Signal | Board Component | FPGA Pin | Active Level | Direction |
|---|---|---|---|---|
| clk | 100 MHz oscillator | F14 | n/a | input |
| btn[0] | Pushbutton 0 (**used as functional reset**) | J2 | HIGH (assumed) | input |
| btn[1] | Pushbutton 1 | J5 | HIGH (assumed) | input |
| btn[2] | Pushbutton 2 | H2 | HIGH (assumed) | input |
| btn[3] | Pushbutton 3 | J1 | HIGH (assumed) | input |
| sw[0..15] | Slide switches 0-15 | V2,U2,U1,T2,T1,R2,R1,P2,P1,N2,N1,M2,M1,L1,K2,K1 | HIGH | input |
| led[0..15] | LEDs 0-15 | G1,G2,F1,F2,E1,E2,E3,E5,E6,C3,B2,A2,B3,A3,B4,A4 | HIGH | output |
| RGB0[R,G,B] | RGB LED 0 | V6,V4,U6 | HIGH | output |
| RGB1[R,G,B] | RGB LED 1 | U3,V3,V5 | HIGH | output |
| D0_AN[0..3] | 7-seg display 0, digit anodes | D5,C4,C7,A8 | **LOW** (enable) | output |
| D0_SEG[0..7] | 7-seg display 0, segments a..g,dp | D7,C5,A5,B7,A7,D6,B5,A6 | **LOW** (lit) | output |
| D1_AN[0..3] | 7-seg display 1, digit anodes | H3,J4,F3,E4 | LOW (enable) | output |
| D1_SEG[0..7] | 7-seg display 1, segments a..g,dp | F4,J3,D2,C2,B1,H4,D1,C1 | LOW (lit) | output |
| UART_rxd/txd | On-board UART | V12 / U11 | n/a | in/out |

Full pin list is also programmatically available in `board_pins.py` (used to generate every XDC in this package) if you regenerate or extend circuits.

## 3. Circuit List (25 circuits)

**Combinational:** `mux2`, `mux4`, `half_adder`, `full_adder`, `ripple_adder4` (4-bit), `decoder2to4`, `encoder4to2` (priority), `comparator4`

**Sequential:** `d_ff`, `t_ff`, `jk_ff`, `register4`, `up_counter4`, `down_counter4`, `up_down_counter4`, `shift_register4` (SIPO), `ring_counter4`, `johnson_counter4`

**Other:** `bin_to_7seg` + `bcd_counter` (display), `traffic_light_fsm` (Moore FSM), `clock_divider` + `button_debounce` (utilities)

**Board demos (synthesizable top modules with real pin constraints):** `mux_demo_top`, `full_adder_demo_top`, `counter_demo_top`, `register_demo_top`, `shift_register_demo_top`, `seven_seg_demo_top`, `traffic_light_demo_top`

All base circuits (combinational/sequential/display/utilities folders) are pure logic
building blocks meant to be simulated standalone and instantiated by a top-level design;
they intentionally have **no XDC** of their own (there is nothing meaningful to place on
the board for a bare `half_adder`, for example). Only the `board_demo/` folder and the
two circuits that are inherently board-facing (`seven_seg_demo_top`, `traffic_light_demo_top`)
carry real pin constraints and produce a bitstream.

## 4. How to Build (everything)

```tcl
# In Vivado Tcl Console:
cd /path/to/FPGA_Boolean_Board
source master_build.tcl
```

This walks every circuit, creates its project, adds RTL/TB/XDC, sets the top module, and
for any circuit with an XDC file runs synthesis → implementation → bitstream, copying the
resulting `.bit` back into that circuit's own folder. A pass/fail summary prints at the end.

## 5. How to Build One Circuit

```tcl
cd /path/to/FPGA_Boolean_Board/board_demo/counter_demo
source build.tcl
```

Works identically for any circuit folder — every folder has its own standalone `build.tcl`.

## 6. How to Simulate Only (fast, no synthesis)

```tcl
cd /path/to/FPGA_Boolean_Board
source master_test.tcl
```

Or simulate one circuit only by running its `build.tcl` (which launches simulation
automatically whenever a `tb/*.v` file exists) or manually:

```tcl
cd /path/to/FPGA_Boolean_Board/sequential/up_counter
create_project up_counter_sim vivado_proj -part xc7s50csga324-1
add_files rtl/up_counter4.v
add_files -fileset sim_1 tb/up_counter4_tb.v
set_property top up_counter4_tb [get_filesets sim_1]
launch_simulation
run all
```

## 7. How to Generate a Bitstream (single demo)

Any `board_demo/*` folder (or `display/seven_segment`, `fsm/traffic_light`):

```tcl
cd /path/to/FPGA_Boolean_Board/board_demo/mux_demo
source build.tcl
```

The `.bit` file is copied to that same folder when done.

## 8. How to Program the Board

1. Open Vivado.
2. **Open Hardware Manager** (Flow Navigator → PROGRAM AND DEBUG → Open Hardware Manager).
3. Click **Open target → Auto Connect** (board connects over its USB programming port).
4. Right-click the detected `xc7s50` device → **Program Device**.
5. Browse to the `.bit` file (e.g. `board_demo/counter_demo/counter_demo_top.bit`).
6. Click **Program**.
7. Physically exercise the switches/buttons and observe the LEDs/7-segment display per
   the physical-testing table for that demo below.

## 9. Physical Testing — per board demo

### mux_demo_top (`board_demo/mux_demo`)
```
Inputs:  SW7..SW4 = d3..d0 (4:1 mux data inputs)
         SW9,SW8  = sel[1:0]
Outputs: LED0 = mux output y
         LED1 = sanity mirror of the selected data bit (should always equal LED0)
Expected: LED0 always equals whichever of SW4-SW7 is currently selected by SW8/SW9.
```

### full_adder_demo_top (`board_demo/full_adder_demo`)
```
Inputs:  SW0 = a, SW1 = b, SW2 = cin
Outputs: LED0 = sum, LED1 = cout
Expected: LED[1:0] = binary value of (SW0 + SW1 + SW2), e.g. all three switches up -> LED1=1 LED0=1 (sum=3 -> 11)
```

### counter_demo_top (`board_demo/counter_demo`)
```
Inputs:  BTN0 = reset (hold to clear to 0000)
         SW0  = direction (1=count up, 0=count down)
Outputs: LED3..LED0 = 4-bit counter value, auto-incrementing/decrementing at ~2 Hz
Expected: LEDs visibly count in binary every ~0.5s; direction reverses immediately when SW0 flips; BTN0 forces 0000 while held.
```

### register_demo_top (`board_demo/register_demo`)
```
Inputs:  SW3..SW0 = data to load
         BTN1     = load enable (debounced)
         BTN0     = reset
Outputs: LED3..LED0 = stored register value
Expected: LEDs only change when BTN1 is pressed, capturing whatever SW3..SW0 show at that moment; BTN0 clears to 0000.
```

### shift_register_demo_top (`board_demo/shift_register_demo`)
```
Inputs:  SW0  = serial data in
         BTN0 = reset
Outputs: LED3..LED0 = shift register contents, shifting in SW0 at ~2 Hz
Expected: whatever SW0 is set to at each ~0.5s tick becomes the new LED0, older bits walk left toward LED3.
```

### seven_seg_demo_top (`display/seven_segment`)
```
Inputs:  SW3..SW0 = 4-bit hex value (0-F)
Outputs: 7-segment display 0, digit position 0 (rightmost active digit)
Expected: digit shows the hex value 0-9,A-F as SW3..SW0 changes.
```

### traffic_light_demo_top (`fsm/traffic_light`)
```
Inputs:  BTN0 = reset
Outputs: LED2..LED0 = North-South light {R,Y,G}
         LED5..LED3 = East-West light {R,Y,G}
Expected: NS green while EW red, then NS yellow, then EW green while NS red, then EW yellow, repeating every few seconds (driven by an internal ~1Hz tick from clock_divider).
```

## 10. Validation Status

This environment does not have Vivado installed, so the Xilinx-specific steps
(synthesis/implementation/bitstream/timing) were **not** run here — those genuinely
require Vivado and are marked accordingly below. However, everything that a
standard, Vivado-independent Verilog toolchain *can* check was actually executed in
this session (not just "should work" claims) using Icarus Verilog 12.0 (`iverilog`/`vvp`):

- **All 23 base-circuit testbenches were compiled and run for real**, and every one
  printed `TESTBENCH RESULT: PASS` from its own self-checking logic (not asserted by
  me — read directly from the simulator's console output). Two testbenches
  (`clock_divider_tb`, `button_debounce_tb`) initially failed on the first run due to
  testbench sampling-race bugs (reading a registered signal before its nonblocking
  update landed); both were diagnosed, fixed, and re-run to a genuine PASS.
- **All 7 board-demo top modules (the ones with real pin constraints) were elaborated**
  with `iverilog -s <top>` against their full RTL file set, confirming every module
  instantiation, port connection, and signal width is self-consistent — this is the same
  class of check Vivado's `synth_1` elaboration stage performs before synthesis proper.
- **Every XDC's port names were cross-checked against their top module's port list**
  (see the generation log) — no orphaned or missing constraints.

| Check | Status |
|---|---|
| RTL syntax/structure | **PASS — compiled with Icarus Verilog** |
| No inferred latches (every combinational `always @(*)` has a default/full case) | PASS (manual review) |
| No multiple drivers | PASS (manual review) |
| XDC port-name-to-module-port match | **PASS — verified** |
| Pin numbers sourced from official vendor file | PASS |
| Testbenches present for every circuit, self-checking PASS/FAIL | **PASS — 23/23 actually ran and passed (Icarus Verilog)** |
| Board-demo top-level elaboration (port/instance consistency) | **PASS — 7/7 elaborated cleanly (Icarus Verilog)** |
| Xilinx synthesis (Vivado `synth_1`) | **NOT EXECUTED — REQUIRES LOCAL VIVADO** |
| Implementation / timing closure (Vivado `impl_1`) | **NOT EXECUTED — REQUIRES LOCAL VIVADO** |
| Bitstream generation | **NOT EXECUTED — REQUIRES LOCAL VIVADO** |
| Physical board test | **NOT EXECUTED — REQUIRES PHYSICAL BOARD** |

Run `master_build.tcl` in real Vivado to fill in the remaining rows — every script in this
package prints explicit `PASS`/`FAIL` and `DONE`/`ERROR` lines so the results stay
unambiguous there too.

## 11. Known Remaining Issues / Things To Verify On Real Hardware

1. **Pushbutton active level is assumed, not vendor-confirmed** (see §0). If buttons turn
   out to be active-LOW, add a single `~` inversion at each `btn_raw`/`rst` input in the
   affected top modules (`counter_demo_top`, `register_demo_top`, `shift_register_demo_top`,
   `traffic_light_demo_top`) — everything downstream (debounce, FSM, counters) is already
   polarity-agnostic once the input is corrected.
2. **`btn[0]` as reset is a functional/software choice**, not a vendor-defined reset pin —
   documented so nobody mistakes it for board silkscreen labeling.
3. Timing closure, DRC, and bitstream correctness are unverified until run in real Vivado
   (no Vivado install available in this generation environment).
4. 7-segment digit-enable polarity (`D0_AN` active-low) follows the common Xilinx/Digilent
   convention for this display type but was not independently re-derived from a schematic
   in this session — worth a quick single-LED-of-the-display sanity check before relying on
   multi-digit multiplexing designs.
