namespace MEM8

/-- Abstract connection coefficients Γᵢⱼᵏ. -/
structure Connection where
  Γ : ℕ → ℕ → ℕ → ℝ

/-- Zero torsion invariant: Γᵢⱼᵏ = Γⱼᵢᵏ. -/
def torsionFree (C : Connection) : Prop :=
  ∀ i j k, C.Γ i j k = C.Γ j i k

end MEM8
