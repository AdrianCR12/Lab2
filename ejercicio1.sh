#!/bin/bash

if ["$(id -u)" -ne 0 ]; then
	echo "Error: Este script debe ejecutarse como root.">&2
	exit 1
fi

if [ "$#" -ne 3 ]; then
	echo "Uso: $0 <usuario> <grupo> <ruta_archivo>" >&2
	exit 1
fi

USUARIO=$1
GRUPO=$2
ARCHIVO=$3

if [ ! -e "$ARCHIVO" ]; then
	echo "Error: El archivo $ARCHIVO no existe." >&2
	exit 1
fi

if getent group "$GRUPO" > /dev/null; then
	echo "El grupo $GRUPO ya existe"
else 
	groupadd "$GRUPO"
	echo "Grupo $GRUPO creado."
fi

if id "$USUARIO" > /dev/null 2>&1; then
	echo "El usuario "$GRUPO" ya existe."
else
	useradd -m -g "$GRUPO" "$USUARIO"
	echo "Usuario $USUARIO creado y agregado al grupo $GRUPO."
fi

usermod -aG "$Grupo" "$USUARIO"

chown "$USUARIO:$GRUPO" "$ARCHIVO"

chmod 740 "$ARCHIVO"

echo "Porpietario y permisos del archivo $ARCHIVO modificados correctamente"

