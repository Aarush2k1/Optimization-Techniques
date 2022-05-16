clc
clear all
A=[3 -1 2 1 0 0;-2 4 0 0 1 0;-4 3 8 0 0 1] %converting general to std form
B=[7;12;10];
C=[1 -3 2 0 0 0];
m=size(A,1); %no of constrains
n=size(A,2); %no of variables

if n>=m
    nv=nchoosek(n,m);% total number of basic solution, nCm
    t=nchoosek(1:n,m); %pair of basic solution
    sol=[]; %default solution is set as zero
    for i=1:nv
        y=zeros(n,1);
        x=A(:,t(i,:))\B;
        if all(x>=0&x~=inf & x~=-inf)%check the feasibility condition
            y(t(i,:))=x;
            sol=[sol y];
        end 
    end
    else error('constraints are more than variables')
end

z=C*sol;
[zmax,zind]=min(z);
BFS= sol(:,zind)
opt_val=[BFS' zmax];
optimal_BFS=array2table(opt_val);
optimal_BFS.Properties.VariableNames(1:size(optimal_BFS,2))={'x_1','x_2','x_3','s_1','s_2','s_3','z'}