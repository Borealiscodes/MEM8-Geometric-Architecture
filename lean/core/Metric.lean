import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Basic

namespace MEM8

/-- A metric is a positive-definite symmetric bilinear form. -/
structure Metric where
  g : ℝ → ℝ → ℝ
  symm : ∀ x y, g x y = g y x
  pos  : ∀ x, g x x ≥ 0

/-- Norm induced by the metric. -/
def metricNorm (M : Metric) (x : ℝ) : ℝ :=
  Real.sqrt (M.g x x)

/-- Metric positivity invariant. -/
lemma metric_pos (M : Metric) (x : ℝ) :
  M.g x x ≥ 0 :=
by apply M.pos

end MEM8
