#mpTSQR3, change condition number
include("mpTSQR.jl")
include("genmat.jl")
using DelimitedFiles, Printf

name = "D2"
l = Float16; h=Float32; d=Float64;
m = 8192; n = 256;
trials = 10;
cs = exp10.(range(0, stop=2, length=9));
berr = zeros(d, length(cs), trials);
ferr = zeros(d, length(cs), trials);
L = 2;
writedlm("../txtfiles/"*name*"b.txt", ["mpBQR: backward error"])
writedlm("../txtfiles/"*name*"f.txt", ["mpBQR: forward error"])
for t = 1 : trials
	@printf("\n%d: ",t)
	for (i,c) in enumerate(cs)
       @printf("%d\t",i)
        A = genmat(m,n,c,l);
        Ad = Matrix{d}(A);

        # Block mixed precision
        Q, R = mpTSQR(A, L);
        berr[i,t] = norm(Matrix{d}(Q)*Matrix{d}(R)-Ad,2)/norm(Ad)
        ferr[i,t] = norm(Matrix{d}(Q')*Matrix{d}(Q)-I,2)
    end

    open("../txtfiles/"*name*"b.txt", "a") do io
        writedlm(io, [berr[:, t]'])
    end
    open("../txtfiles/"*name*"f.txt", "a") do io
        writedlm(io, [ferr[:, t]'])
    end
end