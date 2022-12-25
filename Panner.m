classdef Panner < AxesTool
    properties
        user_action_triggers = ["WindowButtonDownFcn", "obj.startPan(obj.mousePosition())",...
            "WindowButtonUpFcn", "obj.endPan()", ...
            "WindowButtonMotionFcn", "obj.pan(obj.mousePosition())"]
        pan_position
        pan_active
    end
    
    methods
        function obj = Panner(axes)
            obj@AxesTool(axes)
        end
        
        function startPan(obj, start_position)
            obj.pan_active = true;
            obj.pan_position = start_position;
        end

        function endPan(obj)
            obj.pan_position = NaN;
            obj.pan_active = false;
        end

        function pan(obj, current_position)
            if obj.pan_active
                obj.axes.XLim = obj.axes.XLim + obj.pan_position(1) - current_position(1);
                obj.axes.YLim = obj.axes.YLim + obj.pan_position(2) - current_position(2);
            end
        end
    end
end