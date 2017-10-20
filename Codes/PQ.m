%PQueue
classdef PQ < handle
   properties
      % Assign current date and time
      Node=[];
   end
   properties
      LBC_position=1;
      UBC_Position=2;
   end 
   methods
       function obj=PQ(node)
           obj.Node=node;
       end
       %Empty
       function r=Empty(obj)
           [a,~]=size(obj.Node);
           if a==0
               r=1;
           else
               r=0;
           end
       end
       
       function Insert(obj,node)
            obj.Node=[node;obj.Node];
       end
       
       function next_node=Next(obj)
          next_node=obj.Node(1,:);
          obj.Node(1,:)=[];
       end
       
       function Sort(obj)
          obj.Node=sortrows(obj.Node,2);
       end
       function obj_size=Size(obj)
           SIZE=size(obj.Node);
           obj_size=SIZE(1);
       end
   end
end
