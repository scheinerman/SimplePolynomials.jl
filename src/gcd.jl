import Base: gcd, lcm


function gcd(a::SimplePolynomial, b::SimplePolynomial)
    #try
    d = integerize(_gcd(a, b))
    return d
    # catch
    #     aa = big(a)
    #     bb = big(b)
    #     dd = _gcd(aa,bb)
    #     d = integerize(dd)
    #     return d
    # end
end

function _gcd(a::SimplePolynomial, b::SimplePolynomial)

    if a == 0 && b == 0
        error("The two arguments cannot both be zero")
    end

    if a == 0
        return b
    end

    if b == 0
        return a
    end

    q, r = divrem(a, b)
    return monic(_gcd(b, monic(r)))
end


function lcm(a::SimplePolynomial, b::SimplePolynomial)
    q, r = divrem(a * b, gcd(a, b))
    return monic(q)
end
