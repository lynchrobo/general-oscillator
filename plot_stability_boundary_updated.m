

wn = 150;
% wn_arr = linspace(1,1000,10);

r3  = 20;
kap = linspace(0.01,0.99,10);
% k = 0.2;
clf
f = gcf
set(f,"Renderer",'painters')
set(f,"Color","k")
hold on

cmap_full   = colormap('cool')
cmap        = cmap_full(round(linspace(1,256,10)),:);
cc = 1;

for k = kap
% for wn = wn_arr

    r3 = linspace(0,5*wn,100);

    y = (k*r3.^2 - wn^2).*(1-k)*k^(k/(1-k));
   
    
    plot(r3./wn,y,'Color',cmap(cc,:),'DisplayName',sprintf("kappa = %1.2f",k),'LineWidth',2)
%     plot(r3./wn,y,'Color',cmap(cc,:),'DisplayName',sprintf("w_n = %1.2f",wn),'LineWidth',2)
    set(gca,"Color",'k','ycol','w','xcol','w')
    
    drawnow
%     pause()

    cc = cc+1;
end
yline(0,'w','HandleVisibility','off')
grid on
% scatter(1/sqrt(0.2),0,1000,"r.","MarkerFaceAlpha",0,"DisplayName","intercept")
legend([],'Location','northwest','TextColor','w')
xlabel('$r_3/ w_n$','Color','w','Interpreter','latex','FontSize',20)
ylabel('$\frac{F_o}{ILT}$','Color','w','FontSize',20,'Interpreter','latex','Rotation',90)


