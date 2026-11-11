vdel -all -lib work
vlib work

vcom -93 -work work ../../src/components.vhd
vcom -93 -work work ../../src/alu.vhd
vcom -93 -work work ../../src/FSM.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/synchronizer_8bit.vhd
vcom -93 -work work ../../src/synchronizer_2bit.vhd
vcom -93 -work work ../../src/synchronizer_1bit.vhd
vcom -93 -work work ../../src/falling_edge_detector.vhd
vcom -93 -work work ../../src/Calculator_top.vhd
vcom -93 -work work ../src/Calculator_tb.vhd


vsim -voptargs=+acc work.Calculator_tb

do wave.do

run 3000 ns