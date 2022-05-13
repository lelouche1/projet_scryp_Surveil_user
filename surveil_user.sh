#!/bin/bash

source fonctions.sh



	test_argument $@

	arg=$?

	sleep 3

	if [[ $arg -eq 0 ]]
	then

		echo -e "\n INFORMATION SUR LES DERNIERES CONNEXION DE: $1 \n \n" 

		derniere_connexion $@
		
		echo -e "\n JOURNALISATION DE L'UTILISATEUR: $1 \n \n" 

		sleep 3

		journaliser_connexion $@
		
		sleep 3
		
		echo -e "\n AFFICHAGE DE L'AIDE  \n \n" 

		HELP

	fi
	
	echo -e "\n AFFICHAGE DES INFOS UTILISATEURS  \n \n" 	
	info_auteur


	echo `clear`
