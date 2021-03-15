# How to print SimplePolynomials? We take advantage of the
# excellent printing available in the Polynomials module!

import Base: string, show
export integerize

# The all_ones_denom function checks if all the coefficients
# are (Gaussian) integers, but perhaps of Rational type.

function all_ones_denom(list::Vector{T})::Bool where {T<:IntegerX}
    return true
end
#
# function all_ones_denom(list::Vector{Complex{T}})::Bool where T <: Integer
#     return true
# end

function all_ones_denom(list::Vector{T})::Bool where {T<:Real}
    return all(denominator.(list) .== 1)
end

function all_ones_denom(list::Vector{T})::Bool where {T<:Complex}
    return all_ones_denom(real.(list)) && all_ones_denom(imag.(list))
end

function all_ones_denom(p::SimplePolynomial)::Bool
    return all_ones_denom(p.data)
end

function _top(x::T) where {T<:Union{Rational,Integer}}
    return numerator(x)
end

function _top(x::T) where {T<:Complex}
    return numerator(real(x)) + numerator(imag(x)) * im
end

_top(x::AbstractMod) = x

"""
`integerize(p::SimplePolynomial)` is useful when `p`
has `Rational` coefficients all of whose denominators are `1`.
In that case, `integerize(p)` returns a polynomial equal to the
original, but with coefficients that are integers (or Gaussian integers).
However, if any denominators are not `1`, the original polynomial
is returned.
"""
function integerize(p::SimplePolynomial)
    if all_ones_denom(p)
        return SimplePolynomial(_top.(p.data))
    end
    return p
end

"""
`string(p::SimplePolynomial)` returns a nice `String` representation
of `p`.
"""
function string(p::SimplePolynomial)
    return string(Polynomial(integerize(p)))
end


function show(io::IO, p::SimplePolynomial)
    print(io, string(p))
end






export string3


function pstring(p::SimplePolynomial)
    nterms = count((x) -> (x != 0), p.data)
    if nterms <= 1
        return string(p)
    end
    return "(" * string(p) * ")"
end


function string(f::SimpleRationalFunction)
    return pstring(f.num) * " / " * pstring(f.den)
end





function show(io::IO, f::SimpleRationalFunction)
    print(io, string(f))
end


function string3(f::SimpleRationalFunction)
    top = string(numerator(f))
    bot = string(denominator(f))

    n1 = length(top)
    n2 = length(bot)
    n = max(n1, n2)

    pad1 = 0
    pad2 = 0

    if n1 < n
        pad1 = div(n - n1, 2)
    else
        pad2 = div(n - n2, 2)
    end

    line1 = " "^pad1 * top
    line2 = "-"^n
    line3 = " "^pad2 * bot
    NL = "\n"

    return line1 * NL * line2 * NL * line3
end
