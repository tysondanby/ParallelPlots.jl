
function divremainder(a::Int,b::Int)
    c = trunc(a/b)
    return c, a - c*b
end