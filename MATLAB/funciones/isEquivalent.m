function esEquivalente = isEquivalent(A,B)
nA = length(A);
esAenB = false(nA,1);
for iA = 1:nA
    esAenB(iA) = any(eq(A(iA),B));
end
esAsubconjuntoDeB = all(esAenB);
nB = length(B);
esBenA = false(nB,1);
for iB = 1:nB
    esBenA(iB) = any(eq(B(iB),A));
end
esBsubconjuntoDeA = all(esBenA);
esEquivalente = esAsubconjuntoDeB & esBsubconjuntoDeA;
end