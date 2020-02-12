% A typical experimental design involves applying a range of treatments to
% different participants and testing if these treatments have an effect.
% This is a good experimental design if one tests whether treatment A has
% an effect compared to the null condition, for example. But one thing that is not
% OK is to select the treatment that has the largest effect for each
% participant (treatment B for participant 1, treatment C for participant
% 2, etc.), averaging these effects across participants, and then
% concluding that customized treatments have a net effect. Because of the
% random variability in measurements, where some measurements are higher
% and some are lower by chance and not by treatment, it is very likely to
% find an effect where none is present. 
%
% This simple script demonstrates this using data from the following
% exoskeleton paper as an example:
% Barazesh H, Ahmad Sharbafi M. A biarticular passive exosuit to support
% balance control can reduce metabolic cost of walking. Bioinspir Biomim
% [Internet]. 2020 Jan 28 [cited 2020 Feb 11]; Available from:
% https://iopscience.iop.org/article/10.1088/1748-3190/ab70ed
%
% This paper suffers from this problem, but it is by no means the only one.
% Indeed, the whole field of psychology has been trying to overcome this
% and similar defficiencies recently.
%
% Written by Max Donelan on Feb 11 2020

clear
close all

%% Simulation parameters
% After Barazesh & Sharbafi, let's use 8 subjects and 7 different treatment
% conditions.
subjectsN = 8;
trialsN = 7;

% We also need to know the measurement variability. That is, were we to
% repeatedly sample from the same individual under the same condition, what
% would be the variability in the result? We don't typically know this
% value in most reported experiments because we only measure each
% individual at each condition once. We can't use the between subject
% variability as it includes both the measurement variability and the
% differences between subjects. Here I use a standard deviation of 5%,
% which is roughly what we find when we have done the correct experiments
% to identify this measurement variability in our lab. Note that I can't
% tell from Barazesh & Sharbafi paper how long they average over (2 min? 3
% min?), or how good their equipment is, so it is possible that that their
% measurement variability is different (and likely higher).
measurementVariability = 0.05; % typical 

%% Monte Carlo Simulation
% Each pass through this for loop generates 7 measurements for each of 8
% subjects. Each of these measurements is drawn from a distribution with a
% mean of zero. To relate to the experiment, this is as if the 7 different
% exo conditions has no effect on met cost, but measurement noise
% contributes to each measurement so some will be lower and some will be
% higher than 0. For each subject, it selects the minimum value. And then
% it averages these values. It repeats this for rolloutN times. 
rolloutN = 10000;
for m = 1:rolloutN
      d = measurementVariability*randn(subjectsN,trialsN);
      D(m) = mean(min(d,[],2)); % find the within subject min and then average these minimu values
      SD(m) = std(min(d,[],2));
end
%%
figure(1); clf
    subplot(211); hold on
        histogram(D,'Normalization','probability');
        yl = [0 0.1];
        xl = [-0.15 0];
        xlim(xl)
        % "Therefore, the average metabolic rate of normal walking is reduced by 4.68 � 4.24%
        plot([-0.0468 -0.0468],yl,'linewidth',[1])
         % Interestingly, the comparison between Assisted and NS shows that the optimal stiffness for the passive biarticular thigh artificial muscles results in a 14.7 � 4.27% reduction in metabolic cost. 
        plot([-0.147 -0.147],yl,'linewidth',[1])
       xlabel('Average metabolic rate reduction')
        ylabel('Probability')
        box on
        grid on
    subplot(212); hold on
        histogram(D,'Normalization','cdf');
        yl = [0 1];
        xl = [-0.15 0];
        ylim(yl)
        xlim(xl)
        % "Therefore, the average metabolic rate of normal walking is reduced by 4.68 � 4.24%
        plot([-0.0468 -0.0468],yl,'linewidth',[1])
        % Interestingly, the comparison between Assisted and NS shows that the optimal stiffness for the passive biarticular thigh artificial muscles results in a 14.7 � 4.27% reduction in metabolic cost. 
        plot([-0.147 -0.147],yl,'linewidth',[1])
        xlabel('Average metabolic rate reduction')
        ylabel('Cumulative Density Function')
        grid on
        box on
