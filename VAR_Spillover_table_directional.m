function [theta] = VAR_Spillover_table_directional(data, H, k)

	[ N vars ] = size(data);
	x = ones(N-k,1);

	for i=(k-1):-1:0
		x = [x trimr(data,i,k-i)];
	end;

	x = x(:,1:(vars*k+1));
	
	b = x\trimr(data,k,0);
	b = b';

	%VMA representation H

	Phi = zeros(vars, vars*(H+1));
	Phi(1:vars,1:vars) = eye(vars);
	for i=1:(k)
		for j = 1:i
			Phi(1:vars, (1:vars) + i*vars) = Phi(1:vars, (1:vars) + i*vars) + b(1:vars, (1:vars)+(j-1)*vars+1)*Phi(1:vars, (1:vars) + (i-j)*vars);
		end;
	end;

	for i=(k+1):H
		for j = 1:k
			Phi(1:vars, (1:vars) + i*vars) = Phi(1:vars, (1:vars) + i*vars) + b(1:vars, (1:vars)+(j-1)*vars+1)*Phi(1:vars, (1:vars) + (i-j)*vars);
		end;
	end;

	v  = trimr(data,k,0) - x*b';   % VAR residuals      
	vc = v'*v/length(v);
	
    sigma=std(v)';
    %sigma=var(v)';
    
    theta=zeros(vars,vars);
    theta0=zeros(vars,vars);
    ee=eye(vars,vars);
    
    for i=1:vars
        for j=1:vars
            theta2 = 0;
            theta1 = 0;
            for h=0:H
                theta1 = theta1 + (ee(:,i)'*Phi(1:vars, (1:vars) + h*vars)*vc*ee(:,j))^2;
                theta2 = theta2 + (ee(:,i)'*Phi(1:vars, (1:vars) + h*vars)*vc*Phi(1:vars, (1:vars) + h*vars)'*ee(:,i));
            end
            theta0(i,j) = (1/sigma(j)*theta1)/theta2;    
        end
    end
    
    thetaden = sum(theta0');
    for i=1:vars
        for j=1:vars
            theta(i,j) = theta0(i,j)/thetaden(i);  
        end
    end
               
end