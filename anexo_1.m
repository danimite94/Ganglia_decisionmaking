%condiçoes iniciais
m=1;
e=-0.1;%este valor tem de ser menor que 0, para que no estado de repouso (input=0) 
       %o output seja nao selecionado (segundo caracteristicas do sistema em causa)
       
wme=1.35;
wma=0.35; %igual a dai/dxj (i!=j), que tem de ser maior que 0 para se verificar competiçao entre canais, 
          %como é o que se verifica para este caso (w+ = (wma) = 0.35>0).
       

SS=[];%small signal encoding
LS=[];%large signal encoding
Yzero=[];%indeterminate set
output=[];

n=4;%numero de outputs que se vão considerar
input=rand(n,1);%vector coluna n-por-1
activacao=linspace(0,0,n);
input

for i = 1:n
    %definiçao da funçao activaçao
    activacao(i) = -wme*input(i) + wma*(sum(input)-input(i));
    
    %definição da funçao y(a) por ramos
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

%representaçao grafica dos inputs (aleatorios) para cada canal
in=bar(subplot(2,2,1), input);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Input')


%representaçao grafica das varias activaçoes (dependentes de cada input)
%para cada canal
bar(subplot(2,2,2), activacao);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Activação')


%representaçao grafica dos outputs para cada canal
bar(subplot(2,2,3), output);
xlab='channels';
xlabel(xlab);
ylab='signal level';
ylabel(ylab);
title('Output')

%imagem das redes neuronais 

subplot(2,2,4);
rgb = imread('seleçao ganglio.jpg');
a=imresize(rgb,20);
imshow(a)
title({'Organização neuronal off-centre on surround'; 'implicita na seleção de sinais'})

%determinaçao do criterio "decisao" e consequente categorizaçao
decisao= 1-length(Yzero)/length(input);

if decisao == 1
    fprintf( 'seleçao limpa\n')
elseif decisao == 0
    fprintf('Nao foi feita seleçao clara. Todos os sinais estao no grupo indeterminado\n')
end



%determinaçao do tipo de mecanismo em causa:soft ou hard switching
if length(SS)+length(LS) == 1
    fprintf ('mecanismo hard switching \n')
elseif length(SS)+length(LS) > 1
    fprintf ('mecanismo soft switching\n')
end
       

%determinaçao do criterio "promiscuidade"
promiscuidade= (length(SS)+length(LS))/(length(input));


%determinaçao do criterio "selectividade"
seletividade= 1-promiscuidade;

fprintf( 'promiscuidade = %4.2f \n', promiscuidade) 
fprintf( 'seletividade = %4.2f \n', seletividade) 


