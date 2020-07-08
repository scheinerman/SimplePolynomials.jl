module SimplePolynomials

import Base: getindex, (==), show
import Polynomials: degree, Polynomial

export SimplePolynomial, degree

# IntegerX is any sort of real or Gaussian integer
IntegerX = Union{S,Complex{S}} where S<:Integer

# RationalX is a Rational or Complex Rational based on integers
RationalX = Union{Rational{S},Complex{Rational{S}}} where S<:Integer

# CoefX is the type we allow for coefficients ... all exact

CoefX = Union{IntegerX,RationalX}

struct SimplePolynomial{T<:CoefX}
    data::Array{T,1}
    SimplePolynomial(list::Vector{T}) where T = new{T}(_chomp(list))
end

SimplePolynomial(c...) = SimplePolynomial(collect(c))
SimplePolynomial() = SimplePolynomial(0)

# equality checking

(==)(p::SimplePolynomial,q::SimplePolynomial) = p.data == q.data
(==)(p::SimplePolynomial,a::T) where T = p == SimplePolynomial(a)
(==)(a::T,p::SimplePolynomial) where T = p == SimplePolynomial(a)



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
function getindex(p::SimplePolynomial{T}, k::Int) where T
    n = length(p.data)
    if k<0
        error("index [$k] must be nonnegative")
    end

    if k>=n
        return zero(T)
    end

    return p.data[k+1]
end

# This implements evaluation
function (p::SimplePolynomial)(x::T) where T<:Number
    result = zero(T)
    n = deg(p)
    for j=n:-1:0
        result *= x
        result += p[j]
    end
    return result
end

# This is a placeholder `show`. We can better!
function show(io::IO, p::SimplePolynomial{T}) where T
    print(io,"SimplePolynomial(",p.data,")")
end


include("arithmetic.jl")
include("gcd.jl")

end
