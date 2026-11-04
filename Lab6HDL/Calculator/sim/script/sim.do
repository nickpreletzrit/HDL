vdel -all -lib work
vlib work
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/FSM.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/synchronizer_9bit.vhd
vcom -93 -work work ../../src/synchronizer_1bit.vhd
vcom -93 -work work ../../src/addOR8bits_top.vhd
vcom -93 -work work ../../src/generic_addOR.vhd
vcom -93 -work work ../src/addOR8bits_tb.vhd


vsim -voptargs=+acc work.addOR8bits_tb

do wave.do

run 3000 ns