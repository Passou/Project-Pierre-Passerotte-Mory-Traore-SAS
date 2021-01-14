libname stat 'C:\Users\USER\Desktop\Projet'; 
PROC IMPORT OUT= stat.Clients 
            DATAFILE= "C:\Users\USER\Desktop\Projet\CLIENTS1.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= STAT.Contrats 
            DATAFILE= "C:\Users\USER\Desktop\Projet\CONTRATS1.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc sort data=Stat.Clients ;
by nusoc ; 
run; 
proc sort data=Stat.Contrats ;
by nusoc ; 
run;

DATA fusion ;           
 MERGE Stat.Clients (In=A) Stat.Contrats (IN=B);           
 BY nusoc ;
 If A ; 
RUN ;



Data RENAMED;
set fusion (rename=( nusoc=num_client nucon=num_contrat cateco=cat_contrat usagco=usage form=formule BOMACO=Bonus FRACCO=Fractionnement PRMACO=Prime ASAISO=Annee_saisie MSAISO=Mois_saisie JSAISO=Joursaisie ));

Annee = year(date());
run;
/** On crée une variable age du véhicule ainsi que l'age du sociétaire**/
data Base1;
set renamed;
age_vehicule = Annee - acircu ;
age_soc = Annee - anaiso;
run; 
data Base2; 
length bonus_en_tranche $10.;
set Base1; 
If Bonus=0.5 then bonus_en_tranche = '0.5';
Else if  0.5<Bonus<0.75 then bonus_en_tranche = ']0.5-0.75[';
Else if  0.76<Bonus<1 then bonus_en_tranche = ']0.76-1['; 
Else if Bonus = 1 then bonus_en_tranche= '1';
Else bonus_en_tranche='Plus de 1';

run; 
data Base3; 
set Base2; 
If bonus_en_tranche='0.5' then nouvelle_prime= Prime-Prime*(0.1);
Else If  bonus_en_tranche=']0.5-0.75[' then nouvelle_prime= Prime-Prime*(0.05);
Else If bonus_en_tranche in (']0.76-1[' '1' ) then nouvelle_prime= Prime;
Else If bonus_en_tranche='Plus de 1' then nouvelle_prime=Prime+32; 
run;
/** Ici, on renomme sitpav, qualso et sexe **/
data Base4; 
length sitpav $50.;
length qualso $50.;
length sexe $50.;
set Base3; 
If sitpav in ('I' 'M' 'S') then Magazine = 'Abonné';
Else if  sitpav in ('R' 'N') then Magazine = 'Non Abonné';
If qualso in ('C' 'F' 'G', 'H') then Qualite = 'Partenaire';
Else if  qualso ='N' then Qualite = 'Non Partenaire';
If sexsoc='1' then sexe='Homme';
Else if sexsoc='2' then sexe='Femme';
Else if sexsoc='3' then sexe='Personne morale'; 
run; 

data Base5;
 set Base4;
 rename aefdco= a_effet_contrat;
 rename mefdco= mois_effet_contrat;
 rename jefdco= j_effet_contrat ;
 rename idpaco= partenariat;
 rename cdepso= departement;
 rename cvilso= ville;
 rename sexsoc= sexe;
 rename  bgesso= bureau_R;
 rename aadhso= an_adhesion;
 rename anaiso= an_naissance;
 rename mnaiso= moi_naissance;
 rename jnaiso= j_naissance;
 rename cspsoc= c_socio_pro;
 rename consoc= list_contrat;
 rename qualso= qualite;
 rename sitpav= A_magazine;
  rename asaiso= an_s_client;
  rename msaiso= moi_s_client;
  rename jsaiso= j_s_client;
  rename sitmat= s_matrimonial;
  rename nbenf= nb_enfants;
  rename accmai= par_mail;
  rename accsms= par_sms; 
rename  g01co = respons_civile;
  rename g02co= defense_recours;
  rename g03co= vol ;
  rename g04co= Incendie ;
  rename  g05co = cata_naturelle ;
  rename  g06co = Bris_de_glace;
  rename  g09co = Dommage_tt_accid;
rename  g10co = outil_travail;
rename  g13co = corp_1;
rename  g15co = corp_3 ;
rename  g16co = corp_scolaire;
rename  g17co = cata_techno;
rename  g18co = objets_transportes;
rename  g19co = assist_vehicule;
rename  g21co = assist_perso;
rename  g22co = rc_hors_circul;
rename  g23co = accessoires_vol;
rename  g25co = accessoires_dommage;
rename  g26co = equipement;
rename  g28co = moto_transportee;
run ; 
/** Ici, on supprime les variables qui ne nous intéressent pas ainsi que les variables que nous avons renomés **/
data Base_finale; 
set Base5; 
drop g07co g08co g11co g12co g24co g14co g27co mnaiso jnaiso sitpav qualso sexsoc idpaco mcircu partenariat  ; 
run; 

