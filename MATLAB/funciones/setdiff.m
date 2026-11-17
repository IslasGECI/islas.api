function C = setdiff(A,B)
nA = length(A);
esAenB = false(nA,1);
for iA = 1:nA
    esAenB(iA) = any(eq(A(iA),B));
end
C = islas.unique(A(~esAenB));
end