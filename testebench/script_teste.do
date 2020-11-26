vcom vga_raster.vhd
vcom vga_raster_resta_dois.vhd
vcom testebench.vhd

vsim testebench


add wave clk
add wave reset
add wave SW_I
add wave SW_F
add wave X_S
add wave Y_S
add wave D0_S
add wave D1_S
add wave D2_S
add wave D3_S




run 20ns    