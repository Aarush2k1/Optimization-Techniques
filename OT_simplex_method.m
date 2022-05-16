clc;
clear all;
format short;

% C = [-1 3 -3];
% a = [3 -1  1; -1 2 0; -1 3 8];
% b = [7;6;10];
C=[-1 3 -3];
a=[3 -1 1;-1 2 0;-4 3 8]
b=[7;6;10];
n=size(a,2);
s=eye(size(a,1));
% Matrix
A=[a s b]

cost=zeros(1,size(A,2));
cost(1:n)=C;
bv = n+1: size(A,2)-1;
zj_cj = cost(bv)*A - cost;
ratio=zeros();
run=true;
table=array2table(A)

while run
    zc = zj_cj(1:end-1);
    % entering variable
    if any(zc<0)
        [minvalue, pvt_col]=min(zc);
        if all(A(:,pvt_col)<=0)
            disp("Unbounded Region");
        else
            % leaving variable
            sol=A(:,end);
            col=A(:,pvt_col);
            for i=1:size(A,1)
                if col(i)>0
                    ratio(i)=sol(i)/col(i);
                else
                    ratio(i)=inf;
                end
            end
            [min_ratio,pvt_row]=min(ratio);

        end
%         Updating table and bv
         bv(pvt_row)=pvt_col;
         b=A(:,bv);
         A=b\A;
         zj_cj=cost(bv)*A-cost;
         Zcj=[zj_cj;A];
         table=array2table(Zcj)
        % Row operations
%         bv(pvt_row)=pvt_col
%         pvt_key = A(pvt_row,pvt_col)
%         A(pvt_row,:)=A(pvt_row,:)/pvt_key;
%         for i= 1:size(A,1)
%             if i~=pvt_row
%                 A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
%             end
%         end
%         zj_cj = zj_cj-zj_cj(pvt_col).*A(pvt_row,:);
    else
        run=false;
        display(A);
        fprintf('Optimal Sol is ');
        display(zc);
    end
end
final_bfs=zeros(1,size(A,2));
final_bfs(bv)=A(:,end);
final_bfs(end)=sum(final_bfs.*cost)