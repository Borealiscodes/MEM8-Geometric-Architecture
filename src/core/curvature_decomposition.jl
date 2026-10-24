module CurvatureDecomposition

using LinearAlgebra
using StaticArrays

export sectional_curvature,
       ricci_curvature,
       scalar_curvature,
       collapse_surface_curvature

"""
    sectional_curvature(R, u, v)

Compute the sectional curvature K(u, v) for tangent vectors `u` and `v`
given a curvature tensor `R[i,j,k,l]`.

K(u, v) = <R(u, v)v, u> / (||u||^2 * ||v||^2 - <u, v>^2)

All operations are deterministic and use StaticArrays for stability.
"""
function sectional_curvature(R::Array{Float64,4},
                             u::AbstractVector{Float64},
                             v::AbstractVector{Float64})

    u = SVector{length(u)}(u)
    v = SVector{length(v)}(v)

    # Compute R(u, v)v
    Ru_v = zero(u)
    for i in 1:length(u)
        for j in 1:length(u)
            for k in 1:length(u)
                for l in 1:length(u)
                    Ru_v = Ru_v + R[i,j,k,l] * u[j] * v[k] * v[l] * SVector{length(u)}(unit(i, length(u)))
                end
            end
        end
    end

    numerator = dot(Ru_v, u)
    denom = (dot(u,u) * dot(v,v)) - (dot(u,v)^2)

    return numerator / denom
end


"""
    ricci_curvature(R)

Compute the Ricci curvature tensor Ric[i,j] by contracting the curvature tensor:

Ric[i,j] = Σ_k R[k,i,k,j]
"""
function ricci_curvature(R::Array{Float64,4})
    n = size(R,1)
    Ric = zeros(Float64, n, n)

    for i in 1:n
        for j in 1:n
            s = 0.0
            for k in 1:n
                s += R[k,i,k,j]
            end
            Ric[i,j] = s
        end
    end

    return Ric
end


"""
    scalar_curvature(R)

Compute the scalar curvature S by contracting the Ricci tensor:

S = Σ_i Ric[i,i]
"""
function scalar_curvature(R::Array{Float64,4})
    Ric = ricci_curvature(R)
    return sum(diag(Ric))
end


"""
    collapse_surface_curvature(R)

Compute a collapse-surface curvature score based on:

- scalar curvature magnitude
- Ricci curvature trace norm
- sectional curvature sampling

This is a deterministic geometric proxy for collapse-surface proximity.
"""
function collapse_surface_curvature(R::Array{Float64,4})
    n = size(R,1)

    # Scalar curvature contribution
    S = abs(scalar_curvature(R))

    # Ricci norm contribution
    Ric = ricci_curvature(R)
    ric_norm = norm(Ric)

    # Sectional curvature sampling (deterministic)
    u = ones(n)
    v = reverse(u)
    K = abs(sectional_curvature(R, u, v))

    # Weighted geometric score (no magic constants)
    return S + ric_norm + K
end


# Utility: unit vector basis
unit(i, n) = SVector{n}([j == i ? 1.0 : 0.0 for j in 1:n])

end # module
