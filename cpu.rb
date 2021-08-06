
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
$reslt = 0 # global var for result passing
#=---------------------------------=#
opNOP = Proc.new { nil } # no operation, do nothing
opRSA = Proc.new { @regB = @regC = @regD = @regE = @regF = @regG = @regK = @regO = @regP = @regY = @regZ = 0 } # reset all registers
opSBC = Proc.new { t = @regB; @regB = @regC; @regC = t } # swap registers B & C
opSDE = Proc.new { t = @regB; @regB = @regC; @regC = t } # swap registers D & E
opSFG = Proc.new { t = @regB; @regB = @regC; @regC = t } # swap registers F & G
opTS1 = Proc.new {|x| x + 1 } # test most significant trit (><= 0)
opTS2 = Proc.new {|x| x + 1 } # test most significant trit -1 (><= 0)
opTS3 = Proc.new {|x| x + 1 } # test most significant trit -2 (><= 0)
opTS4 = Proc.new {|x| x + 1 } # test most significant trit -3 (><= 0)
opTS5 = Proc.new {|x| x + 1 } # test most significant trit -4 (><= 0)
opTS6 = Proc.new {|x| x + 1 } # test most significant trit -5 (><= 0)
opTS7 = Proc.new {|x| x + 1 } # test most significant trit -6 (><= 0)
opTS8 = Proc.new {|x| x + 1 } # test most significant trit -7 (><= 0)
opTS9 = Proc.new {|x| x + 1 } # test least significant trit (><= 0)
opJMP = Proc.new {|x| x + 1 } # jump unconditionally
opJAL = Proc.new {|x| x + 1 } # jump and link
opRST = Proc.new {|x| x + 1 } # reset register
opPSH = Proc.new {|x| x + 1 } # push into the stack
opPOP = Proc.new {|x| x + 1 } # pop out of the stack
opSHR = Proc.new {|x| x + 1 } # shift right by one trit
opSHL = Proc.new {|x| x + 1 } # shift left by one trit
opCRC = Proc.new {|x| x + 1 } # calculate check trit (via sequential XOR)
opPUT = Proc.new {|x| x + 1 } # store in memory
opGET = Proc.new {|x| x + 1 } # load from memory
opINC = Proc.new {|x| x + 1 } # increment (add 1)
opDEC = Proc.new {|x| x + 1 } # decrement (subtract 1)
opSET = Proc.new {|i1| $reslt = i1 } # set register value
opADD = Proc.new {|x| x + 1 } # basic addition
opADI = Proc.new {|x| x + 1 } # add immediate
opSUB = Proc.new {|x| x + 1 } # basic subtraction
opSBI = Proc.new {|x| x + 1 } # subtract immediate
opMLT = Proc.new {|x| x + 1 } # multiply
opMYI = Proc.new {|x| x + 1 } # multiply immediate
opDIV = Proc.new {|x| x + 1 } # divide
opDVI = Proc.new {|x| x + 1 } # divide immediate
opPOW = Proc.new {|x| x + 1 } # power operator
opLOG = Proc.new {|x| x + 1 } # logarithm operator
opAND = Proc.new {|x| x + 1 } # logical "AND"
opANI = Proc.new {|x| x + 1 } # logical "AND", immediate
opORR = Proc.new {|x| x + 1 } # logical "OR"
opORI = Proc.new {|x| x + 1 } # logical "OR", immediate
opNOR = Proc.new {|x| x + 1 } # logical "NOR"
opXOR = Proc.new {|x| x + 1 } # logical "XOR"
opMOD = Proc.new {|x| x + 1 } # modulus operator 
opBEQ = Proc.new {|x| x + 1 } # branch if equal
opBNE = Proc.new {|x| x + 1 } # branch if not equal
opBLT = Proc.new {|x| x + 1 } # branch if less than
opBLE = Proc.new {|x| x + 1 } # branch if less than or equal
opBGT = Proc.new {|x| x + 1 } # branch if greater than
opBGE = Proc.new {|x| x + 1 } # branch if greater than or equal

