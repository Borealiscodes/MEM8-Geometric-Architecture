module Jacobian

export jacobian_roughness

"""
    jacobian_roughness(z)

Compute Jacobian roughness for a semantic vector `z`.

Roughness is defined as the L1 deviation from a local smoothing operator:

    smooth(z)_i = (z_{i-1} + z_i + z_{i+1}) / 3

Jacobian roughness is then:

    roughness = sum(abs.(z - smooth(z)))

This diagnostic is used by:
- collapse-risk
- membrane stability fields
- routing stability
- UOS iteration diagnostics
"""
function jacobian_roughness(z::Vector{Float64})
    n = length(z)
    smooth = zeros(Float64, n)

    # Local smoothing operator
    for i in 1:n
        left  = i == 1     ? z[i] : z[i-1]
        mid   = z[i]
        right = i == n     ? z[i] : z[i+1]
        smooth[i] = (left + mid + right) / 3
    end

    # Roughness = L1 deviation from smoothness
    return sum(abs.(z .- smooth))
end

end
