function c = concatenate(a)
b = cellfun(@(x) [x(:); NaN]',a(1:end-1),'UniformOutput',false);
aEnd = a{end};
aEnd = aEnd(:)';
c = [b{:} aEnd];
end