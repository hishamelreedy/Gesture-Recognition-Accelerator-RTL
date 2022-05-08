project compileall
vsim -gui -novopt -wlf spf.wlf work.conv2d3x3
add wave -position insertpoint sim:/conv2d3x3/*
add wave -position insertpoint sim:/conv2d3x3/mul1/a
add wave -position insertpoint sim:/conv2d3x3/mul1/b
add wave -position insertpoint sim:/conv2d3x3/mul1/z

add wave -position insertpoint sim:/conv2d3x3/mul2/a
add wave -position insertpoint sim:/conv2d3x3/mul2/b
add wave -position insertpoint sim:/conv2d3x3/mul2/z

add wave -position insertpoint sim:/conv2d3x3/mul3/a
add wave -position insertpoint sim:/conv2d3x3/mul3/b
add wave -position insertpoint sim:/conv2d3x3/mul3/z

add wave -position insertpoint sim:/conv2d3x3/mul4/a
add wave -position insertpoint sim:/conv2d3x3/mul4/b
add wave -position insertpoint sim:/conv2d3x3/mul4/z

add wave -position insertpoint sim:/conv2d3x3/mul5/a
add wave -position insertpoint sim:/conv2d3x3/mul5/b
add wave -position insertpoint sim:/conv2d3x3/mul5/z

add wave -position insertpoint sim:/conv2d3x3/mul6/a
add wave -position insertpoint sim:/conv2d3x3/mul6/b
add wave -position insertpoint sim:/conv2d3x3/mul6/z

add wave -position insertpoint sim:/conv2d3x3/mul7/a
add wave -position insertpoint sim:/conv2d3x3/mul7/b
add wave -position insertpoint sim:/conv2d3x3/mul7/z

add wave -position insertpoint sim:/conv2d3x3/mul8/a
add wave -position insertpoint sim:/conv2d3x3/mul8/b
add wave -position insertpoint sim:/conv2d3x3/mul8/z

add wave -position insertpoint sim:/conv2d3x3/mul9/a
add wave -position insertpoint sim:/conv2d3x3/mul9/b
add wave -position insertpoint sim:/conv2d3x3/mul9/z
run {10 ns}