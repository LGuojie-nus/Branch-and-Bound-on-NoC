%test passed 18/Oct
%modified 28/Oct
function distance=minimal_dis_mu(curr_node_mm,a,n)
    distance=2*(n-1);
    curr_node_uu=setdiff(1:n^2,curr_node_mm);
    ya=fix((curr_node_mm(a)-1)/n)+1;
    xa=(mod(curr_node_mm(a),n)==0)*n+mod(curr_node_mm(a),n);
    for b=1:length(curr_node_uu) 
        yb=fix((curr_node_uu(b)-1)/n)+1;
        xb=(mod(curr_node_uu(b),n)==0)*n+mod(curr_node_uu(b),n);
        d=(abs(xa-xb)+abs(ya-yb));
        if d==1
            distance=1;
            break;
        end
        if d<distance
            distance=d;
        end
    end
    
end