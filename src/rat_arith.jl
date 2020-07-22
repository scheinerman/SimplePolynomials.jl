
# addition
function (+)(f::SimpleRationalFunction, g::SimpleRationalFunction)
    top = f.num * g.den + f.den * g.num
    bot = f.den * g.den
    return SimpleRationalFunction(top, bot)
end

function (+)(f:# inv(p::SimplePolynomial) = SimpleRationalFunction(1, p)
:SimpleRationalFunction, p::SimplePolynomial)
    return f + SimpleRationalFunction(p)
end
(+)(p::SimplePolynomial, f::SimpleRationalFunction) = f + p

(+)(f::SimpleRationalFunction, a::T) where {T<:CoefX} = f + SimpleRationalFunction(a)
(+)(a::T, f::SimpleRationalFunction) where {T<:CoefX} = f + a


# subtraction
(-)(f::SimpleRationalFunction) = SimpleRationalFunction(-f.num, f.den)

(-)(f::SimpleRationalFunction, g::SimpleRationalFunction) = f + (-g)

(-)(f::SimpleRationalFunction, p::SimplePolynomial) = f + (-p)
(-)(p::SimplePolynomial, f::SimpleRationalFunction) = p + (-f)

(-)(f::SimpleRationalFunction, a::T) where {T<:CoefX} = f + SimpleRationalFunction(-a)
(-)(a::T, f::SimpleRationalFunction) where {T<:CoefX} = SimpleRationalFunction(a) - f

# multiplication
(*)(f::SimpleRationalFunction, g::SimpleRationalFunction) =
    SimpleRationalFunction(f.num * g.num, f.den * g.den)

(*)(f::SimpleRationalFunction, p::SimplePolynomial) = f * SimpleRationalFunction(p)
(*)(p::SimplePolynomial, f::SimpleRationalFunction) = f * p

(*)(f::SimpleRationalFunction, a::T) where {T<:CoefX} = f * SimpleRationalFunction(a)
(*)(a::T, f::SimpleRationalFunction) where {T<:CoefX} = f * a

# division
inv(f::SimpleRationalFunction) = SimpleRationalFunction(f.den, f.num)

function inv(p::SimplePolynomial)
    T = eltype(p)
    SimpleRationalFunction(T(1),p)
end



SimpleThing = Union{SimplePolynomial,SimpleRationalFunction}

(/)(f::S, g::T) where {S<:SimpleThing,T<:SimpleThing} = f * inv(g)
(/)(f::SimpleRationalFunction, a::T) where {T<:CoefX} = f / SimplePolynomial(a)
(/)(a::T, f::S) where {T<:CoefX,S<:SimpleThing} = a * inv(f)



(//)(f::S, g::T) where {S<:SimpleThing,T<:SimpleThing} = f * inv(g)
(//)(f::SimpleRationalFunction, a::T) where {T<:CoefX} = f / SimplePolynomial(a)
(//)(a::T, f::S) where {T<:CoefX,S<:SimpleThing} = a * inv(f)


# exponentiation
function (^)(p::SimpleRationalFunction, k::S) where S<:Integer
    if k == 0
        return SimpleRationalFunction(1)
    end

    if k<0
        return (inv(p))^(-k)
    end

    if k == 1
        return p
    end

    if k == 2
        return p * p
    end

    if k % 2 == 0  # even exponent
        j = k ÷ 2
        q = p^j
        return q * q
    end

    j = k ÷ 2
    q = p^j
    return q * q * p
end

# derivative
import SimplePolynomials: derivative
import Base: adjoint

function derivative(f::SimpleRationalFunction)
    p = numerator(f)
    q = denominator(f)
    return (p'*q - q'*p)/(q*q)
end
adjoint(f::SimpleRationalFunction) = derivative(f)
