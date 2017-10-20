%test passed
function [index,comm_vol_new]=CTG_sort(comm_vol,nn) %n=n^2
    %sort comm in descending order
    comm_dem=zeros(1,nn);
    index=zeros(1,nn);
    comm_vol_new=zeros(nn);
    for x=1:nn
        comm_dem(x)=sum(comm_vol(x,:),2)+sum(comm_vol(:,x),1);
    end
    %index stores the mapping from original comm_vol to sorted comm_dem
   [~,index]=sort(comm_dem,'descend');
    comm_dem=index;
    %disp(comm_dem)
    for x=1:nn
        for y=1:nn
            comm_vol_new(x,y)=comm_vol(comm_dem(x),comm_dem(y));       
        end
    end
end