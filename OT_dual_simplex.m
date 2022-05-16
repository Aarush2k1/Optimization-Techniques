%DUAL SIMPLEX

clc
clear all
noofvariables = 2

a= [-3 -5; -5 -2]
b= [-5; -3]
c= [-15 -10]

s= eye(size(a,1)) %size of rows

A =[a s b]
Cost = zeros(1,size(A,2)) 
Cost(1:noofvariables) = c

bv= noofvariables+1:size(A,2)-1
ZjCj= Cost(bv)*A- Cost
run= true
while run
    alast= A(:,end)
    if any(alast<0)
        [LeaveRow, pvt_row] = min(alast)
        if all(A(pvt_row,1:end-1)>=0)
            fprintf("Unbounded Solution")
            run= false
        else
            zc= ZjCj(1:end-1)
            Row= A(pvt_row,1:end-1)
            
            for i=1:size(A,2)-1
                if(Row(i)>=0)
                    ratio(i)= inf
                else
                    ratio(i)= zc(i)/Row(i)
                end
            end
            [EnterCol, pvt_col] = min(abs(ratio))
            pvt_key= A(pvt_row, pvt_col)
            bv(pvt_row)= pvt_col
            A(pvt_row,:) = A(pvt_row,:)./pvt_key
            for i=1:size(A,1)
                if i~=pvt_row
                    A(i,:)= A(i,:)- A(i,pvt_col).*A(pvt_row, :)
                end
            end
            ZjCj= ZjCj - ZjCj(pvt_col).*A(pvt_row,:)
        end
        
        
    else
        fprintf("Solution reached")
        run= false
    end
end