#!/usr/bin/env bash
# @Author: Kamal Taynaz <GreatKemo>
# @Date:   08-Apr-2020
# @Email:  ktaynaz@gmail.com
# @Filename: canvas-mailto.sh
# @Last modified by:   GreatKemo
# @Last modified time: 09-Apr-2020
# @License: GNU General Public License v3.0

#this script will email files to the admin.
#source ldap variables from env directory
source /usr/local/canvas-admin/env/canvas_admin.shenv

# variables related to the logged in admin and mail message
LOCAL_USER_ID="$(whoami)"
LOCAL_USER_EMAIL="$(ldapsearch -x -LLL -h "${COMPANY_LDAP_HOST}" -b \
"${COMPANY_LDAP_BASE}" "(${COMPANY_LDAP_USERNAME}=${LOCAL_USER_ID})" \
"${COMPANY_LDAP_MAIL}" | grep "${COMPANY_LDAP_MAIL}" | awk '{print $2}')"
MAIL_MESSAGE="Your requested files(s) attached."

#email message to be send using mailx.
echo "${MAIL_MESSAGE}" | mailx -s "[Cavnas Admin] Files Attached - $(date)" \
 -a "${1}" "${LOCAL_USER_EMAIL}"
