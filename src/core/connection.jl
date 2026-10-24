module Connection

export Connection, christoffel, parallel_transport

"""
    Connection(Γ)

A Levi-Civita connection represented by Christoffel symbols Γ[i,j,k].
Γ is a rank-3 tensor where:
- i is the output coordinate index,
- j and k are the input coordinate indices.

The connection defines how tangent vectors change as we move on the manifold.
"""
struct Connection
    Γ::Array{Float64,3}
end

"""
    christoffel(conn, i, j, k)

Return the Christoffel symbol Γᵢⱼₖ.
These coefficients encode the geometry of the manifold and are used for
curvature, geodesics, holonomy, and collapse-risk diagnostics.
"""
christoffel(conn::Connection, i::Int, j::Int, k::Int) = conn.Γ[i, j, k]

"""
    parallel_transport(conn, v, direction)

Parallel transport a tangent vector `v` along a direction vector `direction`
using the connection. This is a first-order approximation:

    v' = v - Γᵢⱼₖ * vⱼ * directionₖ

This operation is central to holonomy drift and stability diagnostics.
"""
function parallel_transport(conn::Connection, v::Vector{Float64}, direction::Vector{Float64})
    n = length(v)
    out = zeros(Float64, n)

    for i in 1:n
        correction = 0.0
        for j in 1:n
            for k in 1:n
                correction += conn.Γ[i,j,k] * v[j] * direction[k]
            end
        end
        out[i] = v[i] - correction
    end

    return out
end

end
