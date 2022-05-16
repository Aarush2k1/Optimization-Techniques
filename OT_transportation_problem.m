clc;
format short;

c=[2 1 4;6 3 2;4 12 3];
s=[10 15 20];
d=[13 18 14];
if sum(s)==sum(d)
    fprintf('Balanced\n');
else
    fprintf('Unbalanced\n');
    diff=abs(sum(s)-sum(d));

  if sum(s)<sum(d)
    c(end+1,:)=zeros(1,size(c,2));
    s(:,end+1)=diff;
  else  
      c(:,end+1)=zeros(1,size(c,1));
      d(:,end+1)=diff;
  end
end

x=zeros(size(c));
initial_cost=c;

for i=1:size(c,1)
    for j=1:size(c,2)
        cpq=min(c(:));
        if cpq==inf
            break
        end
        [p1,q1]=find(cpq==c);
        Xpq=min(s(p1),d(q1));
        [value,index]=max(Xpq);
        x(p1(index),q1(index))=value;
        p=p1(index);
        q=q1(index);
        s(p)=s(p)-value;
        d(q)=d(q)-value;
        if s(p)==0
            c(p,:)=inf;
        else
            c(:,q)=inf;
        end
    end
end
disp(x);
cost=sum(sum(x.*initial_cost));
fprintf("least cost id %d\n",cost);
