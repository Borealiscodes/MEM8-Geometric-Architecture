module StabilityField

export stability_field

stability_field(gradS, gradH, gradI) = -(gradS .+ gradH .+ gradI)

end
