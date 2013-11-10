function [I] = integration(S,N)

    sumEntropy=0;
    for i=1:N
        sumEntropy=sumEntropy+entropy(S(i,:),1);
    end

    I=sumEntropy-entropy(S,N);
end