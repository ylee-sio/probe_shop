import sys
def start():

    # These are required inputs
    # name = str(input("What is the gene name? (ex. eGFP) "))
    match_type = str(sys.argv[1])
    name = str(sys.argv[2])
    # fullseq_file_path = str(input("Enter the path to your cleaned sequence text file. "))
    #fullseq_file = open('step4_cleaned_seq/'+match_type+'.'+name+'.cleaned_seq'+'.txt', "r")
    fullseq_file = open(sys.argv[4], "r")
    fullseq = fullseq_file.read()
    fullseq = fullseq.upper()
    amplifier = str(sys.argv[3])
    # amplifier   = str(input("What is the amplifier to be used with this probe set? B1,B2,B3,B4,B5,B7,B9,B10,B11,B13,B14,B15,or B17  ").upper())
    # if amplifier not in ['B1','B2','B3','B4','B5','B7','B9','B10','B11','B13','B14','B15','B17']:
    #    print("That choice was not recognized. Try again. ")
    #    amplifier   = str(input("What is the amplifier to be used with this probe set? B1,B2,B3,B4,B5,B7,B9,B10,B11,B13,B14,B15,or B17  ").upper())


    # Hamdoun lab standard parameter selections
    pause=0
    polyAT=3
    polyCG=3
    choose1='n'
    BlastProbes = 'n'
    db='~/yl_pictus-2/lp_transcriptome/lpdb3/L._pictus_transcriptome.nt'
    dropout='n'
    show='n'
    report='y'
    maxprobe='y'
    numbr=10

    return(name,fullseq,amplifier,pause,choose1,polyAT,polyCG,BlastProbes,db,dropout,show,report,maxprobe,numbr)

"""
    pause = int(input("How many bases from 5' end of the Sense RNA before starting to hybridize? ex. 100 "))
    polyAT = int(input("What is the max acceptable length for polyA or polyT homopolymers? "))
    polyCG = int(input("What is the max acceptable length for polyC or polyG homopolymers? "))
"""

"""
    if (input("Do you want to choose program options?  Y -or- N ")).upper() == 'Y':

        # These are optional inputs
        choose1      = (str(input("Do you want to be able to select between potential longest probe sets? (Choosing 'n' defaults to the first longest set of probes.) Y or N   "))).lower()
        BlastProbes = (str(input("Would you like to BLAST potential probes against a FASTA file?  Y or N   "))).lower()
        #BlastcDNA   = (str(input("Would you like BLAST the input cDNA against a FASTA file for comparison with the BLAST of probes?  Y or N   "))).lower()
        if (BlastProbes).lower() == 'y':
            db          = str(input("Where is the FASTA file you would like to BLAST against? Example: 'C:/users/user/***.fasta' " ))
            show        = (str(input("Do you want to display detailed BLAST outputs? Y or N   "))).lower()
            dropout     = (str(input("Do you want to eliminate probes that appear in low quaility BLAST outputs? Y or N   "))).lower()
        else:
            db = "n"
            show= "n"
            dropout = "n"
        report      = (str(input("Do you want to display chosen parameters in output? Y or N   "))).lower()
        maxprobe    = (str(input("Do you want to limit the number of probes made?  Y or N    "))).lower()
        if maxprobe == 'y':
            numbr   = int(input("Enter a particular number of probes made. The default max is 33.  Enter integer -or- leave empty for default 33 pairs.  ") or "0")    
        else:
            numbr = 0
    else:
        choose1='n'
        BlastProbes='n' 
        #BlastcDNA='n'
        db="n"
        dropout='n'
        show='n'
        report='n'
        maxprobe='n'
        numbr = int(0)
"""

