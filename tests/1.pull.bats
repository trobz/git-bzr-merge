load test_helper

@test "pull without filter" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull $TEST_FOLDER/bzr feature

    check_ls_length 4
    check_file_content moduleA/bzr_file.txt "feature file"
    check_git_has_commit "bzr branch 'feature' into git branch 'master'"

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull --remember $TEST_FOLDER/bzr feature

    check_file_content moduleA/bzr_file.txt "text modified"
    check_git_has_commit "moduleA commit 2"

    # test third pull with remember option
    cd $TEST_FOLDER/bzr/feature
    echo "text modified 2" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 3"

    cd $TEST_FOLDER/git
    git bzr-merge pull

    check_file_content moduleA/bzr_file.txt "text modified 2"
    check_git_has_commit "moduleA commit 3"

}

@test "pull with filter" {
    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --filter moduleA $TEST_FOLDER/bzr feature

    check_ls_length 2
    check_file_content moduleA/bzr_file.txt "feature file"
    check_git_has_commit "bzr branch 'feature' into git branch 'master' with filter: 'moduleA'"

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull --remember --filter moduleA $TEST_FOLDER/bzr feature

    check_ls_length 2
    check_file_content moduleA/bzr_file.txt "text modified"
    check_git_has_commit "moduleA commit 2"

    # test third pull with remember option
    cd $TEST_FOLDER/bzr/feature
    echo "text modified 2" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 3"

    cd $TEST_FOLDER/git
    git bzr-merge pull --remember --filter moduleA $TEST_FOLDER/bzr feature

    check_ls_length 2
    check_file_content moduleA/bzr_file.txt "text modified 2"
    check_git_has_commit "moduleA commit 3"
}

@test "pull with wildcard filter" {
    # add a second folder matching with the wildcard
    cd $TEST_FOLDER/bzr/feature
    mkdir moduleB
    echo "moduleB text" > moduleB/bzr_file.txt
    bzr add moduleB
    bzr commit -m "feature moduleB commit 1"

    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember --filter "module*" $TEST_FOLDER/bzr feature

    check_ls_length 3
    check_file_content moduleA/bzr_file.txt "feature file"
    check_file_content moduleB/bzr_file.txt "moduleB text"
    check_git_has_commit "bzr branch 'feature' into git branch 'master' with filter: 'module\*'"

    # test second pull, after modif on bzr repo
    cd $TEST_FOLDER/bzr/feature
    echo "text modified" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"

    cd $TEST_FOLDER/git
    git bzr-merge pull

    check_ls_length 3
    check_file_content moduleA/bzr_file.txt "text modified"
    check_git_has_commit "moduleA commit 2"
}
