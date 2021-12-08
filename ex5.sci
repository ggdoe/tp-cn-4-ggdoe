function [v] = dotcsr(AA, JA, IA, x)
    n = size(x)(1)
    v = zeros(x)
    k = 1
    for i=1:n
        v(k) = v(k) + AA(JA(i)) * x(JA(i))
        if(i+1 == IA(k+1))
            k = k + 1
        end
    end
endfunction

/*
AA = [15 22 -15 11 3 2 -6 91 25 7 28 -2]
JA = [1 4 6 2 3 7 4 1 7 8 3 8]
IA = [1 4 7 8 8 11 13]
x1 = [1 1 1 1 1 1 1 1]
x2 = [1 0 0 1 0 0 1 0]
*/
