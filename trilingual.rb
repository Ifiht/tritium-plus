# big-endian
# word = 00000000+ = 6561, 100000000 = 1
# memory = 100000000-+0000000, 2 words, 1 then 2
# all trilobytes & words are read left -> right
def fwdval(c)
    d = {"0" => 0, "+" => 1, "-" => -1}
    if d.key?(c)
        return d[c]
    else
        return nil
    end
end

def revval(c)
    d = {0 => "0", 1 => "+", -1 => "-"}
    if d.key?(c)
        return d[c]
    else
        return nil
    end
end

def trans10to3(n)
    if n > 6561 || n < -6561
        puts "number exceeds trilobyte integer range (-6561 to 6561)"
        return ""
    else
        numstr = ""
        tmpstr = ""
        i = 0
        while n != 0
            tmpstr = n % 3
            if tmpstr == 2
                tmpstr = -1
                n = n + 3
            elsif tmpstr == 3
                tmpstr = 0
                n = n + 3
            end
            n = n / 3
            numstr[i] = revval(tmpstr)
            i = i + 1
        end
        if numstr.length < 9
            i = 9 - numstr.length
            while i > 0
                numstr << "0"
                i = i - 1
            end
        end
        return numstr
    end
end

def trans3to10(s)
    if s.length != 9
        puts "received trilobyte does not have 9 trits"
        return 9999
    else
        retnum = 0
        i = 8
        while i >= 0
            pos = 3**i
            val = fwdval(s[i])
            retnum = (pos * val) + retnum
            i = i - 1
        end
        return retnum
    end
end
#| OP-CODE  | 1st REG | 2nd ARG  |  3rd ARG  | Unused/CRC
#   00000      0000    000000000   000000000     
def decode_inst(s)
    s = s.reverse
    arg1 = s.slice!(0..4).rjust(4, '0')
    arg2 = s.slice!(0..3).rjust(5, '0')
    arg3 = s.slice!(0..8)
    arg4 = s.slice!(0..8)
    n1 = trans3to10(arg1)
    n2 = trans3to10(arg2)
    n3 = trans3to10(arg3)
    n4 = trans3to10(arg4)
    return [n1, n2, n3, n4]
end

def recode_inst(a)
    s1 = trans10to3(a[0]).slice!(0..3)
    s2 = trans10to3(a[1]).slice!(0..3)
    s3 = trans10to3(a[2])
    s4 = trans10to3(a[3])
    str = s1 + s2 + s3 + s4
    strf = str.rjust(1, '0')
    return strf.reverse
end