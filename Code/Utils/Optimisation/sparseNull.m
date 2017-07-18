function H = sparseNull(A, thresh)
% NULLS   Null space of a sparse matrix.
%    Z = NULLS(A) is a basis for the null space of A.  That is, A*Z has
%    negligible elements and size(Z,2) is the nullity of A.  The algorithm
%    used [1] is optimized for sparse matrices.
%
%    Z = NULLS(A,thresh) controls pivoting between maximum preservation of
%    sparsity (thresh=0) and maximum accuracy (thresh=1). The default is
%    thresh=0.1.
%
%    [1] M. Khorramizadeh and N. Mahdavi-Amiri, "An efficient algorithm for
%    sparse null space basis problem using ABS methods," Numerical
%    Algorithms, vol. 62, no. 3, pp. 469–485, Jun. 2012.
%
%    Example:
%    A = sprand(1000, 1500, 0.001);
%    Z = nulls(A);
%    size(Z,2)    % at least 500, typically more, depending on A
%    norm(A*Z,1)  % should give a small value

%   Copyright 2013 Martin Holters
if nargin==1
    thresh = 0.1;
end

[m,n] = size(A);

% get ordering of the rows of A by ascending count of non-zero elements
r = sum(spones(A),2);
[~, t] = sort(r, 'ascend');

% initialize H1
H = speye(n);

% A is transposed once beforehand as column accesses are cheaper than row accesses
At = A.';
for i=1:m
    % note that H is transposed compared to [1], and hence, so is s
    s = At(:,t(i)).' * H;
    if nnz(s) == 0
        continue
    end
    % only consider non-zero entries in s
    jnz = find(s);
    % filter based on the pivoting threshold
    j = jnz(abs(s(jnz)) >= thresh*max(abs(s)));
    % from the permissible columns in H, find the one with the lowest number of non-zero elements
    [~, jj] = min(sum(spones(H(:,j))));
    j = j(jj);
    % multiplication with G from [1] can be represented by the following matrix manipulation
    H = [H(:,1:j-1), H(:,j+1:end)] - H(:,j)*[s(1:j-1), s(j+1:end)]/s(j);
end