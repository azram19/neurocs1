connectivityMatrix = zeros(1000);
connectivityMatrix(1:800,1:800) = matrix1;
connectivityMatrix(801:1000,1:800) = matrix3;
connectivityMatrix(1:800,801:1000) = matrix2;
connectivityMatrix(801:1000,801:1000) = matrix4;
spy(connectivityMatrix)