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

function [] = time_myldlt(n,rep)
    err = zeros(rep,1)
    time = zeros(rep,1)
    m_cond = zeros(rep,1)
    for i=1:rep
        A = rand(n, n)
        A = A*A'
        tic()
        [L,D] = myldlt(A)
        time(i) = toc()
        err(i) = norm(L*D*L' - A,2)/norm(A,2)
        m_cond(i) = cond(A)
    end
    //printf("%ld (%ld)\t& %.2le (%.2le)\t& %.2le ±%.2le (%.2le)\t& %.2le ±%.2le (%.2le) \\\\\n", n, rep, mean(m_cond), max(m_cond), mean(err), stdev(err), max(err), mean(time), stdev(time), max(time))
    printf("n : %ld\trepetition : %ld\n", n, rep)
    printf("conditionnement : %.2le\tmax : %.2le\n", mean(m_cond), max(m_cond))
    printf("erreur : %.2le ± %.2le\tmax : %.2le\n", mean(err), stdev(err), max(err))
    printf("temps : %.2le ± %.2le\tmax : %.2le\n", mean(time), stdev(time), max(time))
endfunction

function [] = plot_time_myldlt()
    n = [5:5:50, 60:10:150, 175:25:250, 300:50:500, 600:100:1000, 1500:1000:3500]
    rep = 7
    tmp_time = zeros(rep, 1)
    mean_time = zeros(size(n)(2), 1)
    stdev_time = zeros(size(n)(2), 1)
    max_time = zeros(size(n)(2), 1)
    for j=1:size(n)(2)
        for i=1:rep
            A = rand(n(j), n(j))
            A = A*A'
            tic()
            [L,D] = myldlt(A)
            tmp_time(i) = toc()
        end
        mean_time(j) = mean(tmp_time)
        stdev_time(j) = stdev(tmp_time)
        max_time(j) = max(tmp_time)
    end
    title("$Temps\ d`exécution\ LDL^t$")
    loglog(n, [mean_time, stdev_time, max_time])
    legend(['moyenne';'stdev';'max'], opt=2)
    xlabel("n")
    ylabel("temps exécution (s)")
endfunction

exec mylu3b.sci;

function [] = comp_mylu_myldlt()
    //n = [5:10:55, 60:20:160, 200:50:30, 400:100:800, 1000:200:1200]
    n = [5,10,25,50,100,200,300,500,750,1000]
    rep = 7
    tmp_time_lu = zeros(rep, 1)
    tmp_time_ldlt = zeros(rep, 1)
    tmp_err = zeros(rep, 1)
    time_ldlt = zeros(size(n)(2), 1)
    time_lu = zeros(size(n)(2), 1)
    err_max = zeros(size(n)(2), 1)
    for j=1:size(n)(2)
        for i=1:rep
            A = rand(n(j), n(j))
            A = A*A'
            tic()
            [L1,D] = myldlt(A)
            tmp_time_ldlt(i) = toc()
            tic()
            [L2,U] = mylu1b(A)
            tmp_time_lu(i) = toc()
            tmp_err(i) = norm(L1*D*L1' - L2*U)
        end
        time_ldlt(j) = mean(tmp_time_ldlt)
        time_lu(j) = mean(tmp_time_lu)
        err_max(j) = max(tmp_err)
        printf("%ld\t&\t%.2le\t&\t%.2le\t&\t%.2le\n", n(j), err_max(j), time_ldlt(j), time_lu(j))
    end
    printf("time LDLt : %.2le\n", mean(time_ldlt))
    printf("time LU : %.2le\n", mean(time_lu))
    printf("err : %.2le\n", max(err_max))
    /*title("$Temps\ d`exécution\ LDL^t$")
    loglog(n, [time_ldlt, time_lu, err_max])
    legend(['time $LDL^t$';'time LU';'erreur'], opt=2)
    xlabel("n")
    ylabel("temps exécution (s)")*/
endfunction



// R = rand(4,4)
// A = R * R'

