# Partial dependence function
suppose E[yi|Xi] = f(Xi)

Q: How does y depend on xj H.A.E.F.?
- linear model: just betaj
- for nonlinear functions:
1. create a grid of points xj(k) that spans the range of xj values
2. for each grid point, and every training point evaluate f(xj(k), X(i|-j))
3. take average: f~j(xj(t)) = 1/n * sum(i = 1, N, f(xj(k), X(i|-j)))
