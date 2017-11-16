
rem recreate a temp folder for all the simulation files

rd /s /q sim
md sim
cd sim

rem compile verilog files for simulation

iverilog -D SIMULATION -s testbench ../../*/*.v

rem run the simulation and finish on $stop

vvp -l a.lst -n a.out

rem show the simulation results in GTKwave

gtkwave dump.vcd

rem return to the parent folder

cd ..
