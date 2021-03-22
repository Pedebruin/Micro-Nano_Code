classdef link < dynamicprops
    %{
    Handle class for a link object
    %}
    
   properties
      name;
      L = 0;
      w = 1;            % Initialised width [mum] (just some guess still)
      h = 25;           % General layer height [mum] (set by process)
      
      start = 0;
      finish= 0;
      
      color = 'k';
      lineWidth = 1;
   end
   
   methods
       
   end
end