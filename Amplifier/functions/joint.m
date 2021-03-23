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
      
      children;
   end
   
   methods
       
   end
end