# Method

Untreated additive cluster/unit FE, time FE and common-slope covariate least squares. Average treated Y-X beta with observation weights. Refit first stage on each deletion and assignment. Not naive second-stage clustering.

Stata currently uses cluster FE only. TWFE uses native weighted alternating
projections; other models use bounded (12-million estimated-entry) SVD reference
designs. No reghdfe/ftools or cross-language runtime calls. At fixed design the
scalar is linear in Y; deletion/reassignment rebuilds assignment-dependent design.
