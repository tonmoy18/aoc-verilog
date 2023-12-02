# Advent of Code 2023 in Verilog

Welcome to the Advent of Code 2023 in Verilog project! In this repository, I explore a unique approach to solving Advent of Code puzzles using Verilog, a hardware description language commonly used for designing digital circuits.

## Introduction

The holiday season brings the joy of coding challenges through Advent of Code. This year, I've taken on the challenge of not only solving puzzles but approaching them from a hardware design perspective. Each puzzle is tackled using Verilog modules that mimic the essence of the problems, offering a blend of software adventuring and digital hardware design.


## Prerequisites

To simulate and run the Verilog code in this project, you need to have [Verilator](https://www.veripool.org/wiki/verilator) installed. Verilator is a cycle-accurate Verilog to C++ transpiler and simulator. Make sure the `VERILATOR_ROOT` env variable to set and points to the installation directory such that the executable is  `VERILATOR_ROOT`/bin/verilator

## Project Structure

The repository is organized as follows:

- **solutions**: Contains SystemVerilog source files for the synthesizable, lint-clean solution modules written as sol.sv file as well as some trial and input txt inputs
- **tb**: Holds the Verilog testbench code responsible for validating the Verilog design modules.
- **vsim**: Folder containing the verilator Makefiles and the top level cpp file for runnign the testbench using verilator

## Getting Started

1. Install [Verilator](https://www.veripool.org/wiki/verilator)

2. Clone the repository:

   ```bash
   git clone https://github.com/your-username/advent-of-code-verilog.git
   cd advent-of-code-verilog
   ```

3. Run the Day 2 Part 2 solution using trial.txt or input.txt

   ```bash
   cd vsim
   make SOL_DAY=day_2p2 FNAME_BASE=trial.txt
   make SOL_DAY=day_2p2 FNAME_BASE=input.txt
   ```

4. Explore the verilog designs in `solutions/day_*/sol.sv` files


## Contributing
Feel free to contribute by submitting pull requests, reporting issues, or suggesting improvements. Your insights and enhancements are highly appreciated.

## License

This project is licensed under the [MIT License](LICENSE).