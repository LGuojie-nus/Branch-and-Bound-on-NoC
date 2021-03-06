% test passed 18/OCT
%modified 28/Oct
function distance=minimal_dis_uu(curr_node_uu,n)
    dist=2*(n-1);
    for a=1:length(curr_node_uu)
        for b=a+1:length(curr_node_uu)
            ya=fix((curr_node_uu(a)-1)/n)+1;
            xa=(mod(curr_node_uu(a),n)==0)*n+mod(curr_node_uu(a),n);
            
            yb=fix((curr_node_uu(b)-1)/n)+1;
            xb=(mod(curr_node_uu(b),n)==0)*n+mod(curr_node_uu(b),n);
            d=(abs(xa-xb)+abs(ya-yb));

            if d==1
                distance=1;
                break;
            end
            if d<=dist
                distance=d;
                dist=d;
            end
        end
        if d==1
            break;
        end
    end
end