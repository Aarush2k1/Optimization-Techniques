clc;
format short;

f=@(x) (x<0.5).*((1-x)./2)+(x>=0.5).*(x.^2);
% f=@(x) (x.^2);
l=-1;
r=1;
n=6;
t=linspace(l,r,100);
plot(t,f(t));

fib=ones(1,n);  
for i=3:n+1
    fib(i)=fib(i-1)+fib(i-2);
end
fib
for k=1:n
    ratio=fib(n+1-k)./fib(n+2-k);
    x2=l+ratio.*(r-l);
    x1=l+r-x2;
    fx1=f(x1);
    fx2=f(x2);
    
    rs1(k,:)=[l r x1 x2 fx1 fx2];
    if fx1<fx2
        r=x2;
    elseif fx1>fx2
        l=x1;
    elseif fx1==fx2
        if min(abs(x1),abs(l))==abs(l)
            r=x2;
        else
            l=x1;
        end
    end
end
rs1(k,:)=[l r x1 x2 fx1 fx2];
vars={'L','R','x1','x2','fx1','fx2'};
result=array2table(rs1);
result.Properties.VariableNames(1:size(result,2))=vars

opt=(l+r)/2;
fprintf('\nOptimal value: %d\n',f(opt));
