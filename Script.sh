#!/bin/bash

#! verificamos los parametro pasado al script

if [[ -z $1 || $1 == "-h" || $1 == "-help" || $1 == "-?" ]]; then
	echo "Ayuda:"
	echo "Primer parametro: seller_id ."
	echo "Segundo parametro: site_id ."
 	exit
fi
#!----------------------------------------------

#!busco los articulos y datos de clientes con la api de MeLi y los guardo en una archivo de respaldo
datos_seller = curl -X GET https://api.mercadolibre.com/sites/$2/search?seller_id=$1 ;

#! extraigo del archivo aux el numero de producto y lo guardo en un vector
vec_pro = fgrep -i  \"id\"\: \ \"$2 <<<< datos_seller;

    for i in $vec_pro
    do
	#! corto los tag de los numero de producto
	vec_pro[i]= ${vec_pro[i]:7:-1} ; 
	
	#!con los datos del vector busco con la api de MeLi saco los datos del producto y el numero de la categotia
	datos_producto = curl -X GET https://api.mercadolibre.com/items/$vec_pro[i];

    #! extraigo los numeros de las categorias
    vec_cat[i]= fgrep -i  \"category_id\"\: \ \"$2 <<<< datos_producto  ;
	
	#! extraigo los titulos de los productos
	vec_titulo[i] = fgrep -i  \"title\"\: \ \" <<<< datos_producto  ;
	
	#! corto los tag de las categorias
	vec_cat[i]= ${vec_cat[i]:15:-1} ; 
	
	#! corto los tag de los titulos de los productos
	vec_cat[i]= ${vec_cat[i]:10:-1} ; 
	
	#!con los datos del producto busco con la api de MeLi saco los datos de la categotia
	datos_categoria=curl -X GET https://api.mercadolibre.com/categories/$vec_cat[i] ;
	
	#! extraigo los nombre de las categorias 
	vec_cat_nom[i] = fgrep -i  \"name\"\: \ \" <<<< datos_categoria  ;	
	
	#! corto los tag de los titulos de la categorias
	vec_cat[i]= ${vec_cat[i]:8:-1} ; 
	
		
	echo $vec_pro[i] del ítem, vec_titulo[i] del item, vec_cat[i] donde está publicado, vec_cat_nom[i] de la categoría. >> log.txt
	
	done



