#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Uso: $0 <comando>"
	exit 1
fi

comando="$@"
arcivo_log="monitor.log"
grafico="grafica.png"

$comando &
pid=$!

if [ -z "$pid" ]; then
	echo "Error: No se pudo iniciar el proceso "%$comando""
	exit 1
fi

echo "Monitoreando el proceso $comando (PID: $pid)..."
echo "timestamp,cpu,memoria" > $archivo_log


while kill -0 $pid 2>/dev/null; do
	timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	cpu=$(ps -p $pid -o %cpu=)
	mem=$(ps -p $pid -o %mem=)

	echo "$timestamp,$cpu,$mem" >> $archivo_log
	sleep 2
done

echo "El proceso $comando ha terminado. Generando gráfica..."


gnuplot_script="plot_script.gnu"

cat <<EOF > $gnuplot_script
set terminal png size 800,600
set output "$grafico"
set title "Consumo de CPU y Memoria del proceso $comando"
set xlabel "Tiempo"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%s"
set format x "%H:%M:%S"
set ylabel "Uso (%)"
set key outside
plot "$archivo_log" using 1:2 with lines title "CPU (%)", \
     "$aechivo_log" using 1:3 with lines title "Memoria (%)"
EOF

gnuplot $gnuplot_script

echo "Gráfica generada: $grafico"

