classdef AxesToolbar < handle
    
    properties
        axes
        tools = {}
        enabled_tools = {}
    end
    
    methods
        function obj = AxesToolbar(axes, tool_names)
            obj.axes = axes;
            hold(axes, "on")

            obj.add(tool_names);
        end

        function add(obj, varargin)
            tool_names = AxesToolbar.formatTextInput(varargin);
            
            % Dont allow creation two of the same tool
            if ismember(tool_names, AxesToolbar.classes(obj.tools))
                return;
            end

            for i = 1:length(tool_names)
                try
                    newtool = feval(tool_names(i), obj.axes);
                    if ~isa(newtool, "AxesTool")
                        warning("The class " + tool_names(i) + " is not an axestool.");
                        return;
                    end
                    obj.tools{end + 1} = newtool;
                catch ME
                    switch ME.identifier
                        case 'MATLAB:UndefinedFunction'
                            warning("No class " + tool_names(i) + " found.");
                        case 'MATLAB:scriptNotAFunction'
                            warning('Attempting to execute script as function');
                        otherwise
                            rethrow(ME)
                    end
                end
            end
        end

        function tool = getTool(obj, tool_name)
            for i = 1:length(obj.tools)
                if isequal(class(obj.tools{i}), tool_name)
                    tool = obj.tools{i};
                    return;
                end
            end
            tool = NaN;
        end

        function remove(obj, varargin)
            target_tools = formatTextInput(varargin);

            obj.tools = obj.tools{~ismember(classes(obj.tools), target_tools)};
            obj.enabled_tools = obj.enabled_tools{~ismember(classes(obj.enabled_tools), target_tools)};
        end
        
        function enable(obj, varargin)
            target_tools = AxesToolbar.formatTextInput(varargin);
            available_tools = AxesToolbar.classes(obj.tools);

            inds = ismember(available_tools, target_tools);
            if any(inds)
                obj.enabled_tools = obj.tools(inds);
            else
                obj.enabled_tools = {};
            end
        end

        % Call interactions for enabled tools
        function userAction(obj, interact_object, event_data, callback_name)
            for i = 1:length(obj.enabled_tools)
                obj.enabled_tools{i}.userAction(interact_object, event_data, callback_name);
            end
        end
    end

    methods(Static)
        function text = formatTextInput(text)
            text = convertCharsToStrings(text);
            
            if isa(text, "cell")
                text = [text{:}];
            end
        end

        function class_array = classes(obj_array)
            class_array = strings(1, length(obj_array));
            for i = 1:length(obj_array)
                class_array(i) = class(obj_array{i});
            end
        end
    end
end

