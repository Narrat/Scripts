#!/bin/bash
# Kopiert Flashkram aus /proc
# Unlänglichkeiten:
# * Die vielen Zugriffsverweigerungen (bei nicht Flashkram?)

for FILE in $(lsof -n|grep .tmp.Flash | awk '{print "/proc/" $2 "/fd/" $4}' | sed 's/.$//'); do
	cp -v $FILE $(mktemp -u --suffix=.flv --tmpdir=$HOME/Videos/)
done

#__________
#22:40:32 <phoenix201> hm hat jemand erfahrung darin die src eines flashvideos zu orten, um sie mit mplayer abspielen zu können?
#22:40:48 <kuyatzu> phoenix201: ha
#22:40:51 <kuyatzu> phoenix201: ja*
#22:41:02 <TunnelWicht> phoenix201: puffern lassen und ausm /proc saugen
#22:41:03 <TunnelWicht> :_D
#22:41:06 <TunnelWicht> geht mit allen
#22:41:15 <phoenix201> kuyatzu: hast du vielleicht schon die Videotheke von DMAX geknackt?
#22:41:18 <TunnelWicht> (ich mag linux)
#22:41:25 <phoenix201> TunnelWicht: ich auch :)
#22:41:50 <kuyatzu> phoenix201: /proc/$(pidof $BROWSER)/fd|grep Flash und dann hast du dein flash ^^
#22:41:52 <TunnelWicht> phoenix201: such mal nach "proc linux flash"
#22:41:55 <TunnelWicht> gibt da einige tuts
#22:42:04 <phoenix201> k danke!
#22:42:41 <TunnelWicht> wie gesagt: funzt mit jedem flash-video
#22:42:46 <kuyatzu> phoenix201: wobei du auch einfach ein binary patch ueber flashplugin laufen lassen kannst, dass die links in /tmp/ nicht mehr geloescht werden
#22:43:10 <TunnelWicht> zumindest bei allen die ich ausprobiert habe: yt, vimeo, megavideo und div. andere (megavideo gibts ja nimmer)
#22:43:29 <TunnelWicht> kuyatzu: sowas gibts?
#22:43:32 <phoenix201> und wie macht das youtube-viewer?
#22:43:35 <kuyatzu> TunnelWicht: ja sicher
#22:43:37 <TunnelWicht> wer baut solche bpatches?
#22:43:51 <kuyatzu> phoenix201: der fungiert als ganz normaler browser
#---------------
#21:37:19 <kuyatzu> holgersson: ls -l /proc/$(pgrep dwb)/fd/|grep Flash
#21:37:25 <kuyatzu> holgersson: so mach ich das immer :P
#21:38:01 <holgersson> ich hatte die proc-Variante vergessen...
#21:38:12 <holgersson> bzw vergessen, dass dort ja auch noch Kram liegt
#21:38:47 <holgersson> danke! :)
#21:38:53 <kuyatzu> jo ^^
#21:39:24 <zLouD> wtf
#21:39:43 <surfhai> kuyatzu: funktioniert das mit jedem browser?
#21:40:15 <Rasi> theretisch ja... wobei es bei z.b. chrome schwer wird, da der so viele pids hat
#21:40:19 <Rasi> ;/
#21:40:33 <surfhai> beim firefox wird nix angezeigt wenn ich ein youtube video starte
#21:40:48 <holgersson> beim dwb läuft es