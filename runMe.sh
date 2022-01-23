#! /bin/bash

. ./.env

# we got a new git repo request, verify that git exists
git_check() {
  if [ -z $(command -v git) ]; then
    echo "git not present, quitting..." >/dev/stderr
    exit $?
  fi
}

# set desired license, if specified
git_license() {
  result=$(read -p "Select mit, gpl2 or gpl3 license [default: ${LICENSE}]: " response; echo $response)	
  result=${result:-$LICENSE}
  case "$result" in
    gpl2)
      curl --silent "https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt" -o ./LICENSE
      ;;
    gpl3)
      curl --silent "https://www.gnu.org/licenses/gpl-3.0.txt" -o ./LICENSE
      ;;
    mit)
      curl --silent "https://raw.githubusercontent.com/bryanpedini-deployments/get.bjphoster.com/master/webroot/MIT_LICENSE" -o ./LICENSE
      #YEAR=$(date +%Y)
      sed -i "s/{YEAR}/$(date +%Y)/" ./LICENSE
      #OWNER=$(git config --get user.name)
      if [ $? -eq 0 ]; then
        sed -i "s/{OWNER}/${userName}/" ./LICENSE
      else
        echo "No user name found, perhaps git is not configured properly, leaving repository owner untouched"
      fi
      ;;
    *)
      echo "Invalid or no license provided, using empty file"
      echo "" > ./LICENSE
  esac
}

commitMk() {
	# from: https://stackoverflow.com/a/41402878
	git commit --allow-empty
	#cat ./.git/COMMIT_EDITMSG 
	#echo -e "\e[1;31mMake your code changes, then type 'exit'... \e[0m"
	#bash --rcfile <(cat ~/.bashrc ; echo 'PS1="\[\033[0;33m\]\u@REPO:\W\$\[\033[00m\] "')
	nano ./README.md
	git commit -a --amend
}

################################
git_check

# import bash functions
git clone https://github.com/zenefono/bash_functions.git
. ./bash_functions/testFunctions.sh

##
#rm -rf ./runMe.sh ./bash_functions

gitUsrName="$userName"
gitUsrEmail="$userEmail"

echo -e "\e[1;31mInit \e[32m\"$repoName\"\e[1;31m git repository di \e[32m$userName\e[1;31m...\e[0m"

if [ ! -f ./LICENSE ]; then
    git_license

fi

if [ ! -f ./.gitignore ]; then
    echo '.env' > ./.gitignore
    echo './runMe.sh' >> ./.gitignore
    echo './bash_functions' >> ./.gitignore
    echo './bash_functions/*' >> ./.gitignore
fi

if [ ! -f ./README.md ]; then
    echo "# $repoName" > ./README.md
    echo "" >> ./README.md
fi
 
if [ ! -d ./.git ]; then
	echo "Inizializzo il repository..."
	git init
fi

git branch -M main
git config --local user.name $userName
git config --local user.email $userEmail
git config --local core.editor $EDITOR

#git add .
git add -A

git commit -m "Initial commit" # non mi piace, vorrei scriverlo prima (commitMk!)

echo "# eseguito il commit iniziale #######################################################"; echo ""
#git config --list; echo ""


# setup git and ssh
if ssh -q git@github.com &>/dev/null; [ $? -eq 255 ]; then
	echo "fail connection to GitHub"
   
	gitLocalUserSetup

	echo "la configurazione di git è:"
	git config --list

	echo ""
	genAndAddSshKey
	goOn
else
	ssh -T git@github.com	# test your SSH connection to GitHub
	echo "successfully authenticated to GitHub!!"
fi

echo ""
echo "testo la connessione ssh con GitHub"
ssh -T git@github.com	# test your SSH connection to GitHub

#commitMk

read -p "Go to https://github.com/new $userName user of GitHub and create a new empty repository named \"$repoName\", then press enter... "
#git remote rm origin
git branch --set-upstream-to=origin/main main
git remote add origin git@github.com:$userName/$repoName.git
git push -u origin main


## https://gist.github.com/robwierzbowski/5430952/
## Create and push to a new github repo from the command line.  
## Grabs sensible defaults from the containing folder and `.gitconfig`.  
## Refinements welcome.

## Gather constant vars
#CURRENTDIR=${PWD##*/}
##GITHUBUSER=$(git config github.user)
#GITHUBUSER=$userName

## Get user input
#read "REPONAME?New repo name (enter for ${PWD##*/}):"
#read "USER?Git Username (enter for ${GITHUBUSER}):"
#read "DESCRIPTION?Repo Description:"

#echo "Here we go..."

## Curl some json to the github API oh damn we so fancy
#curl -u ${USER:-${GITHUBUSER}} https://api.github.com/user/repos -d "{\"name\": \"${REPONAME:-${CURRENTDIR}}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

## Set the freshly created repo to the origin and push
## You'll need to have added your public key to your github account
#git remote set-url origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
#git push --set-upstream origin master

exit 0