# INSTRUCTIONS are 27 trits long, each op-code is 9 trits.
@inst_set = { #-------------+ 0-ARG INST +-------------#
            "NOP" => [1, opNOP],  # no operation, do nothing
            "RSA" => [2, opRSA],  # reset all registers
            "SBC" => [3, opSBC],  # swap registers B & C
            "SDE" => [4, opSDE],  # swap registers D & E
            "SFG" => [5, opSFG],  # swap registers F & G
#--------------------------+ 1-ARG INST +-----------#
            "TS1" => [6, opTS1],  # test most significant trit (><= 0)
            "TS2" => [7, opTS2],  # test most significant trit -1 (><= 0)
            "TS3" => [8, opTS3],  # test most significant trit -2 (><= 0)
            "TS4" => [9, opTS4],  # test most significant trit -3 (><= 0)
            "TS5" => [10, opTS5], # test most significant trit -4 (><= 0)
            "TS6" => [11, opTS6], # test most significant trit -5 (><= 0)
            "TS7" => [12, opTS7], # test most significant trit -6 (><= 0)
            "TS8" => [13, opTS8], # test most significant trit -7 (><= 0)
            "TS9" => [14, opTS9], # test least significant trit (><= 0)
            "JMP" => [15, opJMP], # jump unconditionally
            "JAL" => [16, opJAL], # jump and link
            "RST" => [17, opRST], # reset register
            "PSH" => [18, opPSH], # push into the stack
            "POP" => [19, opPOP], # pop out of the stack
            "SHR" => [20, opSHR], # shift right by one trit
            "SHL" => [21, opSHL], # shift left by one trit
            "CRC" => [22, opCRC], # calculate check trit (via sequential XOR)
#--------------------------+ 2-ARG INST +-----------#
            "PUT" => [23, opPUT], # store in memory
            "GET" => [24, opGET], # load from memory
            "INC" => [25, opINC], # increment (add 1)
            "DEC" => [26, opDEC], # decrement (subtract 1)
            "SET" => [27, opSET], # set register value
#--------------------------+ 3-ARG INST +-----------#
            "ADD" => [28, opADD], # basic addition
            "ADI" => [29, opADI], # add immediate
            "SUB" => [30, opSUB], # basic subtraction
            "SBI" => [31, opSBI], # subtract immediate
            "MLT" => [32, opMLT], # multiply
            "MYI" => [33, opMYI], # multiply immediate
            "DIV" => [34, opDIV], # divide
            "DVI" => [35, opDVI], # divide immediate
            "POW" => [36, opPOW], # power operator
            "LOG" => [37, opLOG], # logarithm operator
            "AND" => [38, opAND], # logical "AND"
            "ANI" => [39, opANI], # logical "AND", immediate
            "ORR" => [40, opORR], # logical "OR"
            "ORI" => [41, opORI], # logical "OR", immediate
            "NOR" => [42, opNOR], # logical "NOR"
            "XOR" => [43, opXOR], # logical "XOR"
            "MOD" => [44, opMOD], # modulus operator 
            "BEQ" => [45, opBEQ], # branch if equal
            "BNE" => [46, opBNE], # branch if not equal
            "BLT" => [47, opBLT], # branch if less than
            "BLE" => [48, opBLE], # branch if less than or equal
            "BGT" => [49, opBGT], # branch if greater than
            "BGE" => [50, opBGE]} # branch if greater than or equal


@inst_list = ["SET $B 7", "SET $C 8", "SUB $B $C $D", "SBC", "SUB $B $C $D", "NOP"]

for inst in @inst_list do
    ops = inst.split(" ")
    if @inst_set.key?(ops[0])
        op0 = @inst_set[ops[0]]
        if op0[0] < 6      #op0 1-5
            puts 1
        elsif op0[0] < 23  #op0 6-22
            puts 2
        elsif op0[0] < 28  #op0 23-27
            puts 3
        else               #op0 28-50
            puts 4
        end
    else
        puts "#{ops[0]} is not a valid instruction!"
    end
end



















