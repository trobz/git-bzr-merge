load test_helper

@test "multiple push without filter" {
    cd $TEST_FOLDER/git
    git bzr-merge push $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat git_master_file.txt` == "git master file" ]]
    test="[merge] git branch 'master' into bzr branch 'feature'"
    [[ "`bzr log -r-1 --line`" == *"$test"* ]]

    # test second push, after modif on git repo
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > git_master_file.txt
    git commit -a -m "git commit 2"

    git bzr-merge push $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `cat git_master_file.txt` == "text modified" ]]

}


@test "multiple push without filter (remember)" {
    cd $TEST_FOLDER/git
    git bzr-merge push --remember $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat git_master_file.txt` == "git master file" ]]
    test="[merge] git branch 'master' into bzr branch 'feature'"
    [[ "`bzr log -r-1 --line`" == *"$test"* ]]

    # test second push, after modif on git repo
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > git_master_file.txt
    git commit -a -m "git commit 2"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `cat git_master_file.txt` == "text modified" ]]
}


@test "multiple push with filter" {
    cd $TEST_FOLDER/git
    # create a module folder on git
    mkdir moduleB
    echo "moduleB text" > moduleB/git_file.txt
    git add moduleB
    git commit -m "git moduleB commit 1"

    git bzr-merge push --filter moduleB $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat moduleB/git_file.txt` == "moduleB text" ]]
    test="[merge] git branch 'master' into bzr branch 'feature' with filter: 'moduleB'"
    [[ "`bzr log -r-1 --line`" == *"$test"* ]]

    # test second push, after modif on git repo
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > moduleB/git_file.txt
    git commit -a -m "git moduleB commit 2"

    git bzr-merge push --filter moduleB $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `cat moduleB/git_file.txt` == "text modified" ]]
}


@test "multiple push with filter (remember)" {
    cd $TEST_FOLDER/git
    # create a module folder on git
    mkdir moduleB
    echo "moduleB text" > moduleB/git_file.txt
    git add moduleB
    git commit -m "git moduleB commit 1"

    git bzr-merge push --remember --filter moduleB $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat moduleB/git_file.txt` == "moduleB text" ]]
    test="[merge] git branch 'master' into bzr branch 'feature' with filter: 'moduleB'"
    [[ "`bzr log -r-1 --line`" == *"$test"* ]]

    # test second push, after modif on git repo
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > moduleB/git_file.txt
    git commit -a -m "git moduleB commit 2"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `cat moduleB/git_file.txt` == "text modified" ]]
}

@test "multiple push with wildcard filter" {
    cd $TEST_FOLDER/git
    # create a module folder on git
    mkdir {moduleB,moduleC}
    echo "moduleB text" > moduleB/git_file.txt
    echo "moduleC text" > moduleC/git_file.txt
    git add module*
    git commit -m "git module* commit 1"

    git bzr-merge push $TEST_FOLDER/bzr feature --filter "module*" --remember

    cd $TEST_FOLDER/bzr/feature

    [[ `ls | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 4 ]]
    [[ `cat moduleB/git_file.txt` == "moduleB text" ]]
    [[ `cat moduleC/git_file.txt` == "moduleC text" ]]
    test="[merge] git branch 'master' into bzr branch 'feature' with filter: 'module*'"
    [[ "`bzr log -r-1 --line`" == *"$test"* ]]

    # test second push, after modif on git repo
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > moduleB/git_file.txt
    echo "text modified" > moduleC/git_file.txt
    git commit -a -m "git module* commit 2"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    [[ `bzr log --line | wc | awk '{ print $1 }'` -eq 5 ]]
    [[ `cat moduleB/git_file.txt` == "text modified" ]]
    [[ `cat moduleC/git_file.txt` == "text modified" ]]
}
