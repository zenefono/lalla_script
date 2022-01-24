#! /bin/bash

# Description: semplice menu in whiptail
###########################

# myFolder="$(pwd)/mieifile"
myFolder="$(pwd)/voci_menu"
myArray=( $(ls -1p $myFolder ) )
#  myArray=( $(ls -1p $myFolder | sed "s/^\(.*\)/'\1'/" ) )

read -p "echo myArray..."
echo "${myArray[*]}"
echo "array of ${#myArray[@]} elements"
read -p "press enter..."
# exit 0

myArray2=("TERMINA " "selezionare per uscire") 
for i in "${myArray[@]}"; do
  myDesc="tail -n +3 $myFolder/$i"
#  myDesc="tail -n+3 $myFolder/$i|head -1"
#  myDesc="head 3 $myFolder/$i"
  # myDesc="sed -n '3p' < $myFolder/$i"
  #myDesc="sed \"1q;d\"  $myFolder/$i"

  echo "$myFolder"
  echo "$myFolder/$i"
# echo "stampo myDesc"
  echo $myDesc
  myDesc1="$($myDesc)"
  echo $myDesc1
  read -p "premi ENTER per continuare... "
  myArray2+=("$i" "$myDesc1")
done

read -p "echo myArray2..."
echo "${myArray2[*]}"
echo "array of ${#myArray2[@]} elements"
read -p "press enter..."

while [ "$result" != "TERMINA " ]; do
  result=$( whiptail --title "xTITLEx" --menu "choose: " 16 78 10 "${myArray2[@]}" 3>&2 2>&1 1>&3 )
  [ "$result" != "TERMINA " ] && cat "$myFolder/${result}" && echo ""
  [ "$result" != "TERMINA " ] && read -p "Press ENTER to continue... "
done


exit 0
