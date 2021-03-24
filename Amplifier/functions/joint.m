classdef joint < dynamicprops & matlab.mixin.Copyable
    %{
    Handle class for a joint object
    %}
    
   properties
      name;
      k = 0;        % Stifness of the joint
      
      x;            % x position of the joint
      y;            % y position of the joint
      
      x_init;
      y_init;
      
      color;        % Plot color
      floating = true;  % Is it floating or fixed?
      offset = false;   % Is its position now offset, or not?
      mirrorOffset = false; % Offset for mirroring?
      
      children;
   end
   
   methods
       function rotate(obj,rot)
        R = [cos(rot), sin(rot); 
             -sin(rot), cos(rot)];
        pos = [obj.x obj.y]*R;
        obj.x = pos(1);
        obj.y = pos(2);   
       end
       
       function translate(obj,trans)
           obj.x = obj.x + trans(1);
           ,obj.y = obj.y + trans(2);
       end
   end
end