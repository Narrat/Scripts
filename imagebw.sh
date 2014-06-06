#!/bin/bash
# Schwarz-Weiß Scans bearbeiten (Funktioniert mit farbigen Scans so lange keine zu starken Flächen)

if [ $# -ne 1 ] ; then
	echo "Usage: $0 InputBild.Typ OutputBild.Typ"
	exit $E_NO_ARGS
fi

In=$1
Out=$(dirname $In)/$(basename $In .png)_NEW.png
# Out extrahiert den Pfad bis zum Bild mit dirname und wird wieder davorangefügt. Der eigentliche Bildname wird mit basename herausgefiltert (mit Angabe von dem Typ als Argument würde auch dieses rausgeschnitten). Das sorgt insgesamt dafür, dass das Bild wieder im selben Verzeichnis landet

convert $In -normalize -gamma 0.8,0.8,0.8 -colorspace HSL -channel saturation -fx 'min(1.0,max(0.0,3*u.g-1))' -colorspace RGB +dither -posterize 3 $Out


#convert:		Imagemagick-Tool
#normalize:		streckt das Histogramm, so dass schwarz die dunkelste und weiß die hellste Farbe ist
#gamma 0.8,0.8,0.8:	dunkelt Mitteltöne (bei Werten kleiner 1) etwas ab. Buchstaben werden ansonsten zu dünn.
#colorspace HSL:	wandelt RGB-Werte in Hue-Saturation-Lightness-Werte um. Vorbereitung für nächsten Schritt.
#channel saturation:	macht aus Farben mit Sättigung < 33 % grau und Farben mit Sättigung > 67 % eine gesättigte Farbe.
#fx:			Hiermit werden bunte Ränder oder Flecken bei unbunten Vorlagen verringert. Eine nähere Erklärung von -fx findet man in der Dokumentation von convert.
#colorspace RGB:	wandelt HSL-Werte zurück in RGB-Werte um
#+dither:		reduziert in jedem Farbkanal die Zahl der Stufen auf 3 ohne Dithering. Empfehlenswert sind 2 bis 4.
#posterize 3:		Hier wird der Hintergrund richtig einheitlich weiß (oder was auch immer). Rauschen verschwindet bis auf ein paar verstreute Pixel.
