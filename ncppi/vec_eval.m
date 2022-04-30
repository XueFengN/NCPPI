function [mic, mac] = evaluate(ttr,F, true_label)

	classnum=size(true_label,2);
	pred=[ttr;zeros(length(true_label),classnum);];
	n=size(F,1);
	len_train=length(ttr);
	row_label=sum(true_label,2);
	
	for i=(len_train+1):n
		vt=F(i,:);
		[des,ind]=sort(vt,'descend');
		num_label=row_label(i-len_train);
		pred(i,:)=0;
		
		for j=1:num_label-1
			pred(i,ind(j))=1;
		end
		if des(num_label)~=des(num_label+1)
			pred(i,ind(num_label))=1;
		else
			cop=find(vt==des(num_label));
			cop1=find(des==des(num_label));
			pred(i,cop)=0;
			num=num_label-(cop1(1)-1);
			la_3=[];
			for v=1:num
				rand_num=randsrc(1,1,cop1);
				la_3=[la_3 rand_num];
				cop1(cop1==rand_num)=[];
			end
			pred(i,ind(la_3))=1;
		end
	end
	tet=(len_train+1):n;
	predict=pred(tet,:);

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

