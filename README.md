# AHB-to-APB Bridge

A modular Verilog HDL project exploring an AMBA AHB-to-APB bridge, including AHB-side transfer qualification, address-based APB peripheral selection, and FSM-driven APB control.

## Architecture

The RTL is split into five modules:

- `AHB_master.v` — simulation master that generates single and burst-style read/write stimulus.
- `AHB_slave_interface.v` — qualifies AHB transfers, registers address/data signals, selects one of three APB regions, and returns read data.
- `APB_controller.v` — FSM that sequences the bridge's APB control signals.
- `APB_interface.v` — simple APB-side interface model. Its read data is randomized for simulation and is not a real peripheral memory.
- `bridge_top.v` — integrates the AHB-side interface and APB controller.

## Address decoding

The AHB-side interface qualifies transfers in the address range `0x8000_0000` to `0x8BFF_FFFF` and generates three one-hot peripheral select values:

| Address range | Select |
|---|---|
| `0x8000_0000`–`0x83FF_FFFF` | `pselx = 3'b001` |
| `0x8400_0000`–`0x87FF_FFFF` | `pselx = 3'b010` |
| `0x8800_0000`–`0x8BFF_FFFF` | `pselx = 3'b100` |

## Repository layout

- `rtl/` — synthesizable/design Verilog modules.
- `tb/` — simulation testbenches.
- `synthesis/` — Quartus Prime project settings and selected reports.
- `report/` — project report.

Generated simulator work libraries and Quartus databases are intentionally excluded.

## Tools

- Verilog HDL
- Intel Quartus Prime (project files and synthesis reports)
- ModelSim/QuestaSim-compatible testbench files

## Running

1. Open the relevant Quartus project under `synthesis/` to inspect its device and compilation settings.
2. For simulation, compile the RTL modules together with the corresponding testbench in a Verilog simulator.
3. Inspect APB signals (`pselx`, `penable`, `pwrite`, `paddr`, and `pwdata`) and AHB response/read-data signals.

The testbench and RTL should be checked in your local simulator before relying on results. Some supplied testbenches were empty or had inconsistent port connections in the original archive; only the usable top-level and corrected AHB-side testbench are included here.

## Limitations

This is an educational RTL project, not a protocol-certified IP block. The APB read-data model uses `$random`, and the RTL should undergo further simulation, linting, and protocol review before hardware use.

## License

No license is specified. All rights remain with their respective owners unless a license is added.
