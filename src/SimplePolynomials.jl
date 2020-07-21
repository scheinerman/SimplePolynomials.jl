module SimplePolynomials
using Mods

import Base: getindex, (==), show, zero, one, eltype, adjoint
import Base: numerator, denominator, big

import Polynomials: degree, Polynomial, coeffs, roots, derivative, integrate

export SimplePolynomial, degree, coeffs, getx, Polynomial, roots
export derivative, integrate, lead

# IntegerX is any sort of real or Gaussian integer
IntegerX = Union{S,Complex{S},Mod} where S<:Integer

# RationalX is a Rational or Complex Rational based on integers
RationalX = Union{Rational{S},Complex{Rational{S}}} where S<:Integer

# CoefX is the type we allow for coefficients ... all exact

CoefX = Union{IntegerX,RationalX}

struct SimplePolynomial
    data::Vector
    SimplePolynomial(list::Vector{T}) where T<:CoefX = new(_chomp(list))
end

function SimplePolynomial(c...)
    n = length(c)
    T = typeof(sum(c))
    data = zeros(T,n)
    for j=1:n
        data[j] = c[j]
    end

    SimplePolynomial(data)
end


SimplePolynomial() = SimplePolynomial([0])

# equality checking

(==)(p::SimplePolynomial,q::SimplePolynomial) = p.data == q.data
(==)(p::SimplePolynomial,a::T) where T = p == SimplePolynomial(a)
(==)(a::T,p::SimplePolynomial) where T = p == SimplePolynomial(a)


coeffs(p::SimplePolynomial) = copy(p.data)
eltype(p::SimplePolynomial) = eltype(p.data)

"""
`lead(p::SimplePolynomial)` returns the coefficient of the highest
power of `x` in the polynomial `p`. This is nonzero unless `p` is
the zero polynomial.
"""
lead(p::SimplePolynomial) = p.data[end]


# conversion to/from Polynomial type
SimplePolynomial(P::Polynomial) = SimplePolynomial(P.coeffs)
Polynomial(p::SimplePolynomial) = Polynomial(p.data)


"""
`_chomp(list)` creates a new list by removing all trailing zeros
unless that would remove everything, in which case we leave a single zero.
"""
function _chomp(list::Vector{T})::Vector{T} where T<:Number
    if length(list) == 0 || all(list .== 0)
        return T[0]
    end
    k = findlast(list .!= 0)
    return list[1:k]
end


"""
`_chomp!(list)` modifies list by removing all trailing zeros, unless
the list is entirely zeros in which case we leave a single 0.
"""
function _chomp!(list::Vector{T}) where T<:Number
    while length(list)>1
        n = length(list)
        if list[n] != 0
            return
        end
        deleteat!(list,n)
    end
end

"""
`degree(p::SimplePolynomial)` returns the degree of `p`; that is,
the highest exponent with a nonzero coefficient. If `p`
is the zero polynomial, then `-1` is returned.
"""
function degree(p::SimplePolynomial)
    n = length(p.data)
    if n>1 || p.data[1]!=0
        return n-1
    end
    return -1
end

"""
For a `SimplePolynomial`, `p`, use `p[k]` to read the coefficient
of `x^k`. In particular, `p[0]` is the constant term. If `k` is
larger than the degree of the polynomial, `0` is returned.
"""
function getindex(p::SimplePolynomial, k::Int)
    n = length(p.data)
    if k<0
        error("index [$k] must be nonnegative")
    end

    if k>=n
        return 0
    end

    return p.data[k+1]
end

# This implements evaluation
function (p::SimplePolynomial)(x)
    result = 0
    n = degree(p)
    for j=n:-1:0
        result *= x
        result += p[j]
    end
    return result
end


"""
`getx()` is a convenient way to create `SimplePolynomial(0,1)`.
Typical use:
```
x = getx()
p = 2 + x - 3*x^2
```
"""
getx() = SimplePolynomial(0,1)

zero(::Type{SimplePolynomial}) = SimplePolynomial(zero(Int))
one(::Type{SimplePolynomial}) = SimplePolynomial(one(Int))


roots(p::SimplePolynomial) = roots(Polynomial(p))

"""
`derivative(P::SimplePolynomial)` returns the derivative of `P`.
May also be found as `P'`.
"""
function derivative(P::SimplePolynomial)
    if degree(P)<1
        return SimplePolynomial(0)
    end
    data = [k*P[k] for k=1:degree(P)]
    return SimplePolynomial(data)
end
adjoint(P::SimplePolynomial) = derivative(P)


"""
`integrate(P::SimplePolynomial)` returns the integral of `P`
with constant term equal to zero.
"""
function integrate(P::SimplePolynomial)
    if P==0
        return P
    end
    data = [P[k-1]//k for k=1:degree(P)+1]
    prepend!(data,0)
    return SimplePolynomial(data)
end


include("SimpleRationalFunctions.jl")
include("small.jl")
include("show.jl")
include("arithmetic.jl")
include("rat_arith.jl")
include("gcd.jl")

end
