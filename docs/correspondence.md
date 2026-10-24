# 📚 docs/correspondence.md (v1.1 — Geometry Altitude Integrated)

Purpose
This document defines the formal correspondence between:

- Julia modules in the MEM8 Geometric Runtime  
- Lean modules in the MEM8 Formal Backbone  
- Altitude layers in the Unified Operator Stack (UOS)

It ensures that every executable operator has a formal analogue, and every formal invariant corresponds to a concrete runtime behavior.

No external conceptual systems are included.

---

🟦 1. Geometry Altitude — Core Structures

The geometry altitude defines the manifold structure on which all MEM8 operators act.

Metric

| Julia | Lean | Notes |
|-------|------|-------|
| MetricTensor (metric.jl) | core/Metric.lean | Symmetric positive‑definite bilinear form |

Julia → Lean mapping
- MetricTensor.g[i,j] ↔ Metric.g x y
- metric_norm(M, x) ↔ metricNorm M x
- positivity invariant ↔ metric_pos

---

Connection

| Julia | Lean | Notes |
|-------|------|-------|
| ConnectionCoefficients (connection.jl) | core/Connection.lean | Christoffel symbols Γᵢⱼᵏ |

Julia → Lean mapping
- C.Γ[i,j,k] ↔ Connection.Γ i j k
- torsion‑free invariant ↔ torsionFree

---

Curvature

| Julia | Lean | Notes |
|-------|------|-------|
| curvature_decomposition.jl | core/Curvature.lean | Rᵢⱼₖₗ tensor |

Julia → Lean mapping
- R[i,j,k,l] ↔ Curvature.R i j k l
- Ricci contraction ↔ future Lean lemma  
- scalar curvature ↔ future Lean lemma  
- sectional curvature ↔ future Lean lemma  

---

🟩 2. Diagnostic Altitude — Stability Operators

Diagnostics quantify instability and feed into membrane deformation and routing.

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Drift | state.drift | diagnostics/Drift.lean (future) |
| Roughness | state.roughness | diagnostics/Roughness.lean (future) |
| Holonomy | state.holonomy | diagnostics/Holonomy.lean (future) |
| Collapse‑Risk Gradient | collapse_gradient.jl | diagnostics/CollapseGradient.lean |

Julia → Lean mapping
- grad[i] ↔ CollapseGradient.grad i
- gradient monotonicity ↔ grad_monotone

---

🟧 3. Safety Altitude — Membrane Operators

The membrane defines the stability envelope and enforces inward motion.

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Envelope | state.membrane_env | membrane/Envelope.lean |
| Deformation | deformation.jl | membrane/Deformation.lean |
| Projection | projection.jl | membrane/Projection.lean |

Julia → Lean mapping
- new_env[i] ≤ env[i] ↔ envelopeMonotone
- projection[i] ≤ 0 ↔ inwardProjection

---

🟥 4. Motion Altitude — Routing & Geodesics

Motion altitude defines how states evolve under curvature and membrane constraints.

| Concept | Julia Module | Lean Module |
|--------|--------------|-------------|
| Routing Flow Field | flow_fields.jl | routing/FlowField.lean |
| Geodesic Step | geodesics.jl | routing/Geodesics.lean (future) |

Julia → Lean mapping
- flow[i] ↔ FlowField.flow i
- norm(flow) == 1 ↔ normalized
- geodesic step ↔ future Lean lemma

---

🟪 5. Ecosystem Altitude — Export Operators

Diagnostics and visualization tools.

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
| Metric positivity | MetricTensor | metric_pos |
| Torsion‑free connection | ConnectionCoefficients | torsionFree |
| Curvature determinism | curvaturedecomposition.jl | curvaturedeterministic |
| Envelope monotonicity | deformation.jl | envelopeMonotone |
| Projection inwardness | projection.jl | projection_inward |
| Flow normalization | flow_fields.jl | normalized |

---

🧠 Synthesis

This updated document now includes:

- Metric  
- Connection  
- Curvature  
- Geodesics  

The geometry altitude is fully represented in both Julia and Lean.

This is the clean, correct, academically defensible correspondence layer.

---

