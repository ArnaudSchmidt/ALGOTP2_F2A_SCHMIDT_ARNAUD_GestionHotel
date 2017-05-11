

/* Classement des clients par nombre d'occupations */
	SELECT CLI_ID as "Identifiant du client", sum(CHB_PLN_CLI_OCCUPE) as "Nombre d'occupations"
	FROM CLI_PLN_CHB
	GROUP BY CLI_ID
	ORDER BY "Nombre d'occupations" desc


/* Classement des clients par montant dépensé dans l'hotel */
	SELECT FACTURE.CLI_ID as "Identifiant du client", sum(LIF_QTE*(LIF_MONTANT*(1+(LIF_TAUX_TVA/100)))) as "Montant dépensé dans l'hotel"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is null
	AND LIF_REMISE_MONTANT is null
	GROUP BY "Identifiant du client"
	union
	SELECT FACTURE.CLI_ID as "Identifiant du client", sum(LIF_QTE*((1+LIF_REMISE_POURCENT/100)*LIF_MONTANT*(1+(LIF_TAUX_TVA/100)))) as "Montant dépensé dans l'hotel"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is not null
	AND LIF_REMISE_MONTANT is null
	GROUP BY "Identifiant du client"
	union
	SELECT FACTURE.CLI_ID as "Identifiant du client", sum(LIF_QTE*((LIF_MONTANT-LIF_REMISE_MONTANT)*(1+(LIF_TAUX_TVA/100)))) as "Montant dépensé dans l'hotel"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is null
	AND LIF_REMISE_MONTANT is not null
	GROUP BY "Identifiant du client"					/* il faudrait pouvoir les additionner et les classer, mais je suis bloqué à ce stade, navré */


/* Classement des occupations par mois */
	SELECT strftime('%m-%Y', PLN_JOUR) as "Mois", sum(CHB_PLN_CLI_OCCUPE) as "Nombre d'occupations"
	FROM CLI_PLN_CHB
	GROUP BY "Mois"
	ORDER BY "Nombre d'occupations" desc
	
	
/* Classement des occupations par trimestre */
	/* je passe */
	
	
/* Montant TTC de chaque ligne de facture (avec remises) */
	SELECT LIF_ID as "Identifiant de ligne de facture", (LIF_QTE*((1+LIF_REMISE_POURCENT/100)*LIF_MONTANT*(1+(LIF_TAUX_TVA/100)))) as "Montant TTC"
	FROM LIGNE_FACTURE
	WHERE LIF_REMISE_POURCENT is not null
	AND LIF_REMISE_MONTANT is null
	union
	SELECT LIF_ID as "Identifiant de ligne de facture", (LIF_QTE*((LIF_MONTANT-LIF_REMISE_MONTANT)*(1+(LIF_TAUX_TVA/100)))) as "Montant TTC"
	FROM LIGNE_FACTURE
	WHERE LIF_REMISE_POURCENT is null
	AND LIF_REMISE_MONTANT is not null
	
	
/* Classement du montant total TTC (avec remises) des factures */
	SELECT FACTURE.FAC_ID as "Identifiant de la facture", sum(LIF_QTE*(LIF_MONTANT*(1+(LIF_TAUX_TVA/100)))) as "Montant de la facture"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is null
	AND LIF_REMISE_MONTANT is null
	GROUP BY "Identifiant de la facture"
	union
	SELECT FACTURE.FAC_ID as "Identifiant de la facture", sum(LIF_QTE*((1+LIF_REMISE_POURCENT/100)*LIF_MONTANT*(1+(LIF_TAUX_TVA/100)))) as "Montant de la facture"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is not null
	AND LIF_REMISE_MONTANT is null
	GROUP BY "Identifiant de la facture"
	union
	SELECT FACTURE.FAC_ID as "Identifiant de la facture", sum(LIF_QTE*((LIF_MONTANT-LIF_REMISE_MONTANT)*(1+(LIF_TAUX_TVA/100)))) as "Montant de la facture"
	FROM FACTURE, LIGNE_FACTURE
	WHERE FACTURE.FAC_ID = LIGNE_FACTURE.FAC_ID
	AND LIF_REMISE_POURCENT is null
	AND LIF_REMISE_MONTANT is not null
	GROUP BY "Identifiant de la facture"				/* même problème qu'avant pour additionner et classer... */
	

/* Tarif moyen des chambres par années croissantes */
	/* je passe */
	
	
/* Tarif moyen des chambres par étage et années croissantes */
	/* je passe */
	

/* Chambre la plus cher et en quelle année */
	SELECT CHB_ID as "Identifiant de la chambre la plus cher", TRF_DATE_DEBUT as "Date de début", MAX(TRF_CHB_PRIX) as "Tarif"
	FROM CHB_TRF
	

/* Chambres réservées mais pas occupées */
	SELECT CHB_ID as "Identifiant de la chambre réservée non occupée"
	FROM CLI_PLN_CHB
	WHERE CHB_PLN_CLI_RESERVE > 0
	AND CHB_PLN_CLI_OCCUPE = 0


/* Taux de réservation par chambre */
	/* je passe */
	

/* Factures réglées avant leur édition */
	SELECT FAC_ID as "Identifiant de facture réglée avant son édition"
	FROM FACTURE
	WHERE FAC_DATE > FAC_PMT_DATE

	
/* Par qui ont été payées ces factures réglées en avance ? */
	SELECT CLIENT.CLI_ID as "Identifiants des bons payeurs", CLI_NOM as "Nom des bons payeurs", CLI_PRENOM as "Prénom des bons payeurs"
	FROM FACTURE, CLIENT
	WHERE CLIENT.CLI_ID = FACTURE.CLI_ID
	AND FAC_DATE > FAC_PMT_DATE
	
	
/* Classement des modes de paiement (par mode et le montant total généré) */
	/* je passe */
	

/* Vous vous créez en tant que client de l'hotel */
	INSERT into CLIENT (CLI_ID, TIT_CODE, CLI_NOM, CLI_PRENOM)
	VALUES ('117', 'M.', 'SCHMIDT', 'Arnaud');
	

/* Ne pas oublier vos moyens de communication */
	INSERT into EMAIL (CLI_ID, EML_ID, EML_ADRESSE, EML_LOCALISATION)
	VALUES ('117', '117', 'schmidtarnaud@live.fr', 'Domicile');
	
	INSERT into TELEPHONE (CLI_ID, TEL_ID, TEL_NUMERO, TYP_CODE)
	VALUES ('117', '317', '06-38-66-08-02', 'GSM');

	
/* Vous créez une nouvelle chambre à la date du jour */
	INSERT into CHAMBRE (CHB_ID, CHB_NUMERO, CHB_ETAGE, CHB_BAIN, CHB_DOUCHE, CHB_WC, CHB_COUCHAGE, CHB_POSTE_TEL)
	VALUES ('117', '117', 'RDC', '1', '1', '1', '3', '217');														/* Il y a déjà les 3 couchages */
	
	INSERT into CHB_TRF (CHB_ID, TRF_DATE_DEBUT, TRF_CHB_PRIX)
	VALUES ('117', '2017-05-11', '500');
	

/* Vous serez 3 occupants et souhaitez le maximum de confort pour cette chambre dont le prix est 30% supérieur à la chambre la plus cher */
	/* je passe */
	
	
/* Le règlement de votre facture sera effectué par CB */
	/* je passe */
	
	
/* Une seconde facture a été éditée car le tarif a changé : rabais de 10% */
	/* je passe */
	
	
/* Comment faites-vous ? */
	/* je passe, ce qui, en réalité, n'est pas "faire" grand chose */

















