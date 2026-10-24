module Spectral

export spectral_bundles

spectral_bundles(x) = abs.(fft(x))

end
