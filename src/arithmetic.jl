import Base: (+), (-), (*), (^)


# Addition

function (+)(p::SimplePolynomial, q::SimplePolynomial)
    n = max(degree(p), degree(q))
    coefs = [ p[k]+q[k] for k=0:n ]
    return SimplePolynomial(coefs)
end

# polynomial + number
function (+)(p::SimplePolynomial, a::T) where T<:CoefX
    return p + SimplePolynomial(a)
end

function (+)(a::T, p::SimplePolynomial) where T<:CoefX
    return p + SimplePolynomial(a)
end

# Subtraction

function (-)(p::SimplePolynomial)
    coefs = [-x for x in p.data]
    return SimplePolynomial(coefs)
end

(-)(p::SimplePolynomial,q::SimplePolynomial) = p + (-q)
(-)(p::SimplePolynomial,a::T) where T<:CoefX = p + (-a)
(-)(a::T,p::SimplePolynomial) where T<:CoefX = a + (-p)


# Multiplication

function (*)(a::T, p::SimplePolynomial) where T<:CoefX
    coefs = [a*x for x in p.data]
    return SimplePolynomial(coefs)
end

(*)(p::SimplePolynomial,a::T) where T<:CoefX = a*p

function (*)(p::SimplePolynomial,q::SimplePolynomial)
    n = degree(p)+degree(q)

    if n<0
        return p+q
    end

    coefs = [ p[0]*q[0] for i=0:n ]

    for k=1:n
        coefs[k+1] = 0*coefs[k+1]  # clear it out
        for j=0:k
            coefs[k+1] += p[j]*q[k-j]
        end
    end
    return SimplePolynomial(coefs)
end


# Integer exponentiation

function (^)(p::SimplePolynomial{T}, k::S) where{T, S<:Integer}
    @assert k>=0 "Exponent must be nonnegative [$k]"
    if k==0
        return SimplePolynomial(T(1))
    end

    if k==1
        return p
    end

    if k==2
        return p*p
    end 

    if k%2 == 0  # even exponent
        j = k÷2
        q = p^j
        return q*q
    end

    j = k÷2
    q = p^j
    return q*q*p
end
