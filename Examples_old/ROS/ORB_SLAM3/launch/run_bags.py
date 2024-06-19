import os

import subprocess
import sys

def run_bags(bagdir, outputdir, script):
    baglist = []
    for root, dirs, files in os.walk(bagdir):
        for file in files:
            if file.endswith("_aligned.bag"):
                bagfile = os.path.join(root, file)
                baglist.append(bagfile)

    print("Found {} bags in {}".format(len(baglist), bagdir))
    for b, bagfile in enumerate(baglist):
        print("{} : {}".format(b, bagfile))
    
    for b, bagfile in enumerate(baglist):
        print("Processing bagfile: {}".format(bagfile))
        bn = os.path.basename(bagfile)
        dn = os.path.dirname(bagfile)
        date = os.path.basename(dn)
        run = bn.split("_")[0]
        outfolder = os.path.join(outputdir, date, run)
        os.makedirs(outfolder, exist_ok=True)
        log_file = os.path.join(outfolder, "log.txt")
        cmd = "sh {} {} {} 2>&1 | tee {}".format(script, bagfile, outfolder, log_file)
        print("Running cmd: {}".format(cmd))
        subprocess.call(cmd, shell=True, stdout = sys.stdout)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python run_bags.py bagdir outputdir [script=run_bag.sh]")
        sys.exit(1)
    bagdir = sys.argv[1]
    outputdir = sys.argv[2]
    # get the full filename for this script file
    thisscript = os.path.realpath(__file__)
    if len(sys.argv) == 4:
        bashscript = sys.argv[3]
    else:
        bashscript = os.path.join(os.path.dirname(thisscript), "run_bag.sh")

    run_bags(bagdir, outputdir, bashscript)
    print("Done")
