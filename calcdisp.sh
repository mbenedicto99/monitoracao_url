#!/bin/bash

        # Finalidade    : GET URL Info
        # Input         : $0 URL
        # Autor         : Marcos de Benedicto
        # Data          : 24/08/2017

DIR_DATA="data/"
HTML="/var/www/html/disp_index.html"

cd ${DIR_DATA}

LISTA_URL=$(ls * | awk -F "-" '{print $1}' | sort -u)

#Formata HTML


echo "
<html>
<head>
<title>
Disponibilidade de Sistemas
</title>
</head>
<body>
<h1> Disponibilidade </h1> ">${HTML}

for SITE in ${LISTA_URL}
do

        FILE=$(ls ${SITE}* | tail -1)
        NUM_OK=$(grep -c ":ok" ${FILE})
        NUM_LN=$(wc -l ${FILE} | sed -e s'# '${FILE}'##g' )
        NUM=$(echo "scale=4; ${NUM_OK} / ${NUM_LN} * 100" | bc)

        echo "
                <h2> $(date +%d)/$(date +%m) - ${SITE} ${NUM}% </h2>

        " >>${HTML}

done

echo "
</body>
</html>">>${HTML}
