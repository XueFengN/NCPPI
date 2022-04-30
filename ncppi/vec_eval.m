function [mic, mac] = evaluate(predict, true_label)
	temp = predict & true_label;
	num_corr = sum(temp, 1);
	num_true = sum(true_label,   1);
	num_pred  = sum(predict, 1);

	% macro_F1
	perf.precision = num_corr./num_pred;
	perf.recall = num_corr ./num_true;
	perf.F1 = (2*num_corr)./(num_true+num_pred);

	perf.precision(num_corr==0)=0;
	perf.recall(num_corr==0)=0;
	perf.F1(num_corr==0)=0;

	perf.macro_precision = mean(perf.precision);
	perf.macro_recall = mean(perf.recall);
	perf.macro_F1 = mean(perf.F1);

	% micro_F1
	perf.micro_precision = sum(num_corr) /  sum(num_pred);
	perf.micro_recall = sum(num_corr) / sum(num_true);
	perf.micro_F1 = 2*sum(num_corr)/(sum(num_true) + sum(num_pred));
	mic=perf.micro_F1 ;
	mac= perf.macro_F1;
end

