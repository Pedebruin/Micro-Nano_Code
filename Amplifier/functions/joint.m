classdef joint < dynamicprops & matlab.mixin.Copyable
    %{
    Handle class for a joint object
    %}
    
   properties
      name;
      K = 0;
      
      x = 0;
      y = 0;
      
      color = 'k';
      floating = true;
      offset = false;
   end
   
   methods
       
   end
end