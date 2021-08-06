
# Registers are as follows:
# B:C - general purpose register pair
# D:E - general purpose register pair
# H:L - general purpose register pair
#=---------------------------------=#
# INSTRUCTIONS are 27 trits long, each op-code is 9 trits.
inst_set = { #-------------+ ALU INST +-------------#
            "ADD" => 1, # basic addition
            "ADI" => 2, # add immediate
            "SUB" => 2, # basic subtraction
            "SBI" => 2, # subtract immediate
            "MLT" => 2, # multiply
            "MYI" => 2, # multiply immediate
            "DIV" => 2, # divide
            "DVI" => 2, # divide immediate
            "CCC" => 2, # 
            "AAA" => 2, # 
            "AND" => 2, # logical "AND"
            "ORR" => 2, # logical "OR"
            "NOR" => 2, # logical "NOR"
            "XOR" => 2, # logical "XOR"
#--------------------------+ LOAD/STORE +-----------#
            "SET" => 2, # set register value
            "RST" => 2, # reset register
            "RTA" => 2, # reset all registers
            "BBB" => 2, # 
            "CCC" => 2, #     
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "SBC" => 2, # swap registers B & C
            "SDE" => 2, # swap registers D & E
            "SHL" => 2, # swap registers H & L
#--------------------------+ BRANCH +---------------#
            "BEQ" => 2, # branch if equal
            "BLT" => 2, # branch if less than
            "BLE" => 2, # branch if less than or equal
            "BGT" => 2, # branch if greater than
            "BGE" => 2, # branch if greater than or equal
            "JMP" => 2, # jump unconditionally
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2, # 
            "CCC" => 2, # 
            "AAA" => 2, # 
            "BBB" => 2} # 


inst_list = [1, 2, 3, 4]