import Base: (+), (-), (*), (/), (//), (^), divrem

export monic


# Addition

function (+)(p::SimplePolynomial, q::SimplePolynomial)
    n = max(degree(p), degree(q))
    T = typeof(p(1) + q(1))
    c = zeros(T, n + 1)
    for j = 0:n
        c[j+1] = p[j] + q[j]
    end
    return SimplePolynomial(c)
end

# polynomial + number
function (+)(p::SimplePolynomial, a::T) where {T<:CoefX}
    return p + SimplePolynomial(a)
end

function (+)(a::T, p::SimplePolynomial) where {T<:CoefX}
    return p + SimplePolynomial(a)
end

# Subtraction

function (-)(p::SimplePolynomial)
    coefs = [-x for x in p.data]
    return SimplePolynomial(coefs)
end

(-)(p::SimplePolynomial, q::SimplePolynomial) = p + (-q)
(-)(p::SimplePolynomial, a::T) where {T<:CoefX} = p + (-a)
(-)(a::T, p::SimplePolynomial) where {T<:CoefX} = a + (-p)


# Multiplication

function (*)(a::T, p::SimplePolynomial) where {T<:CoefX}
    coefs = [a * x for x in p.data]
    return SimplePolynomial(coefs)
end

(*)(p::SimplePolynomial, a::T) where {T<:CoefX} = a * p

function (*)(p::SimplePolynomial, q::SimplePolynomial)
    n = degree(p) + degree(q)

    if p == 0 || q == 0
        return SimplePolynomial(0)
    end

    coefs = [p[0] * q[0] for i = 0:n]

    for k = 1:n
        coefs[k+1] = 0 * coefs[k+1]  # clear it out
        for j = 0:k
            coefs[k+1] += p[j] * q[k-j]
        end
    end
    return SimplePolynomial(coefs)
end


# Integer exponentiation

function (^)(p::SimplePolynomial, k::S) where {S<:Integer}

    if k<0
        f = inv(p)
        return f^(-k)
    end

    if k == 0
        return SimplePolynomial(Int(1))
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


# Division

function (/)(p::SimplePolynomial, a::T) where {T<:CoefX}
    coefs = p.data .// a
    return SimplePolynomial(coefs)
end
(//)(p::SimplePolynomial, a::T) where {T<:CoefX} = p / a

"""
`monic(p::SimplePolynomial)` returns a new polynomial formed by
dividing all coefficients by the leading coefficient, thereby
yielding a monic polynomial. If `p` is zero, a zero polynomial
is returned.
"""
function monic(p::SimplePolynomial)::SimplePolynomial
    if p == 0
        return p
    end
    return p / lead(p)
end


function divrem(a::SimplePolynomial, b::SimplePolynomial)
    if b == 0
        DivideError()
    end

    #ST = typeof((a[0]+b[0])//1)
    ST = Int
    if eltype(a) <: AbstractMod || eltype(b) <: AbstractMod
        ST = eltype(a)
    else
        ST = typeof((lead(a)+lead(b))//1)
    end


    da = degree(a)
    db = degree(b)

    if da < db
        return SimplePolynomial(), a
    end

    leader = a.data[end] // b.data[end]

    coefs = zeros(ST, da - db + 1)
    coefs[end] = leader


    q = SimplePolynomial(coefs)
    aa = a - b * q
    qq, r = divrem(aa, b)

    return q + qq, r
end
