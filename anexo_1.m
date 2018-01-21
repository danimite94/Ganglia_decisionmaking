%condi�oes iniciais
m=1;
e=-0.1;%este valor tem de ser menor que 0, para que no estado de repouso (input=0) 
       %o output seja nao selecionado (segundo caracteristicas do sistema em causa)
       
wme=1.35;
wma=0.35; %igual a dai/dxj (i!=j), que tem de ser maior que 0 para se verificar competi�ao entre canais, 
          %como � o que se verifica para este caso (w+ = (wma) = 0.35>0).
       

SS=[];%small signal encoding
LS=[];%large signal encoding
Yzero=[];%indeterminate set
output=[];

n=4;%numero de outputs que se v�o considerar
input=rand(n,1);%vector coluna n-por-1
activacao=linspace(0,0,n);
input

for i = 1:n
    %defini�ao da fun�ao activa�ao
    activacao(i) = -wme*input(i) + wma*(sum(input)-input(i));
    
    %defini��o da fun�ao y(a) por ramos
    if activacao(i) < e
        SS = [SS activacao(i)];
        output = [output 0];
    elseif activacao(i) >= e && activacao(i) <= 1/m + e 
        Yzero = [Yzero activacao(i)];
        output = [output m*(activacao(i)-e)];
    else
        LS = [LS activacao(i)];
        output = [output 1];
    end
end
SS

LS

activacao

output

%representa�ao grafica dos inputs (aleatorios) para cada canal
in=bar(subplot(2,2,1), input);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Input')


%representa�ao grafica das varias activa�oes (dependentes de cada input)
%para cada canal
bar(subplot(2,2,2), activacao);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Activa��o')


%representa�ao grafica dos outputs para cada canal
bar(subplot(2,2,3), output);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Output')

%imagem das redes neuronais 

subplot(2,2,4);
rgb = imread('sele�ao ganglio.jpg');
a=imresize(rgb,20);
imshow(a)
title({'Organiza��o neuronal off-centre on surround'; 'implicita na sele��o de sinais'})

%determina�ao do criterio "decisao" e consequente categoriza�ao
decisao= 1-length(Yzero)/length(input);

if decisao == 1
    fprintf( 'sele�ao limpa\n')
elseif decisao == 0
    fprintf('Nao foi feita sele�ao clara. Todos os sinais estao no grupo indeterminado\n')
end



%determina�ao do tipo de mecanismo em causa:soft ou hard switching
if length(SS)+length(LS) == 1
    fprintf ('mecanismo hard switching \n')
elseif length(SS)+length(LS) > 1
    fprintf ('mecanismo soft switching\n')
end
       

%determina�ao do criterio "promiscuidade"
promiscuidade= (length(SS)+length(LS))/(length(input));


%determina�ao do criterio "selectividade"
seletividade= 1-promiscuidade;

fprintf( 'promiscuidade = %4.2f \n', promiscuidade) 
fprintf( 'seletividade = %4.2f \n', seletividade) 


