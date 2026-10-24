# 🐍 Python Tooling — MEM8‑Geometric‑Architecture

Python is the diagnostic companion to the Julia geometric runtime.

Julia executes the Unified Operator Stack (UOS).  
Lean proves the geometric invariants.  
Python inspects, visualizes, and validates the numerics.

This document explains:

- why Python is needed  
- what each tool does  
- how Python integrates with the geometric runtime  
- how to run the tooling suite  
- how accessibility graphics are generated  

---

🧪 Why Python?

Python is not used to execute MEM8.  
Julia owns execution because:

- geometric operators require deterministic numerics  
- GPU nondeterminism breaks invariants  
- multiple dispatch maps cleanly to geometric operators  
- the UOS pipeline is altitude‑layered and modular  

Python is used because it excels at:

- visualization  
- inspection  
- debugging  
- accessibility graphics  
- rapid prototyping of diagnostic views  

Python is the microscope for the geometric runtime.

---

🧬 Tooling Directory Structure

`
<pre> 
tooling/
│
├── spectral_inspector.py      # Visualizes spectral bundles
├── holonomy_debugger.py       # Inspects holonomy drift numerically
├── collapse_visualizer.py     # Plots collapse-risk surfaces
├── membrane_probe.py          # Probes membrane boundaries
├── routing_flow.py            # Visualizes routing vectors
└── traversal_png.py           # Generates accessibility PNGs
</pre>
`

Each tool corresponds to a specific altitude in the unified preprint.

---

🌀 Spectral Inspector

File: spectral_inspector.py

Purpose:

- load spectral bundles from Julia  
- visualize bundle evolution  
- detect spectral instability  
- compare bundle normalization across iterations  

Outputs:

- line plots  
- bundle heatmaps  
- stability overlays  

Spectral bundles are the lowest altitude diagnostic, and Python provides clarity that Julia alone cannot.

---

🧭 Holonomy Debugger

File: holonomy_debugger.py

Purpose:

- inspect holonomy drift numerically  
- visualize parallel transport deviation  
- detect curvature-induced instability  

Outputs:

- holonomy drift curves  
- parallel transport deviation plots  
- curvature overlays  

Holonomy is subtle — Python makes it visible.

---

⚠️ Collapse-Risk Visualizer

File: collapse_visualizer.py

Purpose:

- plot collapse-risk eigenvalues  
- visualize collapse surfaces  
- detect instability regions  

Outputs:

- collapse-risk surface plots  
- eigenvalue trajectories  
- envelope overlays  

Collapse-risk is one of the most important diagnostics in MEM8.

---

🛡️ Membrane Probe

File: membrane_probe.py

Purpose:

- probe membrane boundaries  
- visualize envelope membership  
- inspect projection vectors  
- detect unsafe semantic states  

Outputs:

- envelope boundary plots  
- membrane projection arrows  
- collapse-scaled correction vectors  

This tool makes the membrane intuitive.

---

🧭 Routing Flow Visualizer

File: routing_flow.py

Purpose:

- visualize routing direction vectors  
- inspect collapse-aware scaling  
- detect routing instability  

Outputs:

- vector fields  
- routing flow diagrams  
- geodesic vs. routed motion overlays  

Routing is the top altitude motion operator — Python makes it explorable.

---

🌈 Traversal PNG Generator

File: traversal_png.py

Purpose:

- generate accessible traversal graphics  
- produce color-coded tiles  
- visualize UOS iteration paths  
- support documentation and accessibility  

Outputs:

- PNG tiles  
- traversal diagrams  
- membrane-safe region graphics  

This tool preserves the aesthetic lineage of the v1.0 README.

---

🔗 Integration with Julia

Python tools read Julia output via:

- JSON dumps  
- NumPy-compatible arrays  
- CSV traces  
- HDF5 snapshots  

Julia produces deterministic numeric traces.  
Python visualizes them.

This separation keeps the runtime pure and the diagnostics flexible.

---

▶️ Running the Tooling Suite

From the project root:

`bash
python3 tooling/spectral_inspector.py
python3 tooling/holonomy_debugger.py
python3 tooling/collapse_visualizer.py
python3 tooling/membrane_probe.py
python3 tooling/routing_flow.py
python3 tooling/traversal_png.py
`

Each tool prints usage instructions and expected input formats.

---

🧠 Why Python Matters

Python completes the geometric ecosystem:

- Julia executes the runtime  
- Lean proves the invariants  
- Python inspects the numerics  

This tri-layer architecture is essential for:

- research clarity  
- accessibility  
- debugging  
- visualization  
- academic defensibility  

Python is not optional — it is the diagnostic lens through which the geometry becomes visible.

`

---

