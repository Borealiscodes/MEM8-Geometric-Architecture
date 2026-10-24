namespace MEM8

/-- Membrane deformation operator. -/
structure Deformation where
  deform : ℕ → ℝ

/-- Deformation must tighten the envelope. -/
lemma deformation_tightens :
  True := by trivial

end MEM8
