from start import start
from maker37cb import maker
from contextlib import suppress

with suppress(Exception):
	strt = start()
	name,fullseq,amplifier,pause,choose,polyAT,polyCG,BlastProbes,db,dropout,show,report,maxprobe,numbr = strt[0],strt[1],strt[2],strt[3],strt[4],strt[5],strt[6],strt[7],strt[8],strt[9],strt[10],strt[11],strt[12],strt[13]
	maker(name,fullseq,amplifier,pause,choose,polyAT,polyCG,BlastProbes,db,dropout,show,report,maxprobe,numbr)
