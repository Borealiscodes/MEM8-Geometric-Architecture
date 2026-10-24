module Spectral

export spectral_bundles, normalize_bundles

using FFTW

"""
    spectral_bundles(z)

Compute multi-resolution spectral bundles for a semantic vector `z`.

This is the first diagnostic operator in the MEM8 Unified Operator Stack (UOS).
Spectral bundles capture:
- frequency content
- smoothness vs roughness
- multi-scale structure
- early indicators of instability

Returns a vector of spectral magnitudes.
"""
function spectral_bundles(z::Vector{Float64})
    # Full FFT
    F = abs.(fft(z))

    # Multi-resolution bands (simple partition for now)
    n = length(F)
    half = div(n, 2)

    low_band  = mean(F[1:half])        # low-frequency content
    high_band = mean(F[half+1:end])    # high-frequency content

    # Return bundled spectral diagnostics
    return [low_band, high_band]
end

"""
    normalize_bundles(b)

Normalize spectral bundles so they remain numerically stable across iterations.
This prevents drift and collapse-risk from exploding due to FFT scaling.
"""
function normalize_bundles(b::Vector{Float64})
    scale = mean(b)
    return scale == 0.0 ? b : b ./ scale
end

end
