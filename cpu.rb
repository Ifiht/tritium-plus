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
# K - ARG1
# O - opcode register
# P - program counter
# Y - ARG2
# Z - ARG3
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
reg_num = {"$B" => 0, "$D" => 2, "$F" => 4, "$K" => 6, "$P" => 8, "$Y" => 9, 
           "$C" => 1, "$E" => 3, "$G" => 5, "$O" => 7, "$Z" => 10}
#=-------------------------+ 0-ARG INST +------------=#
opNOP = lambda {|st| return st } # no operation, do nothing
opRSA = lambda {|st|  st["$B"]=trans10to3(0); st["$C"]=trans10to3(0); st["$D"]=trans10to3(0); 
                      st["$E"]=trans10to3(0); st["$F"]=trans10to3(0); st["$G"]=trans10to3(0); 
                      st["$K"]=trans10to3(0); st["$O"]=trans10to3(0); st["$P"]=trans10to3(0); 
                      st["$Y"]=trans10to3(0); st["$Z"]=trans10to3(0); return st } # reset all registers
opSBC = lambda {|st| t = st["$B"]; st["$B"] = st["$C"]; st["$C"] = t; return st } # swap registers B & C
opSDE = lambda {|st| t = st["$B"]; st["$B"] = st["$C"]; st["$C"] = t; return st } # swap registers D & E
opSFG = lambda {|st| t = st["$B"]; st["$B"] = st["$C"]; st["$C"] = t; return st } # swap registers F & G
#=-------------------------+ 1-ARG INST +------------=#
opTS1 = lambda {|st, a| s = st[a]; st["$G"] = s[0].rjust(9, '0'); return st} # test most significant trit (><= 0)
opTS2 = lambda {|st, a| s = st[a]; st["$G"] = s[1].rjust(9, '0'); return st} # test most significant trit +1 (><= 0)
opTS3 = lambda {|st, a| s = st[a]; st["$G"] = s[2].rjust(9, '0'); return st} # test most significant trit +2 (><= 0)
opTS4 = lambda {|st, a| s = st[a]; st["$G"] = s[3].rjust(9, '0'); return st} # test most significant trit +3 (><= 0)
opTS5 = lambda {|st, a| s = st[a]; st["$G"] = s[4].rjust(9, '0'); return st} # test most significant trit +4 (><= 0)
opTS6 = lambda {|st, a| s = st[a]; st["$G"] = s[5].rjust(9, '0'); return st} # test most significant trit +5 (><= 0)
opTS7 = lambda {|st, a| s = st[a]; st["$G"] = s[6].rjust(9, '0'); return st} # test most significant trit +6 (><= 0)
opTS8 = lambda {|st, a| s = st[a]; st["$G"] = s[7].rjust(9, '0'); return st} # test most significant trit +7 (><= 0)
opTS9 = lambda {|st, a| s = st[a]; st["$G"] = s[8].rjust(9, '0'); return st} # test least significant trit (><= 0)
opJMP = lambda {|st, a| st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st } # jump unconditionally
opJAL = lambda {|st, a| st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st } # jump and link
opRST = lambda {|st, a| st[a] = trans10to3(0); return st } # reset register
opPSH = lambda {|st, a| st["DMEM"] = st[a] + st["DMEM"][0..-9]; return st } # push into the stack
opPOP = lambda {|st, a| st[a] = st["DMEM"][0..8]; st["DMEM"] = st["DMEM"][9..] + '000000000'; return st } # pop out of the stack
opSHR = lambda {|st, a| st[a] = '0' + st[a][1..8]; return st } # shift right by one trit
opSHL = lambda {|st, a| st[a] = st[a][0..7] + '0'; return st } # shift left by one trit
opCRC = lambda {|st, a| return st } # calculate check trit (via sequential XOR)
#=-------------------------+ 2-ARG INST +------------=#
opPUT = lambda {|st, a, b| ma = trans3to10(st[a]); st["DMEM"].slice!(ma..(ma+9)); st["DMEM"] = st["DMEM"].insert(ma, st[b]); return st} # store in memory
opGET = lambda {|st, a, b| ma = trans3to10(st[b]); st[a] = st["DMEM"].slice(ma..(ma+9)); return st} # load from memory
opINC = lambda {|st, a, b| st[a] = trans10to3(b.to_i + 1); return st} # increment (add 1)
opDEC = lambda {|st, a, b| st[a] = trans10to3(b.to_i - 1); return st} # decrement (subtract 1)
opSET = lambda {|st, a, b| st[a] = trans10to3(b.to_i); return st} # set register value
#=-------------------------+ 3-ARG INST +------------=#
opADD = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) + trans3to10(st[c])); return st} # basic addition
opADI = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) + st[c].to_i); return st} # add immediate
opSUB = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) - trans3to10(st[c])); return st} # basic subtraction
opSBI = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) - st[c].to_i); return st} # subtract immediate
opMLT = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) * trans3to10(st[c])); return st} # multiply
opMYI = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) * st[c].to_i); return st} # multiply immediate
opDIV = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) / trans3to10(st[c])); return st} # divide
opDVI = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) / st[c].to_i); return st} # divide immediate
opPOW = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) ** trans3to10(st[c])); return st} # power operator
opLOG = lambda {|st, a, b, c| st[a] = trans10to3(Math.log(trans3to10(st[b]),  trans3to10(st[c]))); return st} # logarithm operator
opAND = lambda {|st, a, b, c| st[a] = trn_AND(st[b], st[c]); return st} # logical "AND"
opANI = lambda {|st, a, b, c| st[a] = trn_AND(st[b], trans10to3(c.to_i)); return st} # logical "AND", immediate
opORR = lambda {|st, a, b, c| st[a] = trn_OR(st[b], st[c]); return st} # logical "OR"
opORI = lambda {|st, a, b, c| st[a] = trn_OR(st[b], trans10to3(c.to_i)); return st} # logical "OR", immediate
opNOR = lambda {|st, a, b, c| st[a] = trn_NOR(st[b], st[c]); return st} # logical "NOR"
opXOR = lambda {|st, a, b, c| st[a] = trn_XOR(st[b], st[c]); return st} # logical "XOR"
opMOD = lambda {|st, a, b, c| st[a] = trans10to3(trans3to10(st[b]) % trans3to10(st[c])); return st} # modulus operator 
opBEQ = lambda {|st, a, b, c| if trans3to10(st[b]) == trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if equal
opBNE = lambda {|st, a, b, c| if trans3to10(st[b]) != trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if not equal
opBLT = lambda {|st, a, b, c| if trans3to10(st[b]) < trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if less than
opBLE = lambda {|st, a, b, c| if trans3to10(st[b]) <= trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if less than or equal
opBGT = lambda {|st, a, b, c| if trans3to10(st[b]) > trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if greater than
opBGE = lambda {|st, a, b, c| if trans3to10(st[b]) >= trans3to10(st[c]); st["P"] = trans10to3(trans3to10(st[a]) + trans3to10(st["P"])); return st; else return st end} # branch if greater than or equal

# INSTRUCTIONS are 27 trits long, each op-code is 4 trits.
# R# refers to a general register, while N# refers to an integer value
#| OP-CODE  | 1st REG | 2nd ARG  |  3rd ARG  | Unused
#   0000       000     000000000   000000000   00
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


def interpret(inst, state)
    ops = inst.split(" ")
    meminst = ""
    if $inst_set.key?(ops[0])
        op0 = $inst_set[ops[0]]
#========================================// 0ARG, op0 1-5
        if op0[0] < 6
            if ops.count != 1
                puts "wrong number of arguments to #{ops[0]}"
            else
                state["$O"] = trans10to3(op0[0])
                state = op0[1].call(state)
                meminst = recode_inst([trans3to10(state["$O"]), trans3to10(state["$K"]), trans3to10(state["$Y"]), trans3to10(state["$Z"])])
            end
#========================================// 1ARG, op0 6-22
        elsif op0[0] < 23
            if ops.count != 2
                puts "wrong number of arguments to #{ops[0]}"
            else
                state["$O"] = trans10to3(op0[0])
                state = op0[1].call(state, ops[1])
                meminst = recode_inst([trans3to10(state["$O"]), trans3to10(state["$K"]), trans3to10(state["$Y"]), trans3to10(state["$Z"])])
            end
#========================================// 2ARG, op0 23-27
        elsif op0[0] < 28
            if ops.count != 3
                puts "wrong number of arguments to #{ops[0]}"
            else
                state["$O"] = trans10to3(op0[0])
                state = op0[1].call(state, ops[1], ops[2])
                meminst = recode_inst([trans3to10(state["$O"]), trans3to10(state["$K"]), trans3to10(state["$Y"]), trans3to10(state["$Z"])])
            end
#========================================// 3ARG, op0 28-50
        else
            if ops.count != 4
                puts "wrong number of arguments to #{ops[0]}"
            else
                state["$O"] = trans10to3(op0[0])
                state = op0[1].call(state, ops[1], ops[2], ops[3])
                meminst = recode_inst([trans3to10(state["$O"]), trans3to10(state["$K"]), trans3to10(state["$Y"]), trans3to10(state["$Z"])])
            end
        end
        pc_0 = trans3to10(state["$P"])
        pc_stop = pc_0 + 27
        state["IMEM"].slice!(pc_0..pc_stop)
        state["IMEM"] = state["IMEM"].insert(pc_0, meminst)
        return state
    else
        puts "#{ops[0]} is not a valid instruction!"
    end
end

#interpret(@inst_list)
















