clc;
clear;
close all;

x = [0:.1:2*pi];
y = sin(x);

fig = uifigure;
ax = uiaxes(fig);
plot(ax, x, y, 'b');

tb = AxesToolbar(ax, ["Eraser", "Panner", "Zoomer", "BrushSelector", "DragboxSelector"]);

set(fig, 'WindowButtonUpFcn', {@tb.userAction, "WindowButtonUpFcn"});
set(ax, 'ButtonDownFcn', {@tb.userAction, "ButtonDownFcn"});
set(fig, 'WindowButtonMotionFcn', {@tb.userAction, "WindowButtonMotionFcn"});
set(fig, 'WindowScrollWheelFcn', {@tb.userAction, "WindowScrollWheelFcn"});
set(fig, 'WindowButtonDownFcn', {@tb.userAction, "WindowButtonDownFcn"});

tb.enable("Eraser", "Zoomer");

bs = tb.getTool("BrushSelector");