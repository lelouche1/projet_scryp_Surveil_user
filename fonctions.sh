#!/bin/bash

#cette fonction affiche un message sur les options du programme


journal="journat.txt"

show_usage(){

	message="[-h] [-d] [-s] [-j] [-v] [-g] [-m] user... "

	echo "$message";
}

#####################################################

#cette fonction renvoie 0 si on passe au moins un parametre et 1 sinon

test_argument(){

	if [[ $# -gt 0 ]]
	then
		echo " votre parametre est : $1 "  
		return 0		
	else
		echo " vous devez passer au moins un parametre "
		return 1
	fi
}

###################################################

#cette fonction charge le fichier aide qui contient le mode d'emploi du programme

HELP(){
	
	cat aide.txt
}

###################################################

#cette fonction affiche la derniere connexion d'un utilisateur passé en parametre

derniere_connexion(){

	test_argument $@
	param=$?

	if [[ $param -eq 0 ]]
	then
		id -u $1			#on verifie si l'utilisateur existe dans le systeme
		iuduser=$?
		if [[ $iuduser -eq 0 ]]
		then
			last -F $1 
		else
			echo "cet utilisateur n'existe pas ! "
		fi		
	fi
}

#####################################################

#fonction qui creer un fichier journal qui enregistre les connextions

log_connexion(){

	last -F $1 >> $journal 2>&1
	erreur_log=$1
	if [[ $erreur_log -eq 0 ]]
	then
		echo "enregistrement dans journal reussit"
		date +"%d-%m-%y" >> $journal 2>&1
	else
		echo "echec enregistrement"
	fi
}


###########################################################

#fonction supprimer connexion de plus de 7 jours

supprimer_log(){

	$ awk -F'[ ]' 'NR==1 || (systime()-mktime($3" "$2" "$1" 0 0 0")) <= 7*24*60*60' $journal
}

##########################################################

info_auteur(){
	cat version.txt
}

menu_textuel(){



while [[ $choix -ne 3 ]]
do 
	
        echo "1) afficher les etats de connexion d'un utilisateur" 
        echo "2) Lancer la fonction Verifier paramêtres"  
        echo "3) QUITTER"
        read -p "DOnner une valeur compris entre 1 et 4" choix
        
        read -p "faite un choix: " choix
        
        case $choix in 
                1) derniere_connexion $OPTARG
                ;;
                2) info_auteur
                ;;
                3) echo "On quitte"
                return
                ;;
                3) 
                ;;
                4) echo "On quitte"
                return
                ;;
                *) echo "Mauvais votre choix (1,2 ou 3 pour quitter "
	esac
	
	sleep 5
	clear
}

#fonction pour creer les options

	while getopts "hgvmd:s:j:" options
	do
	case $options in
		h)HELP
		;;
		g)menu_graphique
		;;
		v)info_auteur
		;;
		m)menu_textuel
		;;
		d)derniere_connexion $OPTARG
		;;
		s)supprimer_log $OPTARG
		;;
		j)log_connexion $OPTARG
		;;
	esac
	done
