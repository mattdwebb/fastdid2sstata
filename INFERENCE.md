# Native inference

Corrected two-stage GMM scores: sum_i w_i[D_i(e_i-theta)-U_i e_i X_i A^-1 h]/M, A=X_U'W_U X_U, h=X'WD, M=sum wD. No finite-sample multiplier; normal reference.

## November 2026 support revision

The Stata delete-cluster calculation now recomputes the estimator on surviving support. Disappearance of an adoption cohort by itself does not invalidate a deletion. Every required deletion must yield an estimate for a jackknife standard error.
