/**'Distribution de la nouvelle prime en fonctin du genre ' **/
title 'Distribution de la nouvelle prime en fonctin du genre ';
ods graphics on;
proc univariate data=Base_finale noprint;
class sexe;
   histogram   nouvelle_prime/ odstitle = title NORMAL;
   inset n = 'Densité ' / position=ne;
   label sexe='Genre';
run;


/** Distribution de la nouvelle prime en fonction du contrat **/
title 'Distribution de la nouvelle prime en fonction du contrat ';
ods graphics on;
proc univariate data=Base_finale noprint;
class cat_contrat;
   histogram   nouvelle_prime/ odstitle = title NORMAL;
   inset n = 'Densité ' / position=ne;
   label sexe='Genre';
run;

/** Variation de la prime en fonction de l'age du scoiétaire' **/ 
PROC GPLOT DATA = Base_finale ;
 PLOT nouvelle_prime * age_contrat ;
 RUN ; QUIT ;

/** Variation de la prime en fonction du cylindré **/ 
PROC GPLOT DATA = Base_finale ;
 PLOT nouvelle_prime * age_vehicule  ;
 RUN ; QUIT ;

/** Distribution de la catégorie contrat par tranche d'age **/ 
proc freq data=Base_finale;
tables categorie_contrat*tranche_age/ nofreq nocum out=cat_contrat_tranche_age plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 



/** Distribution ancienneté du client(depuis son adhésion) par l'âge du contrat **/
proc freq data=Base_finale;
tables anciente*age_contrat/ nofreq nocum out=anciente_age_contrat plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 

/** Description graphique des variales: categorie_contrat A_magazine qualite classe **/
proc freq data=Base_finale order=freq; ods graphics on;
tables categorie_contrat A_magazine qualite classe/nocum list plots=freqplot (type=bar scale=percent); 
output out = Stats_Sexe;
run; 

/**CREATION TEST **/
 
proc sql noprint;
create table TEST as select distinct num_client, count(num_client)as nb_contrats, sexe, c_socio_pro, avg(nouvelle_prime) as nvlle_prime_moyenne, tranche_age, departement, Region
from Base_Finale
group by num_client
order by num_client
;
quit;
data Test; 
length Genre $50.;
Set Test; 
If sexe='Homme' then Genre='Homme';
Else Genre='Femme';
run; 

 /**Description graphique des variales: sexe et socio pro **/
proc freq data=Test order=freq;
tables sexe c_socio_pro nb_contrats/ nofreq nocum plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 

proc means Data=Test order=freq; ods graphics on;
Class departement;
Var nb_contrats;
output out=departement_nb_contrats mean(nb_contrats)=Moy_nb contrats;
run;

/**Description graphique des variales: region et cat_contrat **/
proc freq data=Test;
tables categorie_contrat*REGION / nofreq nocum plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 

/**Description **/

proc means Data=Base_finale order=freq; ods graphics on;
Var respons_civile	defense_recours	vol	Incendie	cata_naturelle	Bris_de_glace	Dommage_tt_accid	outil_travail	corp_1	corp_3	corp_scolaire	cata_techno	objets_transportes	assist_vehicule	assist_perso	rc_hors_circul	accessoires_vol	accessoires_dommage	equipement	moto_transportee
  ;

run;
/*distribution de type*/
proc freq data=Base_finale order=freq;
tables departement/ nofreq nocum plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 

proc freq data=Base_finale;
tables respons_civile*defense_recours/ nofreq nocum plots=freqplot (type=bar twoway=stacked orient=horizontal);
run; 

ods output onewayfreqs=class_freqs;
proc freq data=Base_Finale;
tables respons_civile	defense_recours	vol	Incendie	cata_naturelle	Bris_de_glace	Dommage_tt_accid	outil_travail	corp_1	corp_3	corp_scolaire	cata_techno	objets_transportes	assist_vehicule	assist_perso	rc_hors_circul	accessoires_vol	accessoires_dommage	equipement	moto_transportee
  ;
run;
ods output close;

/**Distribution de la nouvelle prime moyenne **/
proc univariate data=Test noprint;
   histogram nvlle_prime_moyenne  / odstitle = title NORMAL;
   inset n = 'Densité ' / position=ne;
run;
/**Distribution du nombre de contrat par clients**/
proc univariate data=Test noprint;
   histogram nb_contrats  / odstitle = title NORMAL;
   inset n = 'Densité ' / position=ne;
run;
proc means Data=Test order=freq; ods graphics on;
class c_socio_pro;
Var nvlle_prime_moyenne ;
output out=out1 mean(nvlle_prime_moyenne)=Nv_prime_moyenne;
run;


proc univariate data=Test noprint;
   histogram   c_socio_pro/ odstitle = title NORMAL;
   inset n = 'Densité ' / position=ne;
run;

