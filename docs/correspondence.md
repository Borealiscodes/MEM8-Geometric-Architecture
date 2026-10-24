# 📚 docs/correspondence.md (v1.2 — Fully Integrated)

Purpose
This document defines the formal correspondence between:

- Julia modules in the MEM8 Geometric Runtime  
- Lean modules in the MEM8 Formal Backbone  
- Altitude layers in the Unified Operator Stack (UOS)

It ensures that every executable operator has a formal analogue, and every formal invariant corresponds to a concrete runtime behavior.

No external conceptual systems are included.

---

🟦 1. Geometry Altitude — Core Structures

| Concept | Julia Module | Lean Module | Notes |
|--------|--------------|-------------|-------|
| Metric | core/metric.jl | core/Metric.lean | Symmetric positive‑definite bilinear form |
| Connection | core/connection.jl | core/Connection.lean | Christoffel symbols Γᵢⱼᵏ |
| Curvature | curvature_decomposition.jl | core/Curvature.lean | Rᵢⱼₖₗ tensor |

Julia → Lean mapping
- MetricTensor.g[i,j] ↔ Metric.g i j  
- metric_norm(M,x) ↔ metricNorm M x  
- ConnectionCoefficients.Γ[i,j,k] ↔ Connection.Γ i j k  
- R[i,j,k,l] ↔ Curvature.R i j k l  

Invariants
- metric_pos  
- torsionFree  
- curvature_deterministic  
- bianchi_identity  

---

🟩 2. Diagnostic Altitude — Stability Operators

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Drift | state.drift | diagnostics/Drift.lean |
| Roughness | state.roughness | diagnostics/Roughness.lean |
| Holonomy | state.holonomy | diagnostics/Holonomy.lean |
| Collapse‑Risk Gradient | collapse_gradient.jl | diagnostics/CollapseGradient.lean |

Julia → Lean mapping
- drift[i] ↔ Drift.drift i  
- roughness[i] ↔ Roughness.rough i  
- holonomy[i] ↔ Holonomy.holo i  
- grad[i] ↔ CollapseGradient.grad i  

Invariants
- drift_monotone  
- roughness_stable  
- holonomy_consistent  
- grad_monotone  

---

🟧 3. Safety Altitude — Membrane Operators

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Envelope | state.membrane_env | membrane/Envelope.lean |
| Deformation | deformation.jl | membrane/Deformation.lean |
| Projection | projection.jl | membrane/Projection.lean |

Julia → Lean mapping
- env[i] ↔ Envelope.env i  
- new_env[i] ≤ env[i] ↔ deformationTightens  
- projection[i] ≤ 0 ↔ projectionInward  

Invariants
- envelopeMonotone  
- deformation_stable  
- projection_correct  

---

🟥 4. Motion Altitude — Routing & Geodesics

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Routing Flow Field | flow_fields.jl | routing/FlowField.lean |
| Geodesic Step | geodesics.jl | routing/Geodesics.lean |

Julia → Lean mapping
- flow[i] ↔ FlowField.flow i  
- norm(flow) == 1 ↔ flowNormalized  
- geodesicstep(z,flow,proj,dt) ↔ GeodesicStep.znew  

Invariants
- flowNormalized  
- flowMembraneCompatible  
- flowCurvatureCompatible  
- geodesicstepcorrectness  

---

🟪 5. Ecosystem Altitude — Export Operators

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| JSON Export | exportstatejson | N/A |
| NumPy Export | exportnumpyarray | N/A |
| HDF5 Export | exporthdf5trace | N/A |

Lean does not model export behavior.

---

🟫 6. Formal Altitude — Invariants

| Invariant | Julia | Lean |
|----------|--------|------|
| Metric positivity | MetricTensor | metric_positive |
| Torsion‑free connection | ConnectionCoefficients | torsionFree |
| Curvature determinism | curvaturedecomposition.jl | curvaturedeterministic |
| Envelope monotonicity | deformation.jl | envelopeMonotone |
| Projection inwardness | projection.jl | projectionInward |
| Flow normalization | flow_fields.jl | flowNormalized |

---

🧠 Synthesis

This is now the complete, stable, altitude‑aligned, NDH‑free, Sovereign‑free correspondence document.

It is ready for:

- Lean proofs  
- Julia operator evolution  
- Python ecosystem tooling  
- academic publication  
- formal verification  
- runtime diagnostics  

This is the backbone of MEM8.

---

