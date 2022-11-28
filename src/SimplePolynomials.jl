module SimplePolynomials
using Mods, Primes, Multisets

import Base: getindex, (==), show, zero, one, eltype, adjoint
import Base: numerator, denominator, big, inv

import Polynomials: degree, Polynomial, coeffs, roots, derivative

export SimplePolynomial, degree, coeffs, getx, Polynomial, roots
export derivative, integral, lead, make_function

# IntegerX is any sort of real or Gaussian integer
IntegerX = Union{S,Complex{S},AbstractMod} where {S<:Integer}

# RationalX is a Rational or Complex Rational based on integers
RationalX = Union{Rational{S},Complex{Rational{S}}} where {S<:Integer}

# CoefX is the type we allow for coefficients ... all exact
CoefX = Union{IntegerX,RationalX}


_enlarge(x::Integer) = big(x)
_enlarge(x::Rational) = big(x)
_enlarge(x::Complex) = big(x)
_enlarge(x::AbstractMod) = x

struct SimplePolynomial
    data::Vector
    func::Function
    function SimplePolynomial(list::Vector{T}) where {T<:CoefX}
        list = _enlarge.(_chomp(list))
        f = x -> @evalpoly(x, list...)
        new(_chomp(list), f)
    end
end

function SimplePolynomial(c...)
    n = length(c)
    T = typeof(sum(c))
    data = zeros(T, n)
    for j = 1:n
        data[j] = c[j]
    end
    SimplePolynomial(data)
end


"""
`make_function(p::SimplePolynomial)` or
`make_function(f::SimpleRationalFunction)`
returns a Julia `Function` that evaluates `p` or `f`.
Of course one can use `p(x)` or `f(x)`, but the function returned
can then be passed to (for example) `plot`.

Please note that `p(x)` [or `f(x)`] is already quite efficient.
"""
make_function(p::SimplePolynomial) = p.func



SimplePolynomial() = SimplePolynomial([0])
SimplePolynomial(p::SimplePolynomial) = SimplePolynomial(p.data)

# equality checking

(==)(p::SimplePolynomial, q::SimplePolynomial) = p.data == q.data
(==)(p::SimplePolynomial, a::T) where {T<:CoefX} = p == SimplePolynomial(a)
(==)(a::T, p::SimplePolynomial) where {T<:CoefX} = p == SimplePolynomial(a)


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
Polynomial(p::SimplePolynomial) = Polynomial(small.(p.data))


"""
`_chomp(list)` creates a new list by removing all trailing zeros
unless that would remove everything, in which case we leave a single zero.
"""
function _chomp(list::Vector{T})::Vector{T} where {T<:Number}
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
function _chomp!(list::Vector{T}) where {T<:Number}
    while length(list) > 1
        n = length(list)
        if list[n] != 0
            return
        end
        deleteat!(list, n)
    end
end

"""
`degree(p::SimplePolynomial)` returns the degree of `p`; that is,
the highest exponent with a nonzero coefficient. If `p`
is the zero polynomial, then `-1` is returned.
"""
function degree(p::SimplePolynomial)
    n = length(p.data)
    if n > 1 || p.data[1] != 0
        return n - 1
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
    if k < 0
        error("index [$k] must be nonnegative")
    end

    if k >= n
        return 0
    end

    return p.data[k+1]
end

# This implements evaluation
function (p::SimplePolynomial)(x)
    try
        return p.func(x)
    catch
    end
    result = 0
    n = degree(p)
    for j = n:-1:0
        result *= x
        result += p[j]
    end
    return result
end


# special case when arg is a matrix
function (p::SimplePolynomial)(x::AbstractMatrix{T}) where {T}
    r, c = size(x)
    if r != c
        error("number of rows $r must equal the number of columns $c")
    end
    S = eltype(p)
    ST = promote_type(S, T)
    id = zeros(ST, r, r)
    for i = 1:r
        id[i, i] = 1
    end
    result = zeros(ST, r, r)
    n = degree(p)
    for j = n:-1:0
        result *= x
        result += p[j] * id
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
Use `getx(T)` for coefficients of type `T`, e.g., `getx(Mod{13})`.
"""
function getx(T = Int)
    return SimplePolynomial(T(0), T(1))
end


zero(::Type{SimplePolynomial}) = SimplePolynomial(zero(Int))
one(::Type{SimplePolynomial}) = SimplePolynomial(one(Int))


roots(p::SimplePolynomial) = roots(Polynomial(p))

"""
`derivative(P::SimplePolynomial)` returns the derivative of `P`.
May also be found as `P'`.
"""
function derivative(P::SimplePolynomial)
    if degree(P) < 1
        return SimplePolynomial(0)
    end
    data = [k * P[k] for k = 1:degree(P)]
    return SimplePolynomial(data)
end
adjoint(P::SimplePolynomial) = derivative(P)


"""
`integral(P::SimplePolynomial)` returns the integral of `P`
with constant term equal to zero.
"""
function integral(P::SimplePolynomial)
    if P == 0
        return P
    end
    data = [P[k-1] // k for k = 1:degree(P)+1]
    prepend!(data, 0)
    return SimplePolynomial(data)
end


include("SimpleRationalFunctions.jl")
include("show.jl")
include("arithmetic.jl")
include("rat_arith.jl")
include("gcd.jl")
include("small.jl")
include("rational_roots.jl")
include("newton.jl")
include("bin_extend.jl")
end
