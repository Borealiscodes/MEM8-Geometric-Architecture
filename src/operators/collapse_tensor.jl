module CollapseTensor

export collapse_score

collapse_score(T) = maximum(eigvals(T))

end
