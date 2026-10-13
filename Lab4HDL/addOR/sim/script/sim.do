vdel -all -lib work
vlib work
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/generic_adder.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/counter_top.vhd
vcom -93 -work work ../src/counter_tb.vhd

vsim -voptargs=+acc work.counter_tb

do wave.do

run 3000 ns