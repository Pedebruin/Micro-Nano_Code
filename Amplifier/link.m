classdef link < dynamicprops
    %{
    Handle class for a link object
    %}
    
   properties
      L = 0;
      w = 1;            % Initialised width [mum] (just some guess still)
      h = 25;           % General layer height [mum] (set by process)
      
      x = 0;
      y = 0;
      
      color = 'k';
      lineWidth = 1;
   end
   
   methods
       
   end
end