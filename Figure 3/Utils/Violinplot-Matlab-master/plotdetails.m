function plotdetails(n)
title(sprintf('Test %02.0f \n',n));
ylabel('Fuel Economy in MPG ');
xlim([0, 8]); grid minor;
set(gca, 'color', 'none');
xtickangle(-30);
fprintf('Test %02.0f passed ok! \n ',n);
end