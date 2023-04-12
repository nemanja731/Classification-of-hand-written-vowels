clear
close all
clc

%% Definisanje parametara

%slova koja treba da klasifikujem su: A, E, I, O, U
N = 120; %ukupan broj slova
No = 100; %broj slova koji smestamo u obucavajuci skup
Nt = 20; %broj slova koji smestamo u testirajuci skup
num_attributes = 5; %broj obelezja za klasifikaciju
num_classes = 5;
X = zeros(num_attributes, N);
X1 = X; X2 = X; X3 = X; X4 = X; X5 = X;

%% Ucitavanje slika i predobrada slika

for i = 1:N
    %ucitavanje slova A
    x = imread(['bazaA' num2str(i,'%03d') '.bmp']);
    %odredjivanje obelezja za slovo A
    X1(:, i) = obelezja(x);
     
    %ucitavanje slova E
    x = imread(['bazaE' num2str(i,'%03d') '.bmp']);
    %odredjivanje obelezja za slovo E
    X2(:, i) = obelezja(x);
    
    %ucitavanje slova I
    x = imread(['bazaI' num2str(i,'%03d') '.bmp']);
    %odredjivanje obelezja za slovo I
    X3(:, i) = obelezja(x);
    
    %ucitavanje slova O
    x = imread(['bazaO' num2str(i,'%03d') '.bmp']);
    %odredjivanje obelezja za slovo O
    X4(:, i) = obelezja(x);
    
    %ucitavanje slova U
    x = imread(['bazaU' num2str(i,'%03d') '.bmp']);
    %odredjivanje obelezja za slovo U
    X5(:, i) = obelezja(x);
end

%% Randomizacija i podela podataka na obucavajuci i testirajuci skup za svaku klasa pojedinacno

ind = randperm(N);

O1 = X1(:, ind(1:No)); T1 = X1(:, ind(No + 1:N));
O2 = X2(:, ind(1:No)); T2 = X2(:, ind(No + 1:N));
O3 = X3(:, ind(1:No)); T3 = X3(:, ind(No + 1:N));
O4 = X4(:, ind(1:No)); T4 = X4(:, ind(No + 1:N));
O5 = X5(:, ind(1:No)); T5 = X5(:, ind(No + 1:N));

%% Projektovanje klasifikatora
%predlog: test vise hipoteza, Bajesov klasifikator, pretpostavka za fgv je da su Gausovske

M1 = mean(O1, 2); S1 = cov(O1');
M2 = mean(O2, 2); S2 = cov(O2');
M3 = mean(O3, 2); S3 = cov(O3');
M4 = mean(O4, 2); S4 = cov(O4');
M5 = mean(O5, 2); S5 = cov(O5');

%% Testiranje klasifikatora

confusion_matrix = zeros(num_classes, num_classes); %konfuziona matrica
for k = 1:num_classes
    if k == 1
        T = T1;
    elseif k == 2
        T = T2;
    elseif k == 3
        T = T3;
    elseif k == 4
        T = T4;
    elseif k == 5
        T = T5;
    end
    for i = 1:(Nt)
        x = T(:, i);
        f1 = 1/(2*pi*det(S1)^0.5)*exp(-0.5*(x - M1)'*S1^(-1)*(x - M1));
        f2 = 1/(2*pi*det(S2)^0.5)*exp(-0.5*(x - M2)'*S2^(-1)*(x - M2));
        f3 = 1/(2*pi*det(S3)^0.5)*exp(-0.5*(x - M3)'*S3^(-1)*(x - M3));
        f4 = 1/(2*pi*det(S4)^0.5)*exp(-0.5*(x - M4)'*S4^(-1)*(x - M4));
        f5 = 1/(2*pi*det(S5)^0.5)*exp(-0.5*(x - M5)'*S5^(-1)*(x - M5));
        max_f = max([f1 f2 f3 f4 f5]);
        if max_f == f1
            confusion_matrix(k, 1) = confusion_matrix(k, 1) + 1;
            disp(['Oblik ' num2str(i) ' iz klase' num2str(k) ' je prepoznat kao slovo A']);
        elseif max_f == f2
            confusion_matrix(k, 2) = confusion_matrix(k, 2) + 1;
            disp(['Oblik ' num2str(i) ' iz klase' num2str(k) ' je prepoznat kao slovo E']);
        elseif max_f == f3
            confusion_matrix(k, 3) = confusion_matrix(k, 3) + 1;
            disp(['Oblik ' num2str(i) ' iz klase ' num2str(k) ' je prepoznat kao slovo I']);
        elseif max_f == f4
            confusion_matrix(k, 4) = confusion_matrix(k, 4) + 1;
            disp(['Oblik ' num2str(i) ' iz klase ' num2str(k) ' je prepoznat kao slovo O']);
        elseif max_f == f5
            confusion_matrix(k, 5) = confusion_matrix(k, 5) + 1;
            disp(['Oblik ' num2str(i) ' iz klase ' num2str(k) ' je prepoznat kao slovo U']);
        end
    end
end

%% Prikaz rezultata 

disp('Matrica konfuzije: ');
disp('     A     E     I     O     U');
disp('    ---------------------------');
disp(confusion_matrix')
error = (sum(sum(confusion_matrix)) - trace(confusion_matrix))/sum(sum(confusion_matrix));
disp(['Ukupna greska klasifikacije je: ' num2str(error)]);

