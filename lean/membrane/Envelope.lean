namespace MEM8

/-- Stability envelope thresholds. -/
structure Envelope where
  env : ℕ → ℝ

/-- Envelope monotonicity: deformation must reduce thresholds. -/
def envelopeMonotone (E E' : Envelope) : Prop :=
  ∀ i, E'.env i ≤ E.env i

end MEM8
