function matchSetsPlot(setA, setB)
% Function that plot correspondence of strings between two sets of strings.
% CAUTION ! NEEDS match_str function available in Fieldtrip toolbox !
% Michal Komorowski, January 2019, michu.kom@gmail.com

if(~iscellstr(setA)) error('First argument should be cell with strings !'); end
if(~iscellstr(setB)) error('Second argument should be cell with strings !'); end

matchLine = @(iA,iB) ((iB - iA)*x + iA);

[iA, iB] = match_str(setA, setB);
maxVal = max([iA;iB]);

figure
y = matchLine(iA,iB);
x = [0 1];
plot(x,y)
grid on
ylim([0, maxVal+1])
yticks(1:1:maxVal)
title('Labels correspondence')
ylabel 'First set'
yyaxis right
ylabel 'Second set'
yticks([])
xticks([])
