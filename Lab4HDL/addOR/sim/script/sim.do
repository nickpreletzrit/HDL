vdel -all -lib work
vlib work
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/synchronizer_3bit.vhd
vcom -93 -work work ../../src/synchronizer_1bit.vhd
vcom -93 -work work ../../src/falling_edge_detector.vhd
vcom -93 -work work ../../src/addOR_top.vhd
vcom -93 -work work ../../src/generic_addOR.vhd
vcom -93 -work work ../src/addOR_tb.vhd


vsim -voptargs=+acc work.addOR_tb

do wave.do

run 3000 ns