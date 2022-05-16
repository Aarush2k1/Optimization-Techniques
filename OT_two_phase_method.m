clc;
clear all;
format short;


% Min. z = 3x1 + 5x2
% x1 + 3x2 ≥ 3
% x1 + x2 ≥ 2
variables={'x1','x2','s1','s2','a1','a2','sol'};
% org_vars={'x1','x2','s1','s2','sol'};

org_cost=[-3 -5 0 0 -1 -1 0]; 
matrix=[1 3 -1 0 1 0 3;1 1 0 -1 0 1 2];
bv=[5 6];

% Phase-1
cost=[0 0 0 0 -1 -1 0];
% startbv=find(cost<0);

[BFS,A]=simplex(matrix,bv,cost,variables)

% Phase-2
% fprintf("Phase-2");
% A(:,startbv)=[]; % remove artificial vars
% org_cost(:,startbv) =[];
% % bv=[3 4];
% [opt_bfs,opt_A]=simplex(A,bv,org_cost,org_vars);

% final_bfs=zeros(1:size(A,2));
% final_bfs(opt_bfs)=opt_A(:,end);
%final_bfs(end)=sum(final_bfs.*org_cost);

function[BFS,A]=simplex(A,bv,cost,variables)
    fprintf("\nCost array: %d\n",cost);
    zj_cj=cost(bv)*A-cost;
    run=true;
    while run
        zc = zj_cj(1:end-1);
        % finding entering variable
        if any(zc<0)
            fprintf('Current BFS not optimal\n');
            [min_value, pvt_col]=min(zc);
            fprintf('Entering col: %d\n',pvt_col);

            if all(A(:,pvt_col)<=0)
                fprintf("Unbounded Region");
            else
                % leaving variable
                sol=A(:,end);
                col=A(:,pvt_col);
                ratio=zeros();
                for i =1:size(A,1)
                    if col(i)>0
                        ratio(i)=sol(i)/col(i);
                    else
                        ratio(i)=inf;
                    end
                end
                [min_ratio,pvt_row]=min(ratio);
                fprintf('Leaving Row %d\n',pvt_row);

                % Updating bv and table
                bv(pvt_row)=pvt_col;
                b=A(:,bv);
                A=inv(b)*A;
                zj_cj=cost(bv)*A-cost;
                table=array2table([zj_cj;A]);
                table.Properties.VariableNames(1:size(A,2))=variables
                BFS(bv)=A(:,end);
            end
        else
            run=false;
            fprintf("\nPhase end\n");
            BFS=bv
        end
    end
end