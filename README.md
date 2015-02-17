# docker-mahout
Build mahout from source in a docker container

# USAGE

After logging into docker:

<code>
docker run -it -v `<path_to_corpus>`:/data/corpus:ro borromeotlhs/docker-mahout /bin/bash
</code>



assuming you've done the above, and that your corpus is segmented under self-labeled directories, you can train a Complementary NaiveBayes classifier on your corpus with:

<code>
$ ./mahout seqdirectory 
        -i /data/corpus
        -o /data/corpus-seq
        -xm sequential
        -ow
</code>

<code>$ ./mahout seq2sparse 
        -i /data/corpus-seq
        -o /data/corpus-vectors
        -lnorm 
        -nv 
        -wt tfidf
        -ng 3
        -n 2
        --maxDFPercent 85
</code>

<code>$ mahout split 
        -i /data/corpus-vectors/tfidf-vectors 
        --trainingOutput /data/corpus-train-vectors 
        --testOutput /data/corpus-test-vectors  
        --randomSelectionPct 40 
        --overwrite --sequenceFiles -xm sequential
</code>

<code>$ mahout trainnb 
        -i /data/corpus-train-vectors
        -el  
        -o /data/model 
        -li /data/labelindex 
        -ow 
        -c
</code>

(The above command line tells mahout, via the '-el' option, to extract labels and to store them, via the '-li' option, to ${WORK_DIR}/labelindex.
You could, alternatively, utilize the '-l' option to provide your own csv file of labels to utilize on the input)

and will allow us to test with:

<code>
$ mahout testnb 
        -i /data/corpus-test-vectors
        -m /data/model 
        -l /data/labelindex 
        -ow 
        -o /data/corpus-testing 
        -c
</code>

# TODO

You tell me ;)
