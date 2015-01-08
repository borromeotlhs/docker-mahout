# docker-mahout
Build mahout from source in a docker container

# USAGE

After logging into docker:

<code>
docker run -it -v <path_to_corpus>:/data/corpus:ro borromeotlhs/mahout:v0.9 /bin/bash
</code>



assuming you've done the above, you can train a Complementary NaiveBayes classifier on your corpus with:

<code>
$ mahout seqdirectory 
        -i /data/corpus
        -o /data/corpus-seq 
        -ow
</code>

<code>$ mahout seq2sparse 
        -i /data/corpus-seq
        -o /data/corpus-vectors
        -lnorm 
        -nv 
        -wt tfidf
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
Have to add mahout to the PATH, so that you don't need to call it with:

<code>./mahout</code>
