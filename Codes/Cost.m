%test passed 10 OCT
function cost_=Cost(curr_node,comm_vol,n,nt,mode)
    %energy coefficent: J/unit distance
    cost_mm=0;
    cost_mu=0;
    cost_uu=0;
    cost_ubc=0;
    len=length(setdiff(curr_node,0));
    curr_node_mm=curr_node(1:len);
    curr_node_uu=setdiff(1:n^2,curr_node_mm);
    s=length(curr_node_mm);
    len1=length(curr_node_mm);
    %len2=length(curr_node_uu);
    if (strcmp(mode,'LBC') || strcmp(mode,'mm')) && len1>=2 %
        for a=1:len1
            for b=a+1:len1
                xa=(mod(curr_node(a),n)==0)*n+mod(curr_node(a),n);
                ya=fix((curr_node(a)-1)/n)+1;
                xb=(mod(curr_node(b),n)==0)*n+mod(curr_node(b),n);
                yb=fix((curr_node(b)-1)/n)+1;
                e1=(abs(xa-xb)+abs(ya-yb));
                cost_mm=cost_mm+e1*(comm_vol(a,b)+comm_vol(b,a));
            end
        end
    end
    
    if  strcmp(mode,'LBC') && nt-len1>=2%|| strcmp(mode,'uu') 
       
        
            e2=minimal_dis_uu(curr_node_uu,n);
            for a=1:nt-len1
                for b=a+1:nt-len1
                    cost_uu=cost_uu+e2*(comm_vol(a+s,b+s)+comm_vol(b+s,a+s));
                end
            end
    end
    
    
    if strcmp(mode,'LBC') %|| (strcmp(mode,'mu')
        for a=1:len1
            e3=minimal_dis_mu(curr_node_mm,a,n);
            for b=1:nt-len1
                cost_mu=cost_mu+e3*(comm_vol(a,b+s)+comm_vol(b+s,a));    
            end
        end
    end
    if strcmp(mode,'UBC')
        curr_nodes=LeafNode_generate(curr_node,comm_vol,n,nt);
        cost_ubc=Cost(curr_nodes,comm_vol,n,nt,'mm');
    end
    cost_=cost_mm+cost_mu+cost_uu+cost_ubc;    
    
end
    
    
