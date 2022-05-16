clc;
clear;
format rat;

% Input parameters
c=[2 1];
a=[1 2; 1 1; 1 -2];
b=[10;6;1];

x1=0:1:max(b);
x12=(b(1)-a(1,1).*x1)./a(1,2);
x22=(b(2)-a(2,1).*x1)./a(2,2);
x32=(b(3)-a(3,1).*x1)./a(3,2);

% Plotting graph
% plot(x1,x12,'r',x1,x22,'b',x1,x32,'g')
% legend('x12','x22','x32');

x12=max(0,x12);
x22=max(0,x22);
x32=max(0,x32);

% Z=[1 2 4 2 4 2]
% l=find(Z==2)
% T=[1 3 1 4 5 7]
% k=find(T==1)
% [Z(:,[l,k]);T(:,[l,k])]

% Corner points 
Cx1=find(x1==0);
C1=find(x12==0);
line1=[x1(:,[C1 Cx1]); x12(:,[C1 Cx1])]';

C2=find(x22==0);
line2=[x1(:,[C2 Cx1]); x22(:,[C2 Cx1])]';
C3=find(x32==0);
line3=[x1(:,[C3 Cx1]); x32(:,[C3 Cx1])]';

% Remove duplicate rows
corpt=unique([line1;line3;line3],'row');

% a1=a(1,:);
% b2=b(1,:);
% a2=a(2,:);
% b2=b(2,:);


% Intersecting points
pt=[0;0];
for i=1:size(a,1)-1
    a1=a(i,:);
    b1=b(i,:);
    for j=i+1:size(a,1)
        a2=a(j,:);
        b2=b(j,:);
        a4=[a1;a2];
        b4=[b1;b2];
        x=a4\b4;
        pt=[pt x];
    end
end

% Feasible solutions
pt=pt';
all_points=[corpt;pt];
all_points=unique(all_points,'rows');

feasible_sols=constraint(all_points)

% Compute objective function
% 2x1+1x2
for i=1:size(feasible_sols,1)
    fx(i,:)=sum(feasible_sols(i,:).*c);
end

vert_fx=[feasible_sols fx];
[fx_val,indfx]=max(fx);
opt_val=vert_fx(indfx);
opt_bfs=array2table(opt_val)

