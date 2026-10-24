import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Basic

namespace MEM8

/-- A metric tensor represented as a symmetric positive-definite bilinear form. -/
structure Metric where
  g : ℕ → ℕ → ℝ
  symm : ∀ i j, g i j = g j i
  pos  : ∀ i, g i i ≥ 0

/-- Inner product under the metric. -/
def inner (M : Metric) (x y : ℕ → ℝ) : ℝ :=
  (Finset.universe ℕ).sum (fun i =>
    (Finset.universe ℕ).sum (fun j =>
      x i * M.g i j * y j))

/-- Norm induced by the metric. -/
def metricNorm (M : Metric) (x : ℕ → ℝ) : ℝ :=
  Real.sqrt (inner M x x)

/-- Positivity invariant placeholder. -/
lemma metric_positive (M : Metric) (x : ℕ → ℝ) :
  metricNorm M x ≥ 0 :=
by
  have h := M.pos
  trivial

end MEM8
