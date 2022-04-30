function [result] = NCPPI (Network)
	eval(['load ' Network]);% Network  =  .mat file
	graph(graph~=0)=1;
	classnum=size(label,2);
	n=size(label,1);
	
	ratio=0.09; %Proportion of nodes used for training
	[Test Train] = Randomselection(n, ratio);
	
	sp=graphallshortestpaths(graph);
	
	sgm=0.6;	
	para1=1/(sqrt(2*pi)*sgm)  ;
	para2=2*sgm*sgm;

	for run=1:size(Train,1)
	
		train=Train{run,1};
		test=Test{run,1};

		z1=sp(train,train);
		z2=sp(train,test);
		z3=sp(test,train);
		z4=sp(test,test);
		%clear sp;
		P=[z1 z2;z3 z4];   %shortest_path
		clear z1 z2 z3 z4;
		P=P.^2;
		P=para1* exp(-(P)/ para2);
		P=P./sum(P,2);
		
		
		ttr=label(train,:);
		true_label=label(test,:);

		
		testing=ones(length(test),classnum);
		proba=1/classnum;
		testing=testing*proba;
		
		%F represents a posteriori probability matrix
		F=[ttr; testing];
		ti=0.9;
		Y=ttr;
		
		test_index=(length(train)+1):n;
		[r,c]=size(F);
		z1=zeros(r,c);
		
		b1=F(test_index,:);
		b2=z1(test_index,:);
		
		for iter=1:10
			F=P*F;
			FL=F(1:length(train),:);
			FU=F(  (length(train)+1 ):n  ,: );
			FL=(1-ti)*FL+ti*Y;
			F=[FL;FU];
		end
		
		clear P 
		
		[p11,p22]=vec_eval(Y,F,true_label)

		micro_F1(run)=p11 ;
		macro_F1(run)=p22;
	end
	result(1,1)=mean(micro_F1);
	result(1,2)=mean(macro_F1);

	%result(2,1)=std(micro_F1);
	%result(2,2)=std(macro_F1);

end
