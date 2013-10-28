function connectivityMatrix = generateConnectivityMatrix(rows, cols, edges)
    connectivityMatrix = zeros(rows,cols);
    for j = 1:length(edges)
        edge = edges(j,:);
        connectivityMatrix(edge(1), edge(2)) = 1;
    end
end