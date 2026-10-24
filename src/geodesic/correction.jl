module Correction

export correct_geodesic

correct_geodesic(γ, grad) = γ .- grad

end
