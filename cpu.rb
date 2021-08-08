require './trilingual.rb'

class Register
    attr_accessor :vlu
    def initialize(vlu)
        @vlu = vlu
    end
end
# Registers are as follows:
# B:C - general purpose register pair
# D:E - general purpose register pair
# F:G - general purpose register pair
# K - carry register
# O - overflow trit
# P - program counter
# Y - comparison register
# Z - check trit register
$regB = Register.new(0)
$regC = Register.new(0)
$regD = Register.new(0)
$regE = Register.new(0)
$regF = Register.new(0)
$regG = Register.new(0)
$regK = Register.new(0)
$regO = Register.new(0)
$regP = Register.new(0)
$regY = Register.new(0)
$regZ = Register.new(0)
reg_list = {"$B" => $regB, "$D" => $regD, "$F" => $regF, "$K" => $regK, "$P" => $regP, "$Y" => $regY, 
            "$C" => $regC, "$E" => $regE, "$G" => $regG, "$O" => $regO, "$Z" => $regZ}
#=-------------------------+ 0-ARG INST +------------=#
opNOP = Proc.new { nil } # no operation, do nothing
opRSA = Proc.new { $regB.vlu=0;
 $regC.vlu=0;
  $regD.vlu=0;
   $regE.vlu=0;
    $regF.vlu=0;
     $regG.vlu=0;
      $regK.vlu=0;
       $regO.vlu=0;
        $regP.vlu=0;
         $regY.vlu=0;
          $regZ.vlu=0} # reset all registers
opSBC = Proc.new { t = $regB.vlu; $regB.vlu = $regC.vlu; $regC.vlu = t } # swap registers B & C
opSDE = Proc.new { t = $regD.vlu; $regD.vlu = $regE.vlu; $regE.vlu = t } # swap registers D & E
opSFG = Proc.new { t = $regF.vlu; $regF.vlu = $regG.vlu; $regG.vlu = t } # swap registers F & G
#=-------------------------+ 1-ARG INST +------------=#
opTS1 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[0])} # test most significant trit (><= 0)
opTS2 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[1])} # test most significant trit +1 (><= 0)
opTS3 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[2])} # test most significant trit +2 (><= 0)
opTS4 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[3])} # test most significant trit +3 (><= 0)
opTS5 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[4])} # test most significant trit +4 (><= 0)
opTS6 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[5])} # test most significant trit +5 (><= 0)
opTS7 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[6])} # test most significant trit +6 (><= 0)
opTS8 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[7])} # test most significant trit +7 (><= 0)
opTS9 = Proc.new {|a| s = trans10to3(a); $regY.vlu = trans3to10(s[8])} # test least significant trit (><= 0)
opJMP = Proc.new { 1 + 1 } # jump unconditionally
opJAL = Proc.new { 1 + 1 } # jump and link
opRST = Proc.new { 1 + 1 } # reset register
opPSH = Proc.new { 1 + 1 } # push into the stack
opPOP = Proc.new { 1 + 1 } # pop out of the stack
opSHR = Proc.new { 1 + 1 } # shift right by one trit
opSHL = Proc.new { 1 + 1 } # shift left by one trit
opCRC = Proc.new { 1 + 1 } # calculate check trit (via sequential XOR)
#=-------------------------+ 2-ARG INST +------------=#
opPUT = Proc.new { 1 + 1 } # store in memory
opGET = Proc.new { 1 + 1 } # load from memory
opINC = Proc.new { 1 + 1 } # increment (add 1)
opDEC = Proc.new { 1 + 1 } # decrement (subtract 1)
opSET = Proc.new {|a, b| reg_list[a].vlu = b} # set register value
#=-------------------------+ 3-ARG INST +------------=#
opADD = Proc.new { 1 + 1 } # basic addition
opADI = Proc.new { 1 + 1 } # add immediate
opSUB = Proc.new { 1 + 1 } # basic subtraction
opSBI = Proc.new { 1 + 1 } # subtract immediate
opMLT = Proc.new { 1 + 1 } # multiply
opMYI = Proc.new { 1 + 1 } # multiply immediate
opDIV = Proc.new { 1 + 1 } # divide
opDVI = Proc.new { 1 + 1 } # divide immediate
opPOW = Proc.new { 1 + 1 } # power operator
opLOG = Proc.new { 1 + 1 } # logarithm operator
opAND = Proc.new { 1 + 1 } # logical "AND"
opANI = Proc.new { 1 + 1 } # logical "AND", immediate
opORR = Proc.new { 1 + 1 } # logical "OR"
opORI = Proc.new { 1 + 1 } # logical "OR", immediate
opNOR = Proc.new { 1 + 1 } # logical "NOR"
opXOR = Proc.new { 1 + 1 } # logical "XOR"
opMOD = Proc.new { 1 + 1 } # modulus operator 
opBEQ = Proc.new { 1 + 1 } # branch if equal
opBNE = Proc.new { 1 + 1 } # branch if not equal
opBLT = Proc.new { 1 + 1 } # branch if less than
opBLE = Proc.new { 1 + 1 } # branch if less than or equal
opBGT = Proc.new { 1 + 1 } # branch if greater than
opBGE = Proc.new { 1 + 1 } # branch if greater than or equal

