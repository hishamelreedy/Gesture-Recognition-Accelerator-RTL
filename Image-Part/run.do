project compileall
vsim -gui -novopt -wlf spf.wlf work.toplevel
# vsim -gui -wlf spf.wlf work.toplevel
add wave -position insertpoint sim:/toplevel/*
add wave -position insertpoint sim:/toplevel/sqst/currentRdChBuffer
add wave -position insertpoint sim:/toplevel/sqst/rdCounter
add wave -position insertpoint sim:/toplevel/sqst/currentRdLineBuffer
run {800 us}