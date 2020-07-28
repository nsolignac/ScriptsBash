lines_seen = set() # holds lines already seen
outfile = open('/tmp/ResultsNoDup.csv', "w")
for line in open('/tmp/Result.csv', "r"):
    if line not in lines_seen: # not a duplicate
        outfile.write(line)
        lines_seen.add(line)
outfile.close()
