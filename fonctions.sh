#!/bin/bash

#cette fonction affiche un message sur les options du programme


journal="journal.txt"

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

journaliser_connexion(){

	last -F $1 >> $journal 2>&1
	erreur_log=$?
	if [[ $erreur_log -eq 0 ]]
	then
		echo "enregistrement dans journal reussit"
		#date +"%d-%m-%y" >> $journal 2>&1
	else
		echo "echec enregistrement utilisateur non existant"
	fi
}


###########################################################

#fonction supprimer connexion de plus de 7 jours

supprimer_log(){

#	$ awk -F'[ ]' 'NR==1 || (systime()-mktime($3" "$2" "$1" 0 0 0")) <= 7*24*60*60' $journal
	sed '/Fri/!d' journal.txt > journal2.txt
	rm -r journal.txt
	mv journal2.txt journal.txt

}

##########################################################

info_auteur(){
	cat version.txt
}


########################################################

#fonction qui afiche le menu textuel

menu_textuel(){

PS3="Veuilez choisir: "
select item in "- Help -" "- Menu grahique -" "- Auteur et version du code -" "- Dernière connexions -" "- Supprimer -" "- Journaliser -" "- Fermer le programe -"
do 
	
        echo "Vous avez choisi l'option $REPLY : $item"
        case $REPLY in 
                h) echo "Help"
				  HELP
  				;;

				g) echo "Menu grahique"
				   menu_graphique
  				;;

				v) echo "Auteur et version du code"
				   info_auteur
  				;;

				d) echo "Dernière connexions"
				   echo "Nom d'utilisateur"
  		   		   read nom
		  		   derniere_connexion "$nom"
		  		;;

				s) echo "Supprimer"
				   echo "Nom d'utilisateur"
		  		   read nom
		  		   supprimer_log "$nom"
		 		;; 

				j) echo "Journaliser"
				   echo "Nom d'utilisateur"
		  		   read nom
		  		   journaliser_connexion "$nom"
		  		;;
		  		
		  		e) echo "Au revoir"
		  		   exit
		  		;;
		esac
		#sleep
		#clear
done
}

######################################################################################


menu_textuel2(){
	
	
	echo "h- Help -" 
	echo "g- Menu grahique -" 
	echo "v- Auteur et version du code -"
	echo "d- Dernière connexions -" 
	echo "s- Supprimer -" 
	echo "j- Journaliser -" 
	echo "e- Fermer le programe -"
	

	while [[ $choix != 'e' ]] 
	do 
		read -p "Veuilez choisir: " choix

        case $choix in 
                h) 
				  HELP
  				;;

				g) 
				   menu_graphique
  				;;

				v) 
				   info_auteur
  				;;

				d) 
				   read -p "Nom d'utilisateur " nom
		  		   derniere_connexion "$nom"
		  		;;

				s) 
				   read "Nom d'utilisateur " nom
		  		   supprimer_log "$nom"
		 		;; 

				j) 
				   read "Nom d'utilisateur " nom
		  		   journaliser_connexion "$nom"
		  		;;
		  		
		  		e) echo "Au revoir"
		  		   exit
		  		;;
		esac
		#sleep
		#clear
done
}





#####################################################################################

#affichage version

version(){

	cat version.txt

}

#fonction pour creer les options

option(){
	while getopts "hgvmd:s:j:" options
	do
	case $options in
		h)HELP
		;;
		g)menu_graphique
		;;
		v)info_auteur
		;;
		m)menu_textuel2
		;;
		d)derniere_connexion $OPTARG
		;;
		s)supprimer_log $OPTARG
		;;
		j)log_connexion $OPTARG
		;;
	esac
	done
}


#fonction pour creer les options


#fonction menu graphique
menu_graphique()
{
	action=$(yad --entry --title "Menu graphique" --text " Choississez une option\n-h : Help\n-v : Version du code\n-m : Menu textuel\n-d : Dernieres connexions\n-s : Supprimer\n-j : journaliser" )

	action=$(echo "$action")

	case $action in
		h) HELP
  		;;

		v) info_auteur
  		;;

		m) menu_textuel2
  		;;

		d) echo "Nom d'utilisateur"
  		   read nom
  		   derniere_connexion "$nom"
  		;;

		s) echo "Nom d'utilisateur"
  		   read nom
  		   supprimer_log "$nom"
 		;; 

		j) echo "Nom d'utilisateur"
  		   read nom
  		   journaliser_connexion "$nom"
  		;;
esac
}

#declaration des options

	if [ "$#" -eq 0 ]
	then
	show_usage
	fi

	while getopts "hgvmd:s:j:" options
		do
		case $options in
			h) HELP
			;;
			
			g) menu_graphique
			;;
			
			v) info_auteur
			;;
			
			m) menu_textuel2
			;;
			
			d) derniere_connexion $OPTARG
			;;
			
			s) supprimer_log $OPTARG
			;;
			
			j) journaliser_connexion $OPTARG
			;;
		esac
	done
	exit 0
