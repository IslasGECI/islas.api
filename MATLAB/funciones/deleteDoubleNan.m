function xSinDobleNan = deleteDobleNan(x)
esNan = isnan(x);
esDobleNan = [false esNan(1:end-1)] & esNan;
xSinDobleNan = x(~esDobleNan);
end