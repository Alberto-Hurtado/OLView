function printfigs
% printfigs:   Print all the figures

figs=get(0,'children');
for i=1:length(figs);
    print(figs(i));
end;
