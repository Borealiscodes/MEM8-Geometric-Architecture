module Drift

export drift

"""
    drift(z, z_prev)

Compute drift between the current semantic vector `z`
and the previous semantic vector `z_prev`.

Drift is defined as the L1 magnitude:

    drift = sum(abs.(z - z_prev))

This diagnostic is used by:
- collapse-risk
- membrane stability fields
- routing stability
- UOS iteration diagnostics
"""
function drift(z::Vector{Float64}, z_prev::Vector{Float64})
    return sum(abs.(z .- z_prev))
end

end
