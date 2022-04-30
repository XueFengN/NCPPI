function [Test, Train] = Randomselection(n, ratio)
	Test=cell(10,1);
	Train=cell(10,1);
	for i=1:10
		comm_i =1:n;
		size_comm_i = length(comm_i);
		rp = randperm(size_comm_i); 
		rp_ratio = rp(1:floor(size_comm_i * ratio));
		ind = comm_i(rp_ratio);
		Train{i}=[Train{i},ind'];
		test_rp=rp(floor(size_comm_i * ratio+1):end);
		indx= comm_i(test_rp);
		Test{i}=[Test{i},indx'];
	end
end
