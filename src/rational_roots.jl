export rational_roots 

"""
`_divisors(n)` returns a `Set` of all the positive divisors of the integer `n`.
"""
function _divisors(n::Integer)
    @assert n != 0 "Can't list all the divisors of zero"
    if abs(n) == 1
        return Set(1)
    end
    f = collect(factor(abs(n)))
    powers = tuple([x[2] for x in f]...)
    plist = [x[1] for x in f]
    np = length(plist)
    master_idx = tuple([0:t for t in powers]...)

    return Set(
        prod(plist[k]^idx[k] for k = 1:np) for idx in Iterators.product(master_idx...)
    )
end

"""
`rational_roots(p::SimplePolynomial)` returns a `Multiset` of all rational roots 
of `p`.
"""
function rational_roots(p::SimplePolynomial)::Multiset
    @assert degree(p)>=0 "Polynomial must not be identically zero"
    T = eltype(p)
    if T<:Complex || T<:Mod
        error("Coefficients are not (real) rational numbers; they are $T")
    end
    if T <: Rational
        dlist = denominator.(coeffs(p))
        p *= lcm(dlist)
        p = integerize(p)
    end
    # p = big(p)
    R = Multiset{Rational{BigInt}}()   # this holds all the answers

    while p[0] == 0
        push!(R,0)
        clist = coeffs(p)
        p = SimplePolynomial(clist[2:end])
    end

    a = lead(p)   # leading coefficient
    b = p[0]      # constant term

    A = _divisors(a)
    B1 = _divisors(b)
    B2 = Set(-t for t in B1)
    B = collect(union(B1,B2))   # all possible rational roots are in the list B

    x = getx()

    for a in A 
        for b in B 
            r = b//a
            while p(r) == 0
                push!(R,r)   # add b to the output multiset 
                p = numerator(p // (x-r))
            end 
        end 
    end

    return R

end
