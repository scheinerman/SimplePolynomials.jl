
import Base: numerator, denominator, (==), zero, one, big

export SimpleRationalFunction


struct SimpleRationalFunction
    num::SimplePolynomial
    den::SimplePolynomial
    function SimpleRationalFunction(top::SimplePolynomial, bot::SimplePolynomial)
        if bot == 0
            error("Denominator cannot be zero")
        end
        d = gcd(top,bot)
        t,r = divrem(top,d)
        b,r = divrem(bot,d)

        # make the denominator monic
        a = b.data[end]
        t = t/a
        b = b/a

        new(t,b)
    end
end

SimpleRationalFunction(f::SimplePolynomial) = SimpleRationalFunction(f,SimplePolynomial(1))
SimpleRationalFunction(a::T) where T<:CoefX = SimpleRationalFunction(SimplePolynomial(a))
SimpleRationalFunction(a::T,f::SimplePolynomial) where T<:CoefX = SimpleRationalFunction(SimplePolynomial(a),f)
SimpleRationalFunction(f::SimplePolynomial,a::T) where T<:CoefX = SimpleRationalFunction(f,SimplePolynomial(a))
SimpleRationalFunction(a::T, b::S) where {T<:CoefX,S<:CoefX} = SimpleRationalFunction(a//b)
SimpleRationalFunction() = SimpleRationalFunction(0)

numerator(f::SimpleRationalFunction) = f.num
denominator(f::SimpleRationalFunction) = f.den

(==)(f::SimpleRationalFunction,g::SimpleRationalFunction) = (f.num==g.num) && (f.den==g.den)
(==)(f::SimpleRationalFunction,p::SimplePolynomial) = f == SimpleRationalFunction(p)
(==)(p::SimplePolynomial,f::SimpleRationalFunction) = f==p
(==)(f::SimpleRationalFunction,a::T) where T<:CoefX = f==SimpleRationalFunction(a)
(==)(a::T,f::SimpleRationalFunction) where T<:CoefX = f==a

(f::SimpleRationalFunction)(x) = f.num(x)/f.den(x)

zero(::Type{SimpleRationalFunction}) = SimpleRationalFunction(0,1)
zero(::SimpleRationalFunction) = SimpleRationalFunction(0,1)
one(::Type{SimpleRationalFunction}) = SimpleRationalFunction(1,1)
one(::SimpleRationalFunction) = SimpleRationalFunction(1,1)

big(f::SimpleRationalFunction) = SimpleRationalFunction(big(f.num),big(f.den))



# include("arithmetic.jl")
# include("show.jl")
