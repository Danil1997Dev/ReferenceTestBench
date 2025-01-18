set path [file dirname [file normalize [info script]]]
set NewLoc [string range $path 0 [string last / $path]]
 
set PrjDir [string range $path 0 [string last / $NewLoc]]
set TopName [string range $NewLoc [string last / $NewLoc]+1 end]
puts stdout "Path $path"
puts stdout "NewLoc $NewLoc" 
puts stdout "PrjDir $PrjDir" 
puts stdout "TopName $TopName" 
 

set name tb_alu
#set path Summ

vlib work
 
 vlog "$path/*.sv" 
 vlog "$path/$name.sv" 
 
#-msgmode both -assertdebug
vsim -msgmode both -assertdebug -voptargs=+acc work.$name 
# Set the window types 
view wave do
view structure
view signals
view assertion
#add wave 
add wave -noupdate -divider {all}
add wave -noupdate -unsigned sim:/$name/*
add wave -noupdate -binary sim:/$name/cls
add wave -noupdate -divider {dut}
add wave -noupdate -unsigned sim:/$name/dut/* 
add wave -noupdate -divider {chk}
add wave -noupdate -unsigned sim:/$name/chk/*
run -all