# INSTRUCTIONS are 27 trits long, each op-code is 9 trits.
# R# refers to a general register, while N# refers to an integer value
$inst_set = { #-------------+ 0-ARG INST +-------------#
            "NOP" => [1, opNOP],  #FMT: "OP" no operation, do nothing
            "RSA" => [2, opRSA],  #FMT: "OP" reset all registers
            "SBC" => [3, opSBC],  #FMT: "OP" swap registers B & C
            "SDE" => [4, opSDE],  #FMT: "OP" swap registers D & E
            "SFG" => [5, opSFG],  #FMT: "OP" swap registers F & G
#--------------------------+ 1-ARG INST +-----------#
            "TS1" => [6, opTS1],  #FMT: "OP R1" test most significant trit (><= 0)
            "TS2" => [7, opTS2],  #FMT: "OP R1" test most significant trit -1 (><= 0)
            "TS3" => [8, opTS3],  #FMT: "OP R1" test most significant trit -2 (><= 0)
            "TS4" => [9, opTS4],  #FMT: "OP R1" test most significant trit -3 (><= 0)
            "TS5" => [10, opTS5], #FMT: "OP R1" test most significant trit -4 (><= 0)
            "TS6" => [11, opTS6], #FMT: "OP R1" test most significant trit -5 (><= 0)
            "TS7" => [12, opTS7], #FMT: "OP R1" test most significant trit -6 (><= 0)
            "TS8" => [13, opTS8], #FMT: "OP R1" test most significant trit -7 (><= 0)
            "TS9" => [14, opTS9], #FMT: "OP R1" test least significant trit (><= 0)
            "JMP" => [15, opJMP], #FMT: "OP R1" jump unconditionally to address in R1
            "JAL" => [16, opJAL], #FMT: "OP R1" jump and link to address in R1
            "RST" => [17, opRST], #FMT: "OP R1" reset register R1
            "PSH" => [18, opPSH], #FMT: "OP R1" push R1 into the stack
            "POP" => [19, opPOP], #FMT: "OP R1" pop out of the stack into R1
            "SHR" => [20, opSHR], #FMT: "OP R1" shift R1 right by one trit
            "SHL" => [21, opSHL], #FMT: "OP R1" shift R1 left by one trit
            "CRC" => [22, opCRC], #FMT: "OP R1" calculate check trit (via sequential XOR) on R1
#--------------------------+ 2-ARG INST +-----------#
            "PUT" => [23, opPUT], #FMT: "OP R1 R2" store R2 in memory address of R1
            "GET" => [24, opGET], #FMT: "OP R1 R2" load R2 memory address into R1
            "INC" => [25, opINC], #FMT: "OP R1 R2" increment (add 1) R2, store in R1
            "DEC" => [26, opDEC], #FMT: "OP R1 R2" decrement (subtract 1) R2, store in R1
            "SET" => [27, opSET], #FMT: "OP R1 N1" set register value R1 equal to N1 (integer)
#--------------------------+ 3-ARG INST +-----------#
            "ADD" => [28, opADD], #FMT: "OP R1 R2 R3"  basic addition, R1 = R2 + R3
            "ADI" => [29, opADI], #FMT: "OP R1 R2 N1"  add immediate, R1 = R2 + N1
            "SUB" => [30, opSUB], #FMT: "OP R1 R2 R3"  basic subtraction, R1 = R2 - R3
            "SBI" => [31, opSBI], #FMT: "OP R1 R2 N1"  subtract immediate, R1 = R2 - N1
            "MLT" => [32, opMLT], #FMT: "OP R1 R2 R3"  multiply, R1 = R2 * R3
            "MYI" => [33, opMYI], #FMT: "OP R1 R2 N1"  multiply immediate, R1 = R2 * N1
            "DIV" => [34, opDIV], #FMT: "OP R1 R2 R3"  divide, R1 = R2 / R3
            "DVI" => [35, opDVI], #FMT: "OP R1 R2 N1"  divide immediate, R1 = R2 / N1
            "POW" => [36, opPOW], #FMT: "OP R1 R2 R3"  power operator, R1 = R2^R3
            "LOG" => [37, opLOG], #FMT: "OP R1 R2 R3"  logarithm operator, R1 = logR2 (R3)
            "AND" => [38, opAND], #FMT: "OP R1 R2 R3"  logical "AND", R1 = R2 AND R3
            "ANI" => [39, opANI], #FMT: "OP R1 R2 N1"  logical "AND", immediate, R1 = R2 AND N1
            "ORR" => [40, opORR], #FMT: "OP R1 R2 R3"  logical "OR", R1 = R2 OR R3
            "ORI" => [41, opORI], #FMT: "OP R1 R2 N1"  logical "OR", immediate, R1 = R2 OR N1
            "NOR" => [42, opNOR], #FMT: "OP R1 R2 R3"  logical "NOR", R1 = R2 NOR R3
            "XOR" => [43, opXOR], #FMT: "OP R1 R2 R3"  logical "XOR", R1 = R2 XOR R3
            "MOD" => [44, opMOD], #FMT: "OP R1 R2 R3"  modulus operator , R1 = R2 % R3
            "BEQ" => [45, opBEQ], #FMT: "OP R1 R2 R3"  branch to R1 if R2 equal R3
            "BNE" => [46, opBNE], #FMT: "OP R1 R2 R3"  branch to R1 if R2 not equal R3
            "BLT" => [47, opBLT], #FMT: "OP R1 R2 R3"  branch to R1 if R2 less than R3
            "BLE" => [48, opBLE], #FMT: "OP R1 R2 R3"  branch to R1 if R2 less than or equal R3
            "BGT" => [49, opBGT], #FMT: "OP R1 R2 R3"  branch to R1 if R2 greater than R3
            "BGE" => [50, opBGE]} #FMT: "OP R1 R2 R3"  branch to R1 if R2 greater than or equal R3


@inst_list = ["SET $B 7", "SET $C 8", "SUB $B $C $D", "SBC", "SUB $B $C $D", "NOP"]

def interpret(list)
    for inst in list do
        ops = inst.split(" ")
        if $inst_set.key?(ops[0])
            op0 = $inst_set[ops[0]]
#========================================// 0ARG, op0 1-5
            if op0[0] < 6      
                op0[1].call
#========================================// 1ARG, op0 6-22
            elsif op0[0] < 23
                op0[1].call(ops[1])
#========================================// 2ARG, op0 23-27
            elsif op0[0] < 28
                op0[1].call(ops[1], ops[2])
#========================================// 3ARG, op0 28-50
            else
                op0[1].call(ops[1], ops[2], ops[3])
            end
        else
            puts "#{ops[0]} is not a valid instruction!"
        end
    end
end

#interpret(@inst_list)
















