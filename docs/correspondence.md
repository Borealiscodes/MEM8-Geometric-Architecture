# 📚 docs/correspondence.md (v1.0 — Clean Lean ↔ Julia Mapping)

Purpose
This document defines the formal correspondence between:

- Julia modules in the MEM8 Geometric Runtime  
- Lean modules in the MEM8 Formal Backbone  
- Altitude layers in the Unified Operator Stack (UOS)

It ensures that every executable operator has a formal analogue, and every formal invariant corresponds to a concrete runtime behavior.

No external conceptual systems (NDH, Sovereign‑Library, etc.) are included unless mathematically required.

---

🟦 1. Geometry Altitude — Core Structures

Metric
| Julia | Lean | Notes |
|-------|------|-------|
| Metric (future struct) | core/Metric.lean | Positive‑definite bilinear form |

Julia → Lean correspondence
- metric.g(x,y) ↔ Metric.g x y
- metric_norm(x) ↔ metricNorm M x
- positivity invariant ↔ metric_pos

---

Connection
| Julia | Lean | Notes |
|-------|------|-------|
| Connection (future struct) | core/Connection.lean | Torsion‑free invariant |

Julia → Lean correspondence
- Γ[i,j,k] ↔ Connection.Γ i j k
- torsion‑free check ↔ torsionFree

---

Curvature
| Julia | Lean | Notes |
|-------|------|-------|
| curvature_decomposition.jl | core/Curvature.lean | Ricci, scalar, sectional curvature |

Julia → Lean correspondence
- R[i,j,k,l] ↔ Curvature.R i j k l
- Ricci contraction ↔ Lean lemma (future)
- scalar curvature ↔ Lean lemma (future)

---

🟩 2. Diagnostic Altitude — Stability Operators

Drift / Roughness / Holonomy
| Julia | Lean | Notes |
|-------|------|-------|
| state.drift | diagnostics/Drift.lean (future) | Norm‑based diagnostic |
| state.roughness | diagnostics/Roughness.lean (future) | Surface irregularity |
| state.holonomy | diagnostics/Holonomy.lean (future) | Loop‑based curvature |

Julia → Lean correspondence
- norm(drift) ↔ Drift.norm lemma  
- norm(roughness) ↔ Roughness.norm lemma  
- norm(holonomy) ↔ Holonomy.norm lemma  

---

Collapse‑Risk Gradient
| Julia | Lean | Notes |
|-------|------|-------|
| collapse_gradient.jl | diagnostics/CollapseGradient.lean | Directional instability |

Julia → Lean correspondence
- grad[i] ↔ CollapseGradient.grad i
- gradient monotonicity ↔ grad_monotone

---

🟧 3. Safety Altitude — Membrane Operators

Envelope
| Julia | Lean | Notes |
|-------|------|-------|
| state.membrane_env | membrane/Envelope.lean | Threshold vector |

Julia → Lean correspondence
- env[i] ↔ Envelope.env i
- deformation monotonicity ↔ envelopeMonotone

---

Deformation
| Julia | Lean | Notes |
|-------|------|-------|
| deformation.jl | membrane/Deformation.lean | Tightening invariant |

Julia → Lean correspondence
- newenv[i] ≤ env[i] ↔ deformationtightens

---

Projection
| Julia | Lean | Notes |
|-------|------|-------|
| (future) projection.jl | membrane/Projection.lean | Inwardness invariant |

Julia → Lean correspondence
- projection[i] ≤ 0 ↔ inwardProjection

---

🟥 4. Motion Altitude — Routing Operators

Routing Flow Field
| Julia | Lean | Notes |
|-------|------|-------|
| flow_fields.jl | routing/FlowField.lean | Normalized vector field |

Julia → Lean correspondence
- flow[i] ↔ FlowField.flow i
- norm(flow) == 1 ↔ normalized

---

Geodesics
| Julia | Lean | Notes |
|-------|------|-------|
| (future) geodesics.jl | routing/Geodesics.lean | Curvature‑aware motion |

Julia → Lean correspondence
- geodesic equation ↔ formal lemma (future)

---

🟪 5. Ecosystem Altitude — Export Operators

JSON / NumPy / HDF5 Export
| Julia | Lean | Notes |
|-------|------|-------|
| export.jl | N/A | Diagnostics only |

Lean does not model export behavior.

---

🟫 6. Formal Altitude — Invariants

| Invariant | Julia | Lean |
|----------|--------|------|
| Metric positivity | Metric struct | metric_pos |
| Torsion‑free connection | Connection struct | torsionFree |
| Curvature determinism | curvaturedecomposition | curvaturedeterministic |
| Envelope monotonicity | deformation.jl | envelopeMonotone |
| Projection inwardness | projection.jl | projection_inward |
| Flow normalization | flow_fields.jl | normalized |

---

🧠 Synthesis

This is the clean, correct, NDH‑free correspondence document:

- Julia ↔ Lean  
- Operator ↔ Invariant  
- Altitude ↔ Module  

NDH concepts are not included unless they become mathematically necessary later.

This document is now stable and ready to evolve as MEM8 grows.

---

