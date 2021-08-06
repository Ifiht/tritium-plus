
# Registers are as follows:
# B:C - general purpose register pair
# D:E - general purpose register pair
# H:L - general purpose register pair
# K - carry register
# Z - check trit register
# P - program counter
#=---------------------------------=#
# INSTRUCTIONS are 27 trits long, each op-code is 9 trits.
inst_set = { #-------------+ ALU INST +-------------#
            "ADD" => 1, # basic addition
            "ADI" => 2, # add immediate
            "INC" => 2, # increment (add 1)
            "INC" => 2, # increment (add 1)
            "SUB" => 2, # basic subtraction
            "SBI" => 2, # subtract immediate
            "DEC" => 2, # decrement (subtract 1)
            "MLT" => 2, # multiply
            "MYI" => 2, # multiply immediate
            "DIV" => 2, # divide
            "DVI" => 2, # divide immediate
            "POW" => 2, # power operator
            "LOG" => 2, # logarithm operator
            "AND" => 2, # logical "AND"
            "ANI" => 2, # logical "AND", immediate
            "ORR" => 2, # logical "OR"
            "ORI" => 2, # logical "OR", immediate
            "NOR" => 2, # logical "NOR"
            "XOR" => 2, # logical "XOR"
            "SHR" => 2, # shift right by one trit
            "SHL" => 2, # shift left by one trit
            "MOD" => 2, # modulus operator 
            "CRC" => 2, # calculate check trit (via sequential XOR)
            "TS1" => 2, # test most significant trit (><= 0)
            "TS2" => 2, # test most significant trit -1 (><= 0)
            "TS3" => 2, # test most significant trit -2 (><= 0)
            "TS4" => 2, # test most significant trit -3 (><= 0)
            "TS5" => 2, # test most significant trit -4 (><= 0)
            "TS6" => 2, # test most significant trit -5 (><= 0)
            "TS7" => 2, # test most significant trit -6 (><= 0)
            "TS8" => 2, # test most significant trit -7 (><= 0)
            "TS9" => 2, # test least significant trit (><= 0)
            "NOP" => 2, # no operation, do nothing
#--------------------------+ LOAD/STORE +-----------#
            "SET" => 2, # set register value
            "RST" => 2, # reset register
            "RSA" => 2, # reset all registers
            "PUT" => 2, # store in memory
            "GET" => 2, # load from memory
            "PSH" => 2, # push into the stack
            "POP" => 2, # pop out of the stack
            "SBC" => 2, # swap registers B & C
            "SDE" => 2, # swap registers D & E
            "SHL" => 2, # swap registers H & L
#--------------------------+ BRANCH +---------------#
            "BEQ" => 2, # branch if equal
            "BNE" => 2, # branch if not equal
            "BLT" => 2, # branch if less than
            "BLE" => 2, # branch if less than or equal
            "BGT" => 2, # branch if greater than
            "BGE" => 2, # branch if greater than or equal
            "JMP" => 2, # jump unconditionally
            "JAL" => 2, # jump and link


inst_list = [1, 2, 3, 4]