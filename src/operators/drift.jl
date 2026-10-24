module Drift

export drift

drift(C, C_prev) = abs.(C .- C_prev)

end
