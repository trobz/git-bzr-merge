load test_helper


@test "multiple pull without filter" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull $TEST_FOLDER/bzr feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat moduleA/bzr_file.txt` == "feature file" ]]
    test="[merge] bzr branch 'feature' into git branch 'master'"
    [ "`git log --merges --format=%B`" == "$test" ]

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull $TEST_FOLDER/bzr feature
    [[ `cat moduleA/bzr_file.txt` == "text modified" ]]
    [ "`git log --all --grep='moduleA commit 2'`" != "" ]
}

@test "multiple pull without filter (remember)" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember $TEST_FOLDER/bzr feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat moduleA/bzr_file.txt` == "feature file" ]]
    test="[merge] bzr branch 'feature' into git branch 'master'"
    [ "`git log --merges --format=%B`" == "$test" ]

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull
    [[ `cat moduleA/bzr_file.txt` == "text modified" ]]
    [ "`git log --all --grep='moduleA commit 2'`" != "" ]
}

@test "multiple pull with filter" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --filter moduleA $TEST_FOLDER/bzr feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 2 ]]
    [[ `cat moduleA/bzr_file.txt` == "feature file" ]]
    test="[merge] bzr branch 'feature' into git branch 'master' with filter: 'moduleA'"
    [ "`git log --merges --format=%B`" == "$test" ]

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull --filter moduleA $TEST_FOLDER/bzr feature
    [[ `ls | wc | awk '{ print $1 }'` -eq 2 ]]
    [[ `cat moduleA/bzr_file.txt` == "text modified" ]]
    [ "`git log --all --grep='moduleA commit 2'`" != "" ]
}

@test "multiple pull with filter (remember)" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember --filter moduleA $TEST_FOLDER/bzr feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 2 ]]
    [[ `cat moduleA/bzr_file.txt` == "feature file" ]]
    test="[merge] bzr branch 'feature' into git branch 'master' with filter: 'moduleA'"
    [ "`git log --merges --format=%B`" == "$test" ]

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull
    [[ `ls | wc | awk '{ print $1 }'` -eq 2 ]]
    [[ `cat moduleA/bzr_file.txt` == "text modified" ]]
    [ "`git log --all --grep='moduleA commit 2'`" != "" ]
}


@test "multiple pull with wildcard filter" {
    # add a second folder matching with the wildcard
    cd $TEST_FOLDER/bzr/feature
    mkdir moduleB
    echo "moduleB text" > moduleB/bzr_file.txt
    bzr add moduleB
    bzr commit -m "feature moduleB commit 1"

    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember --filter "module*" $TEST_FOLDER/bzr feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 3 ]]
    [[ `cat moduleA/bzr_file.txt` == "feature file" ]]
    [[ `cat moduleB/bzr_file.txt` == "moduleB text" ]]
    test="[merge] bzr branch 'feature' into git branch 'master' with filter: 'module*'"
    [ "`git log --merges --format=%B`" == "$test" ]

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull
    [[ `ls | wc | awk '{ print $1 }'` -eq 3 ]]
    [[ `cat moduleA/bzr_file.txt` == "text modified" ]]
    [ "`git log --all --grep='moduleA commit 2'`" != "" ]
}
