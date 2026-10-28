onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0


add wave -noupdate /addOR8bits_tb/uut/reg_a
add wave -noupdate /addOR8bits_tb/uut/reg_b
add wave -noupdate /addOR8bits_tb/uut/sumOR
add wave -noupdate /addOR8bits_tb/uut/diffOR
add wave -noupdate /addOR8bits_tb/uut/sumORdiff
add wave -noupdate /addOR8bits_tb/uut/input_sync
add wave -noupdate /addOR8bits_tb/uut/hex_ones
add wave -noupdate /addOR8bits_tb/uut/hex_tens
add wave -noupdate /addOR8bits_tb/uut/hex_hundreds
add wave -noupdate /addOR8bits_tb/uut/clk
add wave -noupdate /addOR8bits_tb/uut/reset
add wave -noupdate /addOR8bits_tb/uut/button
add wave -noupdate /addOR8bits_tb/uut/load
add wave -noupdate /addOR8bits_tb/uut/sel
add wave -noupdate /addOR8bits_tb/uut/LED


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 271
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {8 ns} {3158 ns}
