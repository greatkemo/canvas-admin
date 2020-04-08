#!/usr/bin/env bash

# @Author: Kamal Taynaz <GreatKemo>
# @Date:   2020-04-01T16:05:58+03:00
# @Email:  ktaynaz@gmail.com
# @Filename: install.sh
# @Last modified by:   ktaynaz
# @Last modified time: 08-Apr-2020
# @License: GNU General Public License v3.0
# @this is the install script of the canvas-admin workflow for Linux and macOS

export LANG=en_US.UTF-8

# script variables
script_name="$(basename "${0}")"
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
canvas_admin_path="/usr/local/canvas-admin"
canvas_token_doc="https://community.canvaslms.com/docs/DOC-10806-4214724194"

# script functions start here
function usage() {
  #this function displayes the usage message to the user.
  echo "Usage:"
  echo "  sh ${script_name} [option]"
  echo
  echo "Option:"
  echo "  -h, --help      displays usage message"
  echo "  -i, --install   run the install the script"
  echo
  echo "Note:"
  echo "  This script will run you through the necessary steps "
  echo "  to setup the canvas-admin workflow under ${canvas_admin_path}"
  echo
  exit 0
}

function check_root_user() {
  #this function check if the user is root
  if [[ "$(id -u)" -eq "0" ]]; then
    echo "You should not be root or using sudo when running this script"
    echo "switch back to your regular user and run ${script_name} again"
    exit 1
  fi
}

function yes_canvas_token() {
  #if user has a token use this function
  echo "Copy your access token to your clipboard"
  echo "and paste your Access Token below"
  echo
  read -p 'Access Token: ' canvas_token
  echo
  echo "Confirm access token is corrent"
  while true; do
    echo "You entered: ${canvas_token}"
    read -p 'Is this correct? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) echo "Thank you, moving on... "; break;;
        [Nn]* ) echo "Aborting install..."; exit 1;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
}

function no_canvas_token() {
  #if user does not have canvas token use this function
  echo "You do not have an access token"
  echo "Go to ${canvas_token_doc} to learn"
  echo "how to obtain an access token"
  echo "then run ${script_name} again"
  echo
  echo "Aborting install..."; exit 1
}

function canvas_api_setup() {
  #this part is ued to setup url
  echo "Enter your company Canvas URL below "
  echo "example: canvas.company.com or company.instructure.com"
  echo
  read -p 'Canvas URL: ' canvas_url
  echo
  echo "Confirm URL is corrent"
  while true; do
    echo "You entered: ${canvas_url}"
    read -p 'Is this correct? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) echo "Thank you, moving on... "; break;;
        [Nn]* ) echo "Aborting install..."; exit 1;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
  #this part is used to setup access token.
  while true; do
    read -p 'Do you have an Access Token already? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) yes_canvas_token; break;;
        [Nn]* ) no_canvas_token; break;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
  echo "#canvas api variables" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "CANVAS_API_URL=${canvas_url}"  >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "CANVAS_ACCESS_TOKEN=${canvas_token}"  >> "${canvas_admin_path}/env/canvas_admin.shenv"
}

function yes_ldap_setup() {
  #this function will run if user answers yes
  echo "Please enter your company LDAP hostname below"
  echo "example: ldap.company.com"
  echo
  read -p 'LDAP Hostname: ' ldap_hostname
  echo
  echo "Confirm access token is corrent"
  while true; do
    echo "You entered: ${ldap_hostname}"
    read -p 'Is this correct? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) echo "Thank you, moving on... "; break;;
        [Nn]* ) echo "Aborting install..."; exit 1;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
  echo
  echo "Please enter your company LDAP search base below"
  echo "example: ou=staff,dc=company,dc=com"
  echo
  read -p 'LDAP Hostname: ' ldap_searchbase
  echo
  echo "Confirm access token is corrent"
  while true; do
    echo "You entered: ${ldap_searchbase}"
    read -p 'Is this correct? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) echo "Thank you, moving on... "; break;;
        [Nn]* ) echo "Aborting install..."; exit 1;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
  echo "Use the following to map your company LDAP attributes"
  echo "example: user, mail, sn, gn, guid etc"
  echo
  read -p 'Enter LDAP username attribute: ' ldap_user_username
  read -p 'Enter LDAP last name attribute: ' ldap_user_lastname
  read -p 'Enter LDAP first name attribute: ' ldap_user_firstname
  read -p 'Enter LDAP email attribute: ' ldap_user_mail
  read -p 'Enter LDAP user GUID attribute: ' ldap_user_guid
  read -p 'Enter LDAP user affiliation attribute: ' ldap_user_affiliation
  echo
  echo "Confirm LDAP mappings..."
  while true; do
    echo "You entered:"
    echo "${ldap_user_username}"
    echo "${ldap_user_lastname}"
    echo "${ldap_user_firstname}"
    echo "${ldap_user_mail}"
    echo "${ldap_user_guid}"
    echo "${ldap_user_affiliation}"
    read -p 'Is this correct? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) echo "Thank you, moving on... "; break;;
        [Nn]* ) echo "Aborting install..."; exit 1;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done
  echo "#company ldap variables" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_HOST=${ldap_hostname}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_BASE=${ldap_searchbase}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_USERNAME=${ldap_user_username}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_LASTNAME=${ldap_user_lastname}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_FIRSTNAME=${ldap_user_firstname}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_MAIL=${ldap_user_mail}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_GUID=${ldap_user_guid}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
  echo "COMPANY_LDAP_AFFILIATION=${ldap_user_affiliation}:" >> "${canvas_admin_path}/env/canvas_admin.shenv"
}

function no_ldap_setup() {
  #this function will run if user answers no
  echo "This script relies on some form of directory"
  echo "to generate the teacher information, not adding"
  echo "a directory service will make this canvas-admin"
  echo "useless, please setup again and add LDAP."
  echo
  echo "Aborting install..."; exit 1
}

function canvas_ldap_setup() {
  #this will configure ldap based on user input.
  while true; do
    read -p 'Would like to setup LDAP? [Y/n]: ' yes_no
    case ${yes_no} in
        [Yy]* ) yes_ldap_setup; break;;
        [Nn]* ) no_ldap_setup; break;;
        * ) echo "Please answer [Y] for yes or [n] for no:";;
    esac
  done

}


function install_canvas_admin() {
  #copy canvas-admin to /usr/local directory create symlink and permissions
  echo "Copy canvas-admin to /usr/local/canvas-admin..."
  cp -R "${script_path}/canvas-admin" "${canvas_admin_path}"
  echo "Change chmod ${canvas_admin_path} mode to 775"
  chmod -R 755 "${canvas_admin_path}"
  echo "Rename canvas-admin.sh to canvas-admin..."
  mv "${canvas_admin_path}/bin/canvas-admin.sh" "${canvas_admin_path}/bin/canvas-admin"
  echo "Change canvas-admin mode to 755..."
  chmod 755 "${canvas_admin_path}/bin/canvas-admin"
  echo "Install canvas-admin to /usr/local/bin..."
  install "${canvas_admin_path}/bin/canvas-admin" "/usr/local/bin/"
}

function main() {
  #this is the main function to kick-off all other functions
  check_root_user
  install_canvas_admin
  canvas_api_setup
  canvas_ldap_setup

}

# main script
if [[ "${1}" == "" ]]; then
  echo "Usage: sh ${script_name} [option]"
  echo "sh ${script_name} -h for more information"
elif [[ "${1}" == "-h" ]] || [[ "$1" == "--help" ]]; then
  usage
elif [[ "${1}" == "-i" ]] || [[ "$1" == "--install" ]]; then
  main
fi
