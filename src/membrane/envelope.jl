module Envelope

export in_envelope

in_envelope(metrics, thresholds) = all(metrics .< thresholds)

end
