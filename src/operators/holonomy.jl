module Holonomy

export holonomy_drift

holonomy_drift(B, Bp) = abs.(B .- Bp)

end
