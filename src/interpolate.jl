export interpolate


"""
    interpolate(vals::Vector{T})::SimplePolynomial where {T<:Number}

Given a list of numbers `vals`, find a polynomial `p` that generates that list.
That is, `p(0)` gives the first value on the list, `p(1)` the second value, 
and so forth. 
"""
function interpolate(vals::Vector{T})::SimplePolynomial where {T<:Number}

    if length(vals) < 1
        error("List of values must not be empty")
    end

    list_of_lists = Vector{Vector{T}}()
    push!(list_of_lists, vals)
    z = last(list_of_lists)

    while !(all(z .== 0)) && length(z) >= 1
        if length(z) == 1 && first(z) != 0
            @warn "Iterated differences did not reach zero; provide more values?"
            break
        end
        z = diff(z)
        push!(list_of_lists, z)
    end

    leads = first.(list_of_lists)

    x = getx()
    n = length(leads)
    return sum(leads[k] * binomial(x, k - 1) for k = 1:n)

end
