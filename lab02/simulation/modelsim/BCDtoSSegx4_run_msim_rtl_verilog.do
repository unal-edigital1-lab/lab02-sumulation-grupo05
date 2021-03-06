transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/Github/lab02-sumulation-grupo05/lab02 {G:/Github/lab02-sumulation-grupo05/lab02/BCDtoSSegx4.v}
vlog -vlog01compat -work work +incdir+G:/Github/lab02-sumulation-grupo05/hdl/src/Solucion_display_7segx4 {G:/Github/lab02-sumulation-grupo05/hdl/src/Solucion_display_7segx4/BCDtoSSeg.v}
vlog -vlog01compat -work work +incdir+G:/Github/lab02-sumulation-grupo05/lab02 {G:/Github/lab02-sumulation-grupo05/lab02/Binary2BCD.v}

vlog -vlog01compat -work work +incdir+G:/Github/lab02-sumulation-grupo05/lab02 {G:/Github/lab02-sumulation-grupo05/lab02/BCDtoSSegx4_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  BCDtoSSegx4_TB

add wave *
view structure
view signals
run -all
