
# Registers are as follows:
# B:C - general purpose register pair
# D:E - general purpose register pair
# F:G - general purpose register pair
# K - carry register
# O - overflow trit
# P - program counter
# Y - comparison register
# Z - check trit register
@regB = 0
@regC = 0
@regD = 0
@regE = 0
@regF = 0
@regG = 0
@regK = 0
@regO = 0
@regP = 0
@regY = 0
@regZ = 0
#=---------------------------------=#
# INSTRUCTIONS are 27 trits long, each op-code is 9 trits.
@inst_set = { #-------------+ 0-ARG INST +-------------#
            "NOP" => 1, # no operation, do nothing
            "RSA" => 2, # reset all registers
            "SBC" => 3, # swap registers B & C
            "SDE" => 4, # swap registers D & E
            "SFG" => 5, # swap registers F & G
#--------------------------+ 1-ARG INST +-----------#
            "TS1" => 6, # test most significant trit (><= 0)
            "TS2" => 7, # test most significant trit -1 (><= 0)
            "TS3" => 8, # test most significant trit -2 (><= 0)
            "TS4" => 9, # test most significant trit -3 (><= 0)
            "TS5" => 10, # test most significant trit -4 (><= 0)
            "TS6" => 11, # test most significant trit -5 (><= 0)
            "TS7" => 12, # test most significant trit -6 (><= 0)
            "TS8" => 13, # test most significant trit -7 (><= 0)
            "TS9" => 14, # test least significant trit (><= 0)
            "JMP" => 15, # jump unconditionally
            "JAL" => 16, # jump and link
            "RST" => 17, # reset register
            "PSH" => 18, # push into the stack
            "POP" => 19, # pop out of the stack
            "SHR" => 20, # shift right by one trit
            "SHL" => 21, # shift left by one trit
            "CRC" => 22, # calculate check trit (via sequential XOR)
#--------------------------+ 2-ARG INST +-----------#
            "PUT" => 23, # store in memory
            "GET" => 24, # load from memory
            "INC" => 25, # increment (add 1)
            "DEC" => 26, # decrement (subtract 1)
            "SET" => 27, # set register value
#--------------------------+ 3-ARG INST +-----------#
            "ADD" => 28, # basic addition
            "ADI" => 29, # add immediate
            "SUB" => 30, # basic subtraction
            "SBI" => 31, # subtract immediate
            "MLT" => 32, # multiply
            "MYI" => 33, # multiply immediate
            "DIV" => 34, # divide
            "DVI" => 35, # divide immediate
            "POW" => 36, # power operator
            "LOG" => 37, # logarithm operator
            "AND" => 38, # logical "AND"
            "ANI" => 39, # logical "AND", immediate
            "ORR" => 40, # logical "OR"
            "ORI" => 41, # logical "OR", immediate
            "NOR" => 42, # logical "NOR"
            "XOR" => 43, # logical "XOR"
            "MOD" => 44, # modulus operator 
            "BEQ" => 45, # branch if equal
            "BNE" => 46, # branch if not equal
            "BLT" => 47, # branch if less than
            "BLE" => 48, # branch if less than or equal
            "BGT" => 49, # branch if greater than
            "BGE" => 50} # branch if greater than or equal


@inst_list = ["SET $B 7", "SET $C 8", "SUB $B $C $D", "SBC", "SUB $B $C $D", "NOP"]

for inst in @inst_list do
    ops = inst.split(" ")
end
        

opADD = Proc.new {|r1, r2, r3| r3 = r1 + r2 }



















