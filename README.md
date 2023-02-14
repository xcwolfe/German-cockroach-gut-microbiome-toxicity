# German-cockroach-gut-microbiome-toxicity
This repository includes the necessary files to run Mothur and subsequent R commands for the journal article titled: "Differential Toxicity and Microbial Responses to Antibiotic Treatments by Insecticide-resistant and Susceptible Cockroach Strains (Blattella germanica L.)"

# Mothur pipeline log
# Before mothur:

Create an excel sheet called “analysis”

•	Makes excel sheet of fastq files to perform make.file

# Mothur steps:

`mothur > make.file(inputdir=., type=fastq, prefix=analysis)`

•	Imported my excel file “analysis” which describes my fastq files and their respective titles (treatment types)

`mothur > make.contigs(file=analysis.files, processors=8)`

•	made contigs out of my excel file “analysis” describing my fastq files

`mothur > summary.seqs(fasta=analysis.trim.contigs.fasta)`

•	Looked at the summary of my trimmed contig files
•	Average sequence length was ~304 bp
    i.	355 bp (average read on MiSeq run) – 50 bp (trimmed on mothur)
    
`mothur > screen.seqs(fasta=analysis.trim.contigs.fasta, group=analysis.contigs.groups, maxambig=0, maxlength=325)`

•	Eliminated any ambiguities as well as any sequences > 325 bp (Less than 2.5% of all sequences)

`mothur > unique.seqs(fasta=analysis.trim.contigs.good.fasta)`

•	Got only unique sequences, merge duplicates

`mothur > count.seqs(name=analysis.trim.contigs.good.names, group=analysis.contigs.good.groups)`

•	This will generate a file called analysis.trim.contigs.good.count_table. In subsequent commands we'll use it by using the count option

`mothur > summary.seqs(count=analysis.trim.contigs.good.count_table)`

•	Summary count of the unique sequence table we just made

	Before pcr.seqs:
    
•	Used https://mothur.org/blog/2016/Customization-for-your-region/ to find E. coli reference for my primer set

•	My primers:

    i.	338F: ACTCCTACGGGAGGCAGCAG
    ii.	518R: ATTACCGCGGCTGCTGG
    iii.	Reverse complement of 518R: TAATGGCGCCGACGACC
    iv.	Reverse of iii: CCAGCAGCCGCGGTAAT
    v.	FINAL E. COLI REFERENCE SEQUENCE:  ACTCCTACGGGAGGCAGCAGTGGGGAATATTGCACAATGGGCGCAAGCCTGATGCAGCCATGCCGCGTGTATGAAGAAGGCCTTCGGGTTGTAAAGTACTTTCAGCGGGGAGGAAGGGAGTAAAGTTAATACCTTTGCTCATTGACGTTACCCGCAGAAGAAGCACCGGCTAACTCCGTGCCAGCAGCCGCGGTAAT

•	Created e.coli.v4.txt, a .txt file of my reference sequence

•	Downloaded silva.nr_v138.tgx; will use as the SILVA seed reference file

•	Unzipped silva.nr_v138.tgx using tar -xzf

    i.	Created silva.nr_v138.align and silva.nr_v138.tax

`mothur > align.seqs(fasta=e.coli.v4.txt, reference=silva.nr_v138.align)`

`mothur > summary.seqs(fasta=e.coli.v4.align)`

`mothur > pcr.seqs(fasta=silva.nr_v138.align, start=6334, end=13862, keepdots=FALSE)`

•	Coordinates used to trim silva.nr: Start=6334, end=13862

`mothur > rename.file(input=silva.nr_v138.pcr.align, new=silva.v4.fasta)`

•	Renamed the output file of pcr.seqs to silva.v4.fasta

`mothur > align.seqs(fasta=analysis.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)`

•	Aligned my trimmed sequences to the trimmed reference database

`mothur > summary.seqs(fasta=analysis.trim.contigs.good.unique.align, count=analysis.trim.contigs.good.count_table)`

•	View summary of align.seqs

`mothur > screen.seqs(fasta=analysis.trim.contigs.good.unique.align, count=analysis.trim.contigs.good.count_table, summary=analysis.trim.contigs.good.unique.summary, start=52, end=7528, maxhomop=8)`

•	Trimmed the sequences from start position 52 to end position 7528

`mothur > filter.seqs(fasta=analysis.trim.contigs.good.unique.good.align, vertical=T, trump=.)`

•	Pull out columns in alignment with overhangs and gap characters (“-“)

`mothur > unique.seqs(fasta=analysis.trim.contigs.good.unique.good.filter.fasta, count=analysis.trim.contigs.good.good.count_table)`

•	Get unique sequences after the filter we just performed

`mothur > pre.cluster(fasta=analysis.trim.contigs.good.unique.good.filter.unique.fasta, count=analysis.trim.contigs.good.unique.good.filter.count_table, diffs=2)`

•	This command will split the sequences by group and then sort them by abundance and go from most abundant to least and identify sequences that are within 2 nt of each other. If they are then they get merged

`mothur > chimera.vsearch(fasta=analysis.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.count_table, dereplicate=t)`

•	Search for chimeras to later remove

`mothur > remove.seqs(fasta=analysis.trim.contigs.good.unique.good.filter.unique.precluster.fasta, accnos=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos)`

•	Removes chimeras (7041 sequences total)

`mothur > classify.seqs(fasta=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, reference=silva.nr_v138.align, taxonomy= silva.nr_v138.tax, cutoff=80)`

•	Classify sequences by kingdom so we can later remove undesirable lineages

`mothur > remove.lineage(fasta=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.nr_v138.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)`

•	Removes non-bacterial sequences

•	Skipped assessing error rates because no mock dataset was used

`mothur > dist.seqs(fasta=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, cutoff=0.03)`

`mothur > cluster(column=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)`

•	Cluster sequences into OTUs

`mothur > make.shared(list=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, label=0.03)`

•	Know how many sequences are in each OTU group

`mothur > classify.otu(list=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=analysis.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy= analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.nr_v138.wang.taxonomy, label=0.03)`

•	Know the taxonomy for each OTU

•	OTU table complete!

# Analysis:

`mothur > rename.file(taxonomy=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared)`

•	Renamed my shared and taxonomy file to make my downstream analysis easier to type

`mothur > count.groups(shared=analysis.opti_mcc.shared)`

•	see how many sequences we have in each sample

`mothur > sub.sample(shared=analysis.opti_mcc.shared, size=24390)`

•	Jwax Kan 3 is our smallest dataset at 24390 sequences. We will make a subsample of all our data using this parameter

# Lefse:

Created straindesign.txt in notepad:

•	Created straindesign using interactiondesign and editing the last column

•	Removed dashes in straindesign in notepad

`mothur > lefse(shared=analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared, design=straindesign.txt)`

•	Ran lefse with analysis.opti_mcc.0.03.subsample.shared 
