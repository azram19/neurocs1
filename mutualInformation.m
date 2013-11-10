function [MI] = mutualInformation(S,N,i)

    SminusX=S;
    SminusX(i,:)=[];
    MI = entropy(S(i,:),1) + entropy(SminusX,N-1) - entropy(S,N);

end