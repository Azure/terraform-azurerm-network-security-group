#!/bin/bash

# This script generates the specialized modules based on the content of rules.tf file.

MODULE_NAME=""

while read -r LINE
  do 

    if [[ $LINE == "default = {" ]]; then
      DEFAULT=true
    fi 

    if [[ $LINE =~ \# ]] && [[ $DEFAULT = true ]]; then
      #echo "line=$line" 
      MODULE_NAME=$(echo $LINE | sed -e 's/#//' | tr -d '\n')
      #echo $MODULE_NAME
      if [ ! -d "../modules/$MODULE_NAME/" ]; then
         # Create directory if does not exist
         mkdir "../modules/$MODULE_NAME"
      fi 
      cp ../modules/_template/* "../modules/$MODULE_NAME/"
      continue
    fi 

    if [[ $LINE =~ $MODULE_NAME ]]; then
      RULE_NAME=$(echo $LINE | cut -d"=" -f1 )
      #Add a rule entry for each rule
      sed -i '' '/predefined_rules/ a\ 
               {\
                   name = \"'"$RULE_NAME"'\"\
               },\
               ' ../modules/$MODULE_NAME/main.tf
   
    fi

  done < <(cat ../rules.tf)
