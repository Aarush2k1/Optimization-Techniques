clc;
% clear all;
format short;
M=1000;

% min 2x1+x2
% 3x1+x2=3
% 4x1+3x2>=6
% x1+2x2<=3
% variables={'x1','x2','s2','s3','a1','a2','sol'};
% cost=[-2 -1 0 0 -M -M 0];
% b=[3;6;3];
% A=[3 1 0 0 1 0;4 3 -1 0 0 1;1 2 0 1 0 0];
% A=[A,b]

variables={'x1','x2','s1','s2','a1','sol'};
cost=[-3 4 0 0 -M 0];
b=[0;2];
A=[-1 1 1 0 0;2 -1 0 -1 1];
A=[A b]

s=eye(size(A,1));
bv=[];
for i=1:size(s,2)
    for j=1:size(A,2)
        if A(:,j)==s(:,i)
            bv=[bv j];
        end
    end
end
b=A(:,bv);
A=b\A;
zj_cj=cost(bv)*A-cost;
Zcj=[zj_cj;A];
table=array2table(Zcj);
table.Properties.VariableNames(1:size(Zcj,2))=variables

run=true;

% Simplex Method
while run
    zc = zj_cj(1:end-1);
    % finding entering variable
    if any(zc<0)
        fprintf('Current BFS not optimal\n');
        [minvalue, pvt_col]=min(zc);
        fprintf('Entering col: %d\n',pvt_col);
        if all(A(:,pvt_col)<=0)
            error("Unbounded Region");
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
            pvt_key = A(pvt_row,pvt_col);
            
            A(pvt_row,:)=A(pvt_row,:)/pvt_key;
            for i= 1:size(A,1)
                if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
                end
            end
            zj_cj = zj_cj-zj_cj(pvt_col).*A(pvt_row,:);
        end
    else
        run=false;
        fprintf("\nCurennt BFS is optimal\n");
        disp(A);
        disp(zc);
    end
end
final_bfs=zeros(1,size(A,2));
final_bfs(bv)=A(:,end);
final_bfs(end)=sum(final_bfs.*cost);
final_table=array2table(final_bfs);
final_table.Properties.VariableNames(1:size(final_table,2))=variables