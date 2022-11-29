function [val] = LogisticEqn(a,k,x0)
    t=(0:1:59);
    val=(x0.*k.*exp(a.*t))./(k+x0.*(exp(a.*t)-1));
end