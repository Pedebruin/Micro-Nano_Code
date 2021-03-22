classdef joint < dynamicprops
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
   end
   
   methods
       
   end
end