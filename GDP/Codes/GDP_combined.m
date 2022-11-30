clc;
clear vars;

load India_GDP_Trade.txt
load US_GDP.txt
load US_Trade.txt

aGdpInd=0.080;
aGdpUs=0.080;

kGdpInd=6*1e12;
kGdpUs=30*1e12;

aTradeInd=0.100;
aTradeUs=0.099;

kTradeInd=3*1e12;
kTradeUs=10*1e12;

alphaInd=0.6;
alphaUs=0.75;

gdpInd=LogisticEqn(aGdpInd,kGdpInd,3.7*1e10);
gdpUs=LogisticEqn(aGdpUs,kGdpUs,5.43*1e11);

tradeInd=LogisticEqn(aTradeInd,kTradeInd,4.18*1e9);
tradeUs=LogisticEqn(aTradeUs,kTradeUs,4.98*1e10);

gdpVsTradeInd=PowerLaw(tradeInd,alphaInd);
gdpVsTradeUs=PowerLaw(tradeUs,alphaUs);


dataInd=India_GDP_Trade;
dataIndGdp=zeros(1,60);
dataIndTrade=zeros(1,60);
for i = 1:60
    dataIndGdp(i)=dataInd(i,2);
    dataIndTrade(i)=dataInd(i,3);
end

dataUsGdpFile=US_GDP;
dataUsTradeFile=US_Trade;
dataUsGdp=zeros(1,60);
dataUsTrade=zeros(1,60);
for i = 1:60
    dataUsGdp(i)=dataUsGdpFile(i,2);
    dataUsTrade(i)=dataUsTradeFile(i,2);
end

t=(1960:1:2019);
figure(1);
semilogy(t,tradeInd,'r',t,dataIndTrade,'r.',t,gdpInd,'b',t,dataIndGdp,'b.');
legend('Trade-analytical','Trade-real data','GDP-analytical','Gdp-real data');
legend('location','southeast');
grid on;
xlabel('Year')
ylabel('USD')
title('India')
saveas(gcf,'India - Trade and GDP.jpg', 'jpg')

figure(2);
semilogy(t,tradeUs,'r',t,dataUsTrade,'r.',t,gdpUs,'b',t,dataUsGdp,'b.');
legend('Trade-analytical','Trade-real data','GDP-analytical','GDP-real data');
legend('location','southeast');
grid on;
xlabel('Year')
ylabel('USD')
title('USA')
saveas(gcf,'USA - Trade and GDP.jpg', 'jpg')

figure(3)
loglog(tradeInd,gdpInd,'b',dataIndTrade,dataIndGdp,'.');
legend('analytical','real data');
legend('location','southeast');
grid on;
xlabel('Trade in USD')
ylabel('GDP in USD')
title('India - Trade vs GDP')
xlim([4e9,1e12]);
saveas(gcf,'India - Trade vs GDP.jpg', 'jpg')

figure(4)
loglog(tradeUs,gdpUs,'b',dataUsTrade,dataUsGdp,'.');
legend('analytical','real data');
legend('location','southeast');
grid on;
xlabel('Trade in USD')
ylabel('GDP in USD')
title('USA - Trade vs GDP')
xlim([4e10,8e12]);
saveas(gcf,'USA - Trade vs GDP.jpg', 'jpg')

%constUs=dataUsGdp(1)/gdpUs(1);
%constUs=6e3
%gdpVsTradeUs=constUs*gdpVsTradeUs;
figure(5)
loglog(tradeUs,gdpVsTradeUs,'b',dataUsTrade,dataUsGdp,'r');
legend('analytical','real data','location','east');
grid on;
xlabel('Trade in USD')
ylabel('GDP as a function of trade')
title('USA - Trade vs GDP')
%xlim([4e10,8e12]);
saveas(gcf,'USA - Trade vs GDP actual.jpg', 'jpg')

%constInd=dataIndTrade(1)/gdpVsTradeInd(1);
%constInd=1e5
%gdpVsTradeInd=constInd*gdpVsTradeInd;
figure(6)
loglog(tradeInd,gdpVsTradeInd,'b',dataIndTrade,dataIndGdp,'r');
legend('location','east');
grid on;
xlabel('Trade in USD')
ylabel('GDP as a function of trade')
title('Ind - Trade vs GDP')
legend('analytical','real data');
saveas(gcf,'Ind - Trade vs GDP actual.jpg', 'jpg')

function [gdp] = PowerLaw(trade,alpha)
    gdp=trade.^alpha;
end

function [val] = LogisticEqn(a,k,x0)
    t=(0:1:59);
    val=(x0.*k.*exp(a.*t))./(k+x0.*(exp(a.*t)-1));
end