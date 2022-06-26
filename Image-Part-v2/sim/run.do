project compileall
vsim -wlf conv1.wlf -novopt -gui work.conv1_tb
add wave -position insertpoint sim:/conv1_tb/*
add wave -position insertpoint sim:/conv1_tb/fifo_conv1/rd_pointer
add wave -position insertpoint sim:/conv1_tb/fifo_conv1/wr_pointer
run -all