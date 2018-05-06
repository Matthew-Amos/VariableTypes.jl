abstract type VariableType end
abstract type Categorical <: VariableType end
abstract type Quantitative <: VariableType end
abstract type Continuous <: Quantitative end
abstract type Discrete <: Quantitative end

# Variable type of a single value
function vartype(v)
    if is_quantitative(v)
        if is_continuous(v)
            return Continuous
        elseif is_discrete(v)
            return Discrete
        else
            return Quantitative
        end
    else
        # Not currently making a distinction between nominal/dichotomous or ordinal
        return Categorical
    end
end

# Variable type for a vector
# will check the lesser of the vector length or `searchlen`
function vartype(v::T where T <: AbstractVector, searchlen = 100)
    subarr = v[1:min(length(v), searchlen)]

    # Assess
    if any(is_categorical.(subarr))
        return Categorical
    else
        if any(is_continuous.(subarr))
            return Continuous
        elseif any(is_discrete.(subarr))
            return Discrete
        else
            return Quantitative
        end
    end
end

# Variable types for a matrix
function vartype(v::T where T <: AbstractMatrix, dim=1, searchlen = 100)
    if dim !== 1 && dim !== 2
        error("dim must equal 1 or 2")
    end

    len = size(v, dim == 1 ? 2 : 1)
    vartypes = Array{Any, 1}(len)

    @inbounds for i = 1:len
        if dim == 1
            vartypes[i] = vartype(v[:, i], searchlen)
        else
            vartypes[i] = vartype(v[i, :], searchlen)
        end
    end

    return vartypes
end

# Type => Variable Type logic
is_quantitative(v) = typeof(v) <: Number && typeof(v) !== Bool
is_categorical(v) = !is_quantitative(v)
is_continuous(v) = typeof(v) <: AbstractFloat || typeof(v) <: Complex || typeof(v) <: Irrational
is_discrete(v) = typeof(v) <: Int || typeof(v) <: Rational
