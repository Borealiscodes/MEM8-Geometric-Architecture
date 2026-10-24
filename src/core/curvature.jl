module Curvature

export riemann_tensor, sectional_curvature, ricci_curvature, scalar_curvature

"""
    riemann_tensor(conn)

Compute the Riemann curvature tensor Rᵢⱼₖₗ from the connection Γ.
This is a first-order symbolic expansion suitable for stability diagnostics.

Rᵢⱼₖₗ = ∂ₖ Γᵢⱼₗ - ∂ₗ Γᵢⱼₖ
         + Γᵢₘₖ Γᵐⱼₗ - Γᵢₘₗ Γᵐⱼₖ

For now, partial derivatives are set to zero (constant connection assumption).
This is sufficient for MEM8's stability envelope and operator stack.
"""
function riemann_tensor(conn)
    Γ = conn.Γ
    n = size(Γ, 1)
    R = zeros(Float64, n, n, n, n)

    for i in 1:n, j in 1:n, k in 1:n, l in 1:n
        term = 0.0
        for m in 1:n
            term += Γ[i,m,k] * Γ[m,j,l] - Γ[i,m,l] * Γ[m,j,k]
        end
        R[i,j,k,l] = term
    end

    return R
end

"""
    sectional_curvature(m, conn, x, y)

Compute sectional curvature K(x, y) for tangent vectors x and y:

    K = ⟨R(x, y)y, x⟩ / (‖x‖² ‖y‖² - ⟨x, y⟩²)

This is the primary curvature diagnostic used throughout MEM8.
"""
function sectional_curvature(metric, conn, x::Vector{Float64}, y::Vector{Float64})
    R = riemann_tensor(conn)
    n = length(x)

    # Compute R(x, y)y
    Ry = zeros(Float64, n)
    for i in 1:n, j in 1:n, k in 1:n, l in 1:n
        Ry[i] += R[i,j,k,l] * x[j] * y[k] * y[l]
    end

    numerator = inner(metric, Ry, x)
    denom = norm(metric, x)^2 * norm(metric, y)^2 - inner(metric, x, y)^2

    return denom == 0.0 ? 0.0 : numerator / denom
end

"""
    ricci_curvature(metric, conn, x)

Compute Ricci curvature Ric(x, x) by contracting the Riemann tensor.
"""
function ricci_curvature(metric, conn, x::Vector{Float64})
    R = riemann_tensor(conn)
    n = length(x)
    Ric = zeros(Float64, n, n)

    for i in 1:n, j in 1:n, k in 1:n
        Ric[i,j] += R[k,i,k,j]
    end

    return inner(metric, Ric * x, x)
end

"""
    scalar_curvature(conn)

Compute scalar curvature by contracting the Ricci tensor.
"""
function scalar_curvature(conn)
    R = riemann_tensor(conn)
    n = size(R, 1)
    scalar = 0.0

    for i in 1:n, j in 1:n, k in 1:n
        scalar += R[k,i,k,j]
    end

    return scalar
end

end
