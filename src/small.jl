"""
`small(x)` converts `x` to `Int`-level precision if there is
no loss. Applies to integer, rational, Gaussian integer,
Gaussian rational, and `SimplePolynomial`. It is a way of
undoing `big` (if possible).
"""
function small(x::T) where T<:Integer
    try
        x = Int(x)
    catch
    end
    return x
end

function small(x::Complex{T}) where T<:Integer
    try
        x = Complex{Int}(x)
    catch
    end
    return x
end

function small(x::Rational{T}) where T<:Integer
    try
        x = Rational{Int}(x)
    catch
    end
    return x
end


function small(x::Complex{Rational{T}}) where T<:Integer
    try
        x = Complex{Rational{Int}}(x)
    catch
    end
    return x
end

small(x::AbstractMod) = x


