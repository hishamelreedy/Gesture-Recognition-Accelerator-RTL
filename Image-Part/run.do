project compileall
# vsim -gui -novopt -wlf spf.wlf work.toplevel
vsim -gui -wlf spf.wlf work.toplevel
add wave -position insertpoint sim:/toplevel/*
add wave -position insertpoint sim:/toplevel/maxpool/multData
add wave -position insertpoint sim:/toplevel/maxpool/address
add wave -position insertpoint sim:/toplevel/maxpool/rdCounter
add wave -position insertpoint sim:/toplevel/maxpool/memread
add wave -position insertpoint sim:/toplevel/st1/*
add wave -position insertpoint sim:/toplevel/st1/PE1/o_convolved_data
run {800 us}