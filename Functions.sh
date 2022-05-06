#!/bin/bash

#fonction show_usage
show_usage()
{
	if [ $# -ne 0 ];then #compte le nombre d'argument supérieur à 0
		echo "Usage échoué"
	else 
		echo "surveiller.sh: [-h] [-d] [-s] [-j] [-v] [-g] [-m] user.."
	fi
}


#fonction Help
Help()
{
	chemin=Help
	cat $chemin
}

infoAuteur()
{
	chemin=version
	cat $chemin
}

#afficher dernieres connexions
connexions()
{
	fich=/var/log/auth.log
	cat $fich	
}

#fonction journal
journaliser()
{
	last -F $1 >> journal 
	error=$?
	if [[ $error -eq 0 ]]
	then 
		echo "Enregistrement reussi"
		date +"%d-%m-%y" >> $journal 2>&1
		cat journal
	else 
		echo "Echec enregistrement"
	fi 
}

# fonction du menu textuel
menuTextuel()
{
	PS3="Veuillez choisir: "
	
	select item in "- Help -" "- Menu graphique -" "- Auteurs et version du code -" 			"- Dernieres connexions -" "- Supprimer -" "-Journaliser -" "- Fermer le programme -"

	do 
		echo "Vous avez choisi l'option $REPLY : $item"
		 case $REPLY in 
			h) echo "Help"
			   Help
			   ;;
			
			g) echo "Menu graphique"
			   menuGraphique
			   ;;

			v) echo "Auteurs et version du code"
			   infoAuteur
			   ;;

			d) echo "Derniere connexions"
			   connexions
			   ;;

			s) echo "Supprimer"
			   read nom
			   supprimer_log "$nom"
			   ;;

			j) echo "Journaliser"
			   read nom
			   journaliser_connexion "$nom"
			   ;;

			e) echo "Au revoir"
			   exit
			   ;;
		 esac
		 #clear
	done
}

#fonction menu graphique
menugraphique()
{
	action=$(yad --entry --title "Menu graphique" --text " Choississez une option\n-h : Help\n-v : Version du code\n-m : Menu textuel\n-d : Dernieres connexions\n-s : Supprimer\n-j : journaliser" )

	action=$(echo "$action")

	case $action in
			h) Help
			   ;;

			v) infoAuteur
			   ;;

			m) menu_textuel
			   ;;

			d) derniere_connexion
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
while getopts "hgvmds:j:" option
do
	case $option in
			h) Help
			   ;;

			g) menugraphique
			   ;;
			
			v) infoAuteur
			   ;;

			m) menuTextuel
			   ;;

			d) connexions
			   ;;

			s) supprimer "$OPTARG"
			   ;;

			j) journaliser "$OPTARG"
			   ;;
esac
done
exit 0
