%edited on 7 Nov
%size of tile, n*n squre 
n=3;
nn=n^2;
%number of tasks
nt=9;
threshold=(nn*nt)^1.4;
%node format: [LBC UBC x x x x...x];
%initial format:[inf inf 0 0 0 0...0];
root_node=zeros(1,nt+2);
root_node(1)=-inf;
root_node(2)=inf;

[Index,comm_dem]=CTG_sort(comm_vol,nt);
best_mapping_cost=inf;
min_UBC=inf;
PQueue=PQ(root_node);
count_prune=0;
count_entry=0;
count_level=0;
copy_curr_node=root_node;
child_node=root_node;  % a lot time will be consumped for array creation!
count1=0;
previous_cnt_prune=0;
previous_cnt_entry=0;
count_best=0;

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %                                              *INPUT PANEL*
 %                                          
 %                                           *SYMMETRY CHECK*
 
 %0: no symmetry check 
 %1: Level 1 
 %2: Level 2 
level=2;     

%                                        *INSERTION STRATEGY*
%'Off' to cancel insertion Strategy
Insertion_Strategy='Off';

%                                             *Manual Termination*
%'Off' to cancel Termination Strategy                       
Manual_Termination='Off';
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 tic

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                               symmetry check LEVEL 1
if level~=0
    curr_node=PQueue.Next();
    for x1=1:int16(n/2)
            for y1=1:x1
                curr_node(3)=x1+(y1-1)*n;
                if level==2
                    if x1==y1
                        for y2=1:n
                            for x2=y2:n
                                if x2==x1 && y2==y1
                                    continue;
                                else
                                    curr_node(4)=x2+(y2-1)*n;
                                    curr_node(2)=Cost(curr_node(3:end),comm_dem,n,nt,'UBC');
                                    PQueue.Insert(curr_node);
                                end
                            end
                        end
                    else
                        for m=1:n^2
                            if curr_node(3)~=m
                                curr_node(4)=m;
                                curr_node(2)=Cost(curr_node(3:end),comm_dem,n,nt,'UBC');
                                PQueue.Insert(curr_node);
                            end
                        end
                    end

                else
                curr_node(2)=Cost(curr_node(3:end),comm_dem,n,nt,'UBC');
                PQueue.Insert(curr_node);
                end
            end
    end

PQueue.Sort();
end
%%
while(PQueue.Empty()==0)
    curr_node=PQueue.Next();
    %find current task mapping position
    len=find(curr_node);
    curr_pos=length(len)+1;
    mapped=curr_node(3:length(len));
    unmapped=setdiff(1:n^2,mapped);
    %select from unmapped tile and map it to curr_task_pos
    len_unmap=n^2-curr_pos+1+2;
    best_UBC=inf;
    

    for k=1:len_unmap
        curr_node(curr_pos)=unmapped(k);   
      
        count_entry=count_entry+1;
        curr_node(1)=Cost(curr_node(3:nt+2),comm_dem,n,nt,'LBC');
        %
        %check min_UBC
        if curr_node(1)>min_UBC
            count_prune=count_prune+1;
            %disp(curr_node);
            %count_level=count_level+curr_pos-2;
            continue;         
        end
        
        
        %check leafNode
        if curr_node(nt+2) || (curr_node(1)==curr_node(2))   % DEVELOPMENT 
            if curr_node(1)<best_mapping_cost
                %disp(best_mapping_cost);
                %disp([curr_node(1),count_entry,count_prune]);
                %count_best=count_best+1;               
                %previous_cnt_prune=count_prune;
                previous_cnt_entry=count_entry;
                
                %previous_entry=count_entry;
                %previous_best=best_mapping_cost;
                best_mapping_cost=curr_node(1);
                
                best_mapping=curr_node;
%                 if count_entry/count_best>termin_criter(level)
%                     
%                 end
            else
                count_prune=count_prune+1;
            end
            
            
        else
            curr_node(2)=Cost(curr_node(3:end),comm_dem,n,nt,'UBC');
                
            
            if(curr_node(2)<min_UBC)
                min_UBC=curr_node(2);
                %disp('curr_best');
                %disp(curr_node);
                PQueue.Insert(curr_node);
                
                PQueue.Sort();
                    
            else 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%% *Insertion Strategy(Nodes Control Strategy)* %%%%%%%%%%%%%
 
                if strcmp(Insertion_Strategy,'On') && PQueue.Size()>nn^2/2                      % DEVELOPMENT 
                    
                    copy_unmapped=unmapped;
                    copy_unmapped(k)=[];
                    copy_curr_node=curr_node;
                    size_copy=size(copy_unmapped);
                    for loopk=1:size_copy(2)                 
                        copy_curr_node(curr_pos+1)=copy_unmapped(loopk);
                        Child_UBC=Cost(copy_curr_node(3:end),comm_dem,n,nt,'UBC');
                        if Child_UBC<best_UBC
                            best_UBC=Child_UBC;
                            child_node=copy_curr_node;
                        end
                    end
                    PQueue.Insert(child_node);
                    
                    PQueue.Sort();
                    
                else
                    PQueue.Insert(curr_node);
                    
                    PQueue.Sort();
                    
                end                
            end               
        end
            
    end
  %  disp([double((count_prune)/(count_entry)),count_entry-previous_cnt_entry]);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%                                   termination Strategy
%  

    if strcmp(Manual_Termination,'On') && ((count_entry-previous_cnt_entry)>threshold)
        disp('manual termination')    	
        break;
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end

%%
disp('program ends!');
elapsedtime=toc;
best_mapping(2)=best_mapping(1);
best_mapping(3:end)=LeafNode_generate(best_mapping(3:end),comm_dem,n,nt);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%                               results
disp('############################################');
disp('############################################');
disp('Running Report');
disp(['no. of tasks=',num2str(nt),'  n=',num2str(n)]);
disp(['Symmetry Check level=',num2str(level)]);
disp(['Insertion_Strategy=',Insertion_Strategy]);
disp(['Manual_Termination=',Manual_Termination,'  Threshold=',num2str(threshold)]);
disp(['Best Mapping Cost=  ',num2str(best_mapping_cost)]);
disp(['Best Mapping(Tile)= ',num2str(best_mapping(3:end))]);
disp(['Best Mapping(Task)= ',num2str(Index)]);
XY=['nodes visited ',num2str(count_entry)];
YZ=['nodes pruned ',num2str(count_prune)];
disp(XY);
disp(YZ);
disp(['running time ',num2str(elapsedtime),' sec']);
disp('############################################');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
