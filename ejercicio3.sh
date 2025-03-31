#!/bin/bash


directorio="/home/usuario/Documentos"
archivo_log="/var/log/documentos.log"

touch "$archivo_log"

echo "Monitoreando $directorio"
inotifywait -m -r -e create,modify,delete "$directorio" --format "%T %w%f %e" --timefmt "%Y-%m-%d %H:%M:%S"
while read fecha archivo evento; do
	echo "$fecha - $evento en $archivo" >> "$archivo_log"
done

