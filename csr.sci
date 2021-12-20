function [v] = csr_mv(AA, JA, IA, x)
    n = length(JA)
    v = zeros(length(IA)-1,1)
    k = IA(1)+1 // +1 évite un tour de while
    for i=1:n
        while(i == IA(k)) // saute les lignes nulles
            k = k + 1
        end
        v(k-1) = v(k-1) + AA(i) * x(JA(i))
    end
    if(isrow(x)) // col/row coherente avec x
        v = v'
    end
endfunction

function [A] = make_mat_creuse(n, m, seuil_rand)
    A = rand(n,m)
    for i = 1:n
        for j = 1:m
            if A(i,j) < seuil_rand then
                A(i,j) = 0 // on supprime les valeurs < seuil
            else // on replace les autres valeurs entre [0,1]
                A(i,j) = (A(i,j) - seuil_rand)/(1-seuil_rand)
            end
        end
    end
endfunction

function [AA, JA, IA] = make_csr(A)
    cpt = 1
    IA(1) = 1
    for i = 1:size(A)(1)
        for j = 1:size(A)(2)
           if A(i,j) ~= 0 then
               AA(cpt) = A(i,j)
               JA(cpt) = j
               cpt = cpt + 1
           end
        end
        IA(i+1) = cpt
    end
    AA = AA'; JA = JA'; IA = IA' // sous forme de ligne pour plus de lisibilité
endfunction

function [A] = undo_csr(AA, JA, IA, m)
    A = zeros(size(IA)(2)-1,m)//ne pause pas trop de pb si m n'est pas set ou 0
    k = 1
    for i = 1:size(AA)(2)
        if k < size(IA)(2) then
        while(i == IA(k+1)) // saute les lignes nulles
            k = k + 1 
        end
        end
        A(k, JA(i)) = AA(i)
    end
endfunction

function [] = mytest_csr(n,m,p)
    A = make_mat_creuse(n,m,p)
    disp(A)
    [AA, JA, IA] = make_csr(A)
    B = undo_csr(AA, JA, IA, m)
    disp(B)
    disp(norm(B-A))
endfunction

/*
AA = [15 22 -15 11 3 2 -6 91 25 7 28 -2]
JA = [1   4   6  2 3 7  4  1  7 8  3  8]
IA = [1 4 7 8 8 11 13]
x1 = [1 1 1 1 1 1 1 1]
x2 = [1 0 0 0 1 0 0 0]

A = [15 0 0 22 0 -15 0 0 ; 0 11 3 0 0 0 2 0; 0 0 0 -6 0 0 0 0; 0 0 0 0 0 0 0 0; 91 0 0 0 0 0 25 7; 0 0 28 0 0 0 0 -2]
*/
