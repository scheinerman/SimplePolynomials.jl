export newton_solve, newton_roots

function newton_function(p::SimplePolynomial)::SimpleRationalFunction
    x = getx()
    d = gcd(p, p')
    pp = numerator(p / d)
    return x - pp / pp'
end


"""
`newton_solve(p::SimplePolynomial, x0::Number, nits::Integer)`
finds a root of the polynomial `p` by running `nits` iterations 
of Newton's method starting at `x0`.
"""
function newton_solve(p::SimplePolynomial, x0::Number, nits::Integer = 10)::Number
    newt_func = newton_function(p)
    for k = 1:nits
        x0 = newt_func(x0)
    end
    return x0
end

"""
`newton_roots(p::SimplePolynomial, nits::Integer=10)`
uses Newton's method to find all the roots of the polynomial `p`.
This function uses `roots` to provide a starting value for each root 
and then applies Newton's method to achieve much high accuracy.
"""
function newton_roots(p, nits::Integer = 10)
    rlist = roots(p)
    return [newton_solve(p, x, nits) for x in rlist]
end
