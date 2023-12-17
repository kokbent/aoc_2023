doc = readline("./puzzle/d15.txt")

sp = split(doc, ",")

function HASH(s)
    val = 0
    for c in s
        val += Int(c)
        val *= 17
        val = val % 256
    end
    return val
end

sum(HASH.(sp))