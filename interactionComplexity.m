function [C] = interactionComplexity(S, N)

sumMutualInfo=0;
for i=1:N
    sumMutualInfo=sumMutualInfo+mutualInformation(S,N,i);
end

C = sumMutualInfo - integration(S,N);

end