#!/bin/bash

        # Finalidade    : GET URL Info
        # Input         : $0 URL
        # Autor         : Marcos de Benedicto
        # Data          : 24/08/2017

SITE_URL=$1
FILE_OUT="./data/${SITE_URL#http://}-$(date +%Y%m%d)"

#Inicializacao
[ ! -f ${FILE_OUT} ] && printf "$(curl -s ${SITE_URL} | md5sum):ok\n" >${FILE_OUT}

#Teste URL
curl ${SITE_URL} -s -o /dev/null --connect-timeout 2
if [ $? -eq 0 ]
then
        HASH_OLD=$(tail -1 ${FILE_OUT} | awk -F":" '{print $1}')
        HASH_NEW=$(curl -s ${SITE_URL} | md5sum)

        #Recuperacao
        if [ "$(tail -1 ${FILE_OUT})" == "0000:nok" ]
        then
                printf "${HASH_NEW}:ok\n" >>${FILE_OUT}
                exit 0
        fi

        #Comparacao de HASH
        if [ "${HASH_OLD}" != "${HASH_NEW}" ]
        then
                printf "0000:nok\n" >>${FILE_OUT}
        else
                printf "${HASH_NEW}:ok\n" >>${FILE_OUT}
        fi
else
        printf "0001:nok\n" >>${FILE_OUT}
fi
