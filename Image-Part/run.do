project compileall
vsim -gui -novopt -wlf spf.wlf work.toplevel
# vsim -gui -wlf spf.wlf work.toplevel
add wave -position insertpoint sim:/toplevel/*
add wave -position insertpoint sim:/toplevel/sqst/currentRdChBuffer
add wave -position insertpoint sim:/toplevel/sqst/rdCounter
add wave -position insertpoint sim:/toplevel/sqst/currentRdLineBuffer
add wave -position insertpoint sim:/toplevel/sqst/*
add wave -position insertpoint sim:/toplevel/sqst/PE1/*
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul1/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul1/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul1/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul2/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul2/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul2/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul3/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul3/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul3/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul4/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul4/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul4/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul5/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul5/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul5/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul6/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul6/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul6/z
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul7/a
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul7/b
add wave -position insertpoint sim:/toplevel/sqst/PE1/mul7/z
run {800 us}