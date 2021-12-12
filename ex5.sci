function [v] = dotcsr(AA, JA, IA, x)
    n = length(JA)
    v = zeros(length(IA)-1,1)
    k = IA(1)+1
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

/*
AA = [15 22 -15 11 3 2 -6 91 25 7 28 -2]
JA = [1 4 6 2 3 7 4 1 7 8 3 8]
IA = [1 4 7 8 8 11 13]
x1 = [1 1 1 1 1 1 1 1]
x2 = [1 0 0 1 0 0 1 0]

A = [15 0 0 22 0 -15 0 0 ; 0 11 3 0 0 0 2 0; 0 0 0 -6 0 0 0 0; 0 0 0 0 0 0 0 0; 91 0 0 0 0 0 25 7; 0 0 28 0 0 0 0 -2]
*/
