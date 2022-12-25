classdef DragboxSelector < Selector
    properties
        user_action_triggers = ["WindowButtonDownFcn", "obj.startDragboxSelection(obj.mousePosition())",...
            "WindowButtonUpFcn", "obj.endDragboxSelection", "WindowButtonMotionFcn", ...
            "obj.updateDragboxSelection(obj.mousePosition())"]
        selection
        
        box_container = UniformGraphicsContainer({'Color', 'b', 'LineWidth', .5, 'Tag', 'selectionUI'})
        
        drag_selection_active
        drag_selection_start
        drag_selection_current
    end
    
    methods (Access = public)
        function obj = DragboxSelector(axes)
            obj@Selector(axes);
            obj.drag_selection_start = NaN;
            obj.drag_selection_active = false;
        end
        
        function startDragboxSelection(obj, position)
            obj.drag_selection_start = position;
            obj.drag_selection_active = true;
            obj.clearSelection();
        end
        
        function endDragboxSelection(obj, varargin)
            obj.drag_selection_start = NaN;
            obj.drag_selection_active = false;
            obj.box_container.deleteAll();
        end
        
        function updateDragboxSelection(obj, position)
            if obj.drag_selection_active
                obj.drag_selection_current = position;
                
                obj.clearSelection();
                obj.box_container.deleteAll();
                
                obj.drawSelectionBox(obj.drag_selection_start, obj.drag_selection_current)
                obj.selectPointsInDragbox();
            end
        end

        % Create a new line for each set of adjacent points
        function selectPointsInDragbox(obj)
            selectable = obj.selectable();
            
            xbounds = sort([obj.drag_selection_start(1), obj.drag_selection_current(1)]);
            ybounds = sort([obj.drag_selection_start(2), obj.drag_selection_current(2)]);
            
            for i = 1:length(selectable)
                x = selectable(i).XData;
                y = selectable(i).YData;
                idx = x > xbounds(1) & x < xbounds(2) & y > ybounds(1) & y < ybounds(2);
                
                obj.select(selectable, x(idx), y(idx));
            end
        end
        
        function drawSelectionBox(obj, from_point, to_point)
            plot_vectors = {...
                {[from_point(1) to_point(1)], [from_point(2) from_point(2)]},...
                {[from_point(1) to_point(1)], [to_point(2) to_point(2)]},...
                {[from_point(1) from_point(1)], [from_point(2) to_point(2)]},...
                {[to_point(1) to_point(1)], [from_point(2) to_point(2)]}};
            
            for i = 1:length(plot_vectors)
                obj.box_container.addGraphic(obj.axes, plot_vectors{i}{1}, plot_vectors{i}{2});
            end
        end
    end
end