%plannersprob_Ivepsilon_income.m
%Ian M. Schmutte
%2014 December 19
%TOday 2014 December 23
%schmutte@uga.edu
%
%From code archive for Abowd and Schmutte (2014) "Revisiting the Economics of Privacy: Population Statistics and Privacy as Public Goods"



%parameters
	n = 194000000; %size of U.S. population age 18-64 from according to 2010 decennial census.
	chi = 1000; %size of sample space. 1000 quantiles of the income distribution.
	k = 999; %size of the set of allowable queries. constructed here as the number of possible choices of two points in the histogram to allow "less than or equal to" and "greater than" queries

	n_alt = 1940000;

	SWF_alpha_int = .9; %intercept for another level set of the SWF
	sum_p = 2;
	ybar = 9;
	cov_y_gamma = -.1435; %from analysis of General Social Survey (GSS). See text for details.
	cov_y_eta = 0.1893;    %from analysis of General Social Survey (GSS). See text for details.
	beta = 0.01;
	delta = 0.9/n;

	delta_alt = 0.9/n_alt;

%find solution and maximized welfare function. 
	R = (1+cov_y_gamma)/(1+cov_y_eta)
	PPF_const = (8*sqrt(3*log(k/beta)*log(4/delta))*(log(chi)^(0.25)))/sqrt(n);
	alpha_best = (2*(PPF_const^2)*R)^(1/3)
	epsilon_best = (PPF_const/alpha_best)^2
	I_best = 1-alpha_best

	PPF_const_alt = (8*sqrt(3*log(k/beta)*log(4/delta_alt))*(log(chi)^(0.25)))/sqrt(n_alt);

	alpha_best_alt = (2*(PPF_const_alt^2)*R)^(1/3);
	epsilon_best_alt = (PPF_const_alt/alpha_best_alt)^2;
	I_best_alt = 1-alpha_best_alt;

	welfare_best = n*(-sum_p+ybar-epsilon_best*(1+cov_y_gamma)+I_best*(1+cov_y_eta));
	welfare_best_alt = n_alt*(-sum_p+ybar-epsilon_best_alt*(1+cov_y_gamma)+I_best_alt*(1+cov_y_eta));
	welfare = n*(ybar-sum_p+(SWF_alpha_int/(1+cov_y_eta)));




%plotting
	epsilon_min=0.001; epsilon_max = 10; gridsize = 1000;
	stepsize = (epsilon_max-epsilon_min)/(gridsize-1);
	epsilon = (epsilon_min:stepsize:epsilon_max);


	%PPF
	acc1 = PPF_const./(sqrt(epsilon));
	I_1 = 1-acc1;

	acc1_alt = PPF_const_alt./(sqrt(epsilon));
	I_1_alt = 1-acc1_alt;
	%SWF
	SWF_opt_alt = (welfare_best_alt/n_alt + sum_p - ybar+ epsilon*(1+cov_y_gamma))/(1+cov_y_eta);
	%SWF_best
	SWF_opt = (welfare_best/n + sum_p - ybar + epsilon*(1+cov_y_gamma))/(1+cov_y_eta);
	%Expansion Path
	expansion_path = -2*R*epsilon+1;

	figure(1);
	hold on;
	axis manual;
	xlim manual;
	ylim manual;
	xlim([0 1]);
	ylim([0 1]);
	axis square;
	set(gca,'FontSize',12);
	xlabel('Privacy Loss (\epsilon)','fontsize',12);ylabel('Accuracy (I)','fontsize',12);
	print('-f1','-depsc','blank');
	% title('Production Possibilities');
	plot(epsilon,I_1_alt,'-k','LineWidth',2);
	print('-f1','-depsc','MRT_1');
	plot(epsilon,I_1,'-g','LineWidth',2);
	print('-f1','-depsc','MRT_2');
	hold off
	clf

	figure(1);
	hold on;
	axis manual;
	xlim manual;
	ylim manual;
	xlim([0 1]);
	ylim([0 1]);
	axis square;
	set(gca,'FontSize',12);
	xlabel('Privacy Loss (\epsilon)','fontsize',12);ylabel('Accuracy (I)','fontsize',12);
	% title('Social Welfare Function');

	plot(epsilon,SWF_opt_alt,'-b','LineWidth',2);
	print('-f1','-depsc','SWF_1');
	plot(epsilon,SWF_opt,'-r','LineWidth',2);
	print('-f1','-depsc','SWF_2');
	hold off
	clf

	figure(1);
	hold on;
	axis manual;
	xlim manual;
	ylim manual;
	xlim([0 1]);
	ylim([0 1]);
	axis square;
	set(gca,'FontSize',12);
	xlabel('Privacy Loss (\epsilon)','fontsize',12);ylabel('Accuracy (I)','fontsize',12);
	% title('Social Welfare Maximization');
	plot(epsilon,I_1,'-g','LineWidth',2);
	print('-f1','-depsc','Max_1');
	plot(epsilon,SWF_opt_alt,'-b','LineWidth',2);
	print('-f1','-depsc','Max_2');
	plot(epsilon,SWF_opt,'-r','LineWidth',2);
	plot(epsilon_best, I_best, 'ko','MarkerSize',12);
	print('-f1','-depsc','Max_3');
	plot(epsilon,I_1_alt,'-k','LineWidth',2);
	plot(epsilon,expansion_path,'-.k');
	print('-f1','-depsc','Max_4');
	clf
	hold off;
clear all;