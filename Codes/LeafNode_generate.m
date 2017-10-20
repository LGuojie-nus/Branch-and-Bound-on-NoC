%test passed 19 OCT
% this function will be problematic when the next node has no communication
% with the mapped nodes(denominator is zero!!!)

function mapped=UBC_generate(curr_node,comm_vol,n,nn)
    %comm_demand is a matrice with descending order of comm_vol
    len=length(setdiff(curr_node,0));
    mapped=curr_node(1:len);
    unmapped=setdiff(1:n^2,mapped);
    l=nn-length(mapped);
    index=0;
    while(l)
        min_dist=2*(n-1);
        t=length(mapped);
        sum1=0.0;
        sumx=0.0;
        sumy=0.0;
        sumx2=0.0;
        sumy2=0.0;
        for k=1:t
            vol=comm_vol(k,t+1)+comm_vol(t+1,k);

            xa=(mod(mapped(k),n)==0)*n+mod(mapped(k),n);
            ya=fix((mapped(k)-1)/n)+1;
            sum1=sum1+vol;
            sumx=sumx+vol*xa;
            sumy=sumy+vol*ya;
            sumx2=sumx2+xa;
            sumy2=sumy2+ya;
        end
  
        % Improvment 
        if sum1==0   % when no communicatoin with mapped tasks
            x=sumx2/t;
            y=sumy2/t;
            
        else    
            x=sumx/sum1; %double
            y=sumy/sum1; %double
        end
        
        for k=1:length(unmapped)
            a=(mod(unmapped(k),n)==0)*n+mod(unmapped(k),n);
            b=fix((unmapped(k)-1)/n)+1;
            if (abs(x-a)+abs(y-b))<=min_dist
                min_dist=abs(x-a)+abs(y-b);
                index=(b-1)*n+a;
            end
            
        end
        mapped=[mapped,index];
        unmapped=setdiff(1:n^2,mapped);
        %update mapped and unmapped
        if length(mapped)>=length(curr_node)
            l=0;
        end
    end
 end
            
  
