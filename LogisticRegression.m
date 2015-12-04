  x = load('-ascii','titanicx.dat');
  y = load('titanicy.dat');
  pos = find(y);
  neg = find(y == 0);
  plot(x(pos, 1), x(pos, 2), 'k+');
  hold on;
  plot(x(neg, 1), x(neg, 2), 'ko');
  xlabel('Class');
  ylabel('Fare');
  hold on;
  x = map_feature(x(:,1), x(:,2));
  [m, n] = size(x);
  theta = zeros(n,1); 
  g = inline('1.0 ./ (1.0 + exp(-z))'); 
  iter = 15;
  J = zeros(iter, 1);
  lambda = 10;
  for i = 1:iter
      z = x * theta;
      h = g(z);
      J(i) =-(1/m)*sum(y.*log(h) + (1-y).*log(1-h))+(lambda/(2*m))*norm(theta([2:end]))^2;
      G = (lambda/m).*theta; G(1) = 0; 
      L = (lambda/m).*eye(n); L(1) = 0;
      grad = ((1/m).*x' * (h-y)) + G;
      H = ((1/m).*x'*diag(h)*diag(1-h)*x)+L;
      theta = theta - H\grad;
  end
  norm(theta)
  u = linspace(-1, 1.5, 2);
  v = linspace(-1, 1.5, 2);
  z = zeros(length(u), length(v));
  for i = 1:length(u)
      for j = 1:length(v)
          z(i,j) = map_feature(u(i), v(j))*theta;
      end
  end
  z = z'; 
  contour(u, v, z, [0, 0])