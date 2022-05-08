project compileall
vsim -gui -novopt -wlf spf.wlf work.conv1_verify
add wave -position insertpoint sim:/conv1_verify/*
# add wave -position insertpoint sim:/conv1_verify/mul1/*
run {300 ms}