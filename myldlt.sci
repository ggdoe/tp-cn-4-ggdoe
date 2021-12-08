function [L,D] = myldlt(A)
    n = size(A)(1)
    v = zeros(n,1)
    for j=1:n
        for i=1:j-1
            v(i,1) = A(j,i) - A(i,i)
        end
        A(j,j) = A(j,j)-A(j,1:j-1) * v(1:j-1,1)
        A(j+1:n,j) = (A(j+1:n,j) - A(j+1:n,1:j-1) * v(1:j-1))/A(j,j)
    end
    L = tril(A)
    D = diag(v)
endfunction

function [L,D] = myldlt2(A)
    n = size(A)(1)
    v = zeros(n,1)
    for j=1:n
        //v(1:j-1) = A(j,1:j-1) - A(1:j-1,1:j-1)
        for i=1:j-1
            v(i) = A(j,i) - A(i,i)
        end
        A(j,j) = A(j,j) - A(j,1:j-1) * v(1:j-1)'
        A(j+1:n,j) = (A(j+1:n,j) - A(j+1:n,1:j-1) * v(1:j-1))/A(j,j)
    end
    L = tril(A)
    D = eye(n) * v
endfunction
