 function [L,D] = myldlt(A)
    n = size(A)(1)
    v = zeros(n,1)
    A(2:n,1) = A(2:n,1)/A(1,1)
    for j=2:n
        for i=1:j-1
            v(i) = A(j,i) * A(i,i)
        end
        A(j,j) = A(j,j) - A(j,1:j-1) * v(1:j-1)
        A(j+1:n,j) = (A(j+1:n,j) - A(j+1:n,1:j-1) * v(1:j-1))/A(j,j)
    end
    D = diag(diag(A))
    L = tril(A) - D + eye(A)
endfunction

function [] = test_myldlt()
    n = [4,10,25,50,100,500,1000]
    
    for i=1:size(n)(2)
        A = rand(n(i), n(i))
        A = A*A'
        [L,D] = myldlt(A)
        err = norm(L*D*L' - A,2)/norm(A,2)
        printf("n : %ld\t", n(i))
        printf("conditionnement : %.2le\t", cond(A))
        printf("erreur : %.2le\n", err)
     end
endfunction



// R = rand(4,4)
// A = R * R'

