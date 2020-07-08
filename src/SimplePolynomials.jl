module SimplePolynomials

import Base: getindex

export SimplePolynomial, deg

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


function _chomp(list::Vector{T})::Vector{T} where T<:Number
    if length(list) == 0 || all(list .== 0)
        return T[0]
    end
    k = findlast(list .!= 0)
    return list[1:k]
end

function deg(p::SimplePolynomial)
    n = length(p.data)
    if n>1 || p.data[1]!=0
        return n-1
    end
    return -1
end

function getindex(p::SimplePolynomial, k::Int)
    n = length(p.data)
    if k<0 || k>=n
        BoundsError(p,k)
    end
    return p.data[k+1]
end

end
