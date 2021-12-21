function [v] = csr_mv(AA, JA, IA, x)
    n = length(JA)
    v = zeros(length(IA)-1,1)
    k = 1 // ligne actuelle
    for i=1:n
        while(i == IA(k+1)) // saute les lignes nulles
            k = k + 1
        end
        v(k) = v(k) + AA(i) * x(JA(i))
    end
    if(isrow(x)) // col/row coherente avec x
        v = v'
    end
endfunction

function [A] = make_mat_creuse(n, m, pourcentage_creux)
    A = zeros(n,m)
    nbr_zeros = int(n*m*(1-pourcentage_creux))
    imax = int(nbr_zeros/m)
    jmax = modulo(nbr_zeros,m)
    A(1:imax,:) = rand(imax,m) // bloc random
    A(imax+1,1:jmax) = rand(1,jmax) // on complete ce qu'il manque
    A = grand(1, "prm", A) // random permutation de la matrice
endfunction // bien plus rapide que old_make_mat_creuse()

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

function [] = test_csr(n,m,p)
    A = make_mat_creuse(n,m,p)
    //disp(A)
    [AA, JA, IA] = make_csr(A)
    B = undo_csr(AA, JA, IA, m)
    //disp(B)
    disp(norm(B-A))
endfunction

function [] = test_csr_mv(n,m)
    x = make_mat_creuse(m,1,rand())
    A = make_mat_creuse(n,m,rand())
    [AA, JA, IA] = make_csr(A)
    y = csr_mv(AA, JA, IA, x)
    disp(norm(y - A*x))
endfunction

function [] = time_csr(n,m,rep)
    timer_csr = zeros(rep,1)
    timer_sci = zeros(rep,1)
    for i=1:rep
        p1 = 0.05 + 0.90 * rand(); p2 = 0.05 + 0.90 * rand();
        //printf("%lf ; %lf\n", p1, p2)
        x = make_mat_creuse(m,1,p1)
        A = make_mat_creuse(n,m,p2)
        [AA, JA, IA] = make_csr(A)
        tic()
        y1 = csr_mv(AA, JA, IA, x)
        timer_csr(i) = toc()
        tic()
        y2 = A*x
        timer_sci(i) = toc()
        if y2 ~=y1 then
            disp("CSR != native")
        end
    end
    printf("\\(%ld \\times %ld\\)\t&\t%.2le\t&\t%.2le\n", n, m, min(timer_csr), min(timer_sci))
endfunction

function [A] = old_make_mat_creuse(n, m, seuil_rand)
    A = zeros(n,m)
    for i = 1:n
        for j = 1:m
            if rand() > seuil_rand then
                A(i,j) = rand()
            end
        end
    end
endfunction

/*
AA = [15 22 -15 11 3 2 -6 91 25 7 28 -2]
JA = [1   4   6  2 3 7  4  1  7 8  3  8]
IA = [1 4 7 8 8 11 13]
x1 = [1 1 1 1 1 1 1 1]
x2 = [1 0 0 0 1 0 0 0]

A = [15 0 0 22 0 -15 0 0 ; 0 11 3 0 0 0 2 0; 0 0 0 -6 0 0 0 0; 0 0 0 0 0 0 0 0; 91 0 0 0 0 0 25 7; 0 0 28 0 0 0 0 -2]
*/
