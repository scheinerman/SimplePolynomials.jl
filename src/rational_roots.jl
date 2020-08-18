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
`rational_roots(p::SimplePolynomial)` returns a set of all rational roots 
of `p`.
"""
function rational_roots(p::SimplePolynomial)
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
    R1 = Set{Rational{BigInt}}()

    if p[0] == 0
        push!(R1,0)
        clist = coeffs(p)
        j = findfirst(clist .!= 0)
        clist = clist[j:end]
        p = SimplePolynomial(clist)
    end

    a = lead(p)   # leading coefficient
    b = p[0]      # constant term

    A = _divisors(a)
    B1 = _divisors(b)
    B2 = Set(-t for t in B1)
    B = union(B1,B2)


    R2 = Set(y//x for y in B for x in A if p(y//x)==0)
    return union(R1,R2)

end
