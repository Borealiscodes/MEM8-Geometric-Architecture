module Connection

using LinearAlgebra
using StaticArrays

export ConnectionCoefficients, christoffel_symbol

"""
    ConnectionCoefficients(Γ)

Connection coefficients Γᵢⱼᵏ (Christoffel symbols).

These define how vectors change as they move along the manifold.
"""
struct ConnectionCoefficients
    Γ::Array{Float64,3}   # Γ[i,j,k]
end

"""
    christoffel_symbol(C, i, j, k)

Access a single Christoffel symbol Γᵢⱼᵏ.
"""
function christoffel_symbol(C::ConnectionCoefficients,
                            i::Int, j::Int, k::Int)
    return C.Γ[i,j,k]
end

end # module
