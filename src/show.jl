# How to print SimplePolynomials? We take advantage of the
# excellent printing available in the Polynomials module!

import Base: string, show
export integerize

# The all_ones_denom function checks if all the coefficients
# are (Gaussian) integers, but perhaps of Rational type.

function all_ones_denom(list::Vector{T})::Bool where T <: IntegerX
    return true
end
#
# function all_ones_denom(list::Vector{Complex{T}})::Bool where T <: Integer
#     return true
# end

function all_ones_denom(list::Vector{T})::Bool where T<:Real
    return all(denominator.(list) .== 1)
end

function all_ones_denom(list::Vector{T})::Bool where T<:Complex
    return all_ones_denom(real.(list)) && all_ones_denom(imag.(list))
end

function all_ones_denom(p::SimplePolynomial)::Bool
    return all_ones_denom(p.data)
end

function _top(x::T) where T<:Union{Rational,Integer}
    return numerator(x)
end

function _top(x::T) where T<:Complex
    return numerator(real(x)) + numerator(imag(x))*im
end

_top(x::Mod) = x

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
    str = string(Polynomial(integerize(p)))

    skip = length("Polynomial(")+1

    str = str[skip:end-1]
    return str
end


function show(io::IO, p::SimplePolynomial)
    print(io,string(p))
end
