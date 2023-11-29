import Base: binomial

"""
    binomial(p, k::Integer)
 
where `p` is a `SimplePolynomial` or a `SimpleRationalFunction` returns the 
binomial coefficient.

# Example
```
julia> x = getx()
x

julia> binomial(x,3)
1//3*x - 1//2*x^2 + 1//6*x^3

julia> p = binomial(x,3)
1//3*x - 1//2*x^2 + 1//6*x^3

julia> p(10)
120//1

julia> binomial(10,3)
120
```
"""
function binomial(
    p::T,
    k::Integer,
) where {T<:Union{SimplePolynomial,SimpleRationalFunction}}
    if k < 0
        return zero(T)
    end

    if k == 0
        return one(T)
    end

    return prod(p - j for j = 0:k-1) // factorial(k)

end
