#! /bin/bash

# Description: semplice menu in whiptail
###########################

myFolder="$(pwd)/mieifile"
# myFolder="./voci_menu"
myArray=( $(ls "$myFolder") )

myArray2=("TERMINA " "selezionare per uscire") 
for i in "${myArray[@]}"; do
 myDesc="head -3 $myFolder/$i"
  # myDesc="sed -n '3p' < $myFolder/$i"
  #myDesc="sed \"1q;d\"  $myFolder/$i"
  myArray2+=("$i" "$($myDesc)")
done

while [ "$result" != "TERMINA " ]; do
  result=$( whiptail --title "xTITLEx" --menu "choose: " 16 78 10 "${myArray2[@]}" 3>&2 2>&1 1>&3 )
  [ "$result" != "TERMINA " ] && cat "$myFolder/${result}" && echo ""
  [ "$result" != "TERMINA " ] && read -p "Press ENTER to continue... "
done


exit 0
