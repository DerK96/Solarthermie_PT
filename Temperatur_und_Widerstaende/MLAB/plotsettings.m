set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultLegendInterpreter','latex');
set(0, 'defaultColorbarTickLabelInterpreter','latex');
set(0, 'defaultTextInterpreter','latex');
set(0, 'DefaultFigureRenderer', 'painters');
set(0, 'DefaultFigureRendererMode','manual');
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gca,'-property','FontSize'),'FontSize',10)