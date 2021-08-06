# big-endian
# word = 00000000+ = 6561, 100000000 = 1
# memory = 100000000-+0000000, 2 words, 1 then 2
# all trilobytes & words are read right -> left
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