function [L,U] = mylu3b(A)
    n = size(A)(1)
    for k = 1 : n-1
        for i = k+1 : n
            A(i,k) = A(i,k)/A(k,k)
        end
        for i = k+1 : n
            for j = k+1 : n
                A(i,j) = A(i,j) - A(i,k) * A(k,j)
            end
        end
    end
    U = triu(A)
    L = A - U + eye(n,n)
endfunction


function [L,U] = mylu1b(A)
    n = size(A)(1)
    for k = 1 : n-1
        A(k+1:n, k) = A(k+1:n, k)/A(k,k)
        A(k+1:n, k+1:n) = A(k+1:n,k+1:n) - A(k+1:n,k) * A(k,k+1:n)
    end
    U = triu(A)
    L = A - U + eye(n,n)
endfunction

function [L,U,P] = nul_mylu(A)
    n = size(A)(1)
    P = eye(n,n)
    row = [1, 1:n]
    for k = 1:n-1
        [piv, ind] = max(abs(A(k:n,k)))
        ind = k - 1 + ind
        q = row(1,ind)
        if ind ~= k then
            new = A(ind,:)
            A(ind,:) = A(k,:)
            A(k,:) = new
            row(1,ind) = row(1, k)
            row(1,k) = q
        end
    end
endfunction

//http://wwwens.aero.jussieu.fr/lefrere/master/mni/mncs/te/te1-alg-lin/gauss-jordan.pdf 
// p = k  ;  q = ind
function [L,U,P] = myluold(A)
    n = size(A)(1)
    P = eye(n,n)
    row = [1, 1:n]
    for k = 1:n-1
        [piv, ind] = max(abs(A(k:n,k)))
        if ind ~= k then
            old = A(ind, :)
            A(ind,:) = A(k,:)
            A(k,:) = old
        end        
    end
endfunction



function [L,U,P] = mylu(A)
    n = size(A)(1)
    P = eye(A)
    for k = 1 : n-1
        [piv, ind] = max(abs(A(k:n,k)))
        ind = k - 1 + ind
        if ind ~= k then
            new = A(ind,:)
            A(ind,:) = A(k,:)
            A(k,:) = new
            tmp = P(:, ind)
            P(:, ind) = P(:, k)
            P(:, k) = tmp
        end
        A(k+1:n, k) = A(k+1:n, k)/A(k,k)
        A(k+1:n, k+1:n) = A(k+1:n,k+1:n) - A(k+1:n,k) * A(k,k+1:n)
    end
    U = triu(A)
    L = A - U + eye(n,n)
endfunction

/*function [L,U,P] = mylu(A)
    n = size(A)(1)
    row = 1:n-1
    for k = 1 : n-1
        [piv, ind] = max(abs(A(k:n,k)))
        ind = k - 1 + ind
        q = row(ind)
        if ind ~= k then
            new = A(ind,:)
            A(ind,:) = A(k,:)
            A(k,:) = new
            row(ind) = row(k)
            row(k) = q
        end
        A(k+1:n, k) = A(k+1:n, k)/A(k,k)
        A(k+1:n, k+1:n) = A(k+1:n,k+1:n) - A(k+1:n,k) * A(k,k+1:n)
    end
    U = triu(A)
    L = A - U + eye(n,n)
endfunction

*/
