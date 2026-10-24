namespace MEM8

/-- Projection vector must point inward. -/
def inwardProjection (v : ℝ) : Prop :=
  v ≤ 0

lemma projection_inward (v : ℝ) :
  inwardProjection v :=
by simp [inwardProjection]

end MEM8
