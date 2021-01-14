proc freq data=Base_finale order=freq ;ods graphics on ;
/**output out=departement_cat_contrat;**/
tables  departement*cat_contrat/list missing nocum out=departement_cat_contrat plots=freqplot (type=bar twoway=stacked orient=horizontal);  
run;

data ACM;
set departement_cat_contrat (rename=( COUNT=eff));
drop PERCENT;
run;

ods html;
ods graphics on;
proc corresp data=Acm observed
out=resul dim=2;
tables departement,cat_contrat; /* croisement des deux variables */
weight eff; /* contient les effectifs de la table */
run;
ods graphics off;
ods html close;
