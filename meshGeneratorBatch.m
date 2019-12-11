clc
clear all
%%
NxList = [200, 400, 800, 1600];
AList = [3, 1.5, 1, 0.75].* 1e-25;
EXP = 3;

%%
for i = 1: length(NxList)
    for j = 1: length(AList)
        meshGenerator(NxList(i), AList(j), EXP);
    end
end