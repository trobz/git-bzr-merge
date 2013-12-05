load test_helper

@test "push without filter" {

    echo -e "\nFirst push\n"

    cd $TEST_FOLDER/git
    git bzr-merge push $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature

    check_ls_length 4
    check_bzr_log_length 5
    check_file_content git_master_file.txt "git master file"
    check_bzr_last_log_content "git branch 'master' into bzr branch 'feature'"

    echo -e "\nTest second push, after modif on git repo\n"

    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > git_master_file.txt
    git commit -a -m "git commit 2"

    git bzr-merge push --remember $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 7
    check_file_content git_master_file.txt "text modified"

    echo -e "\nThird test, with remember option\n"

    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified 2" > git_master_file.txt
    git commit -a -m "git commit 3"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 9
    check_file_content git_master_file.txt "text modified 2"
}


@test "push with filter" {

    cd $TEST_FOLDER/git
    mkdir moduleB
    echo "moduleB text" > moduleB/git_file.txt
    git add moduleB
    git commit -m "git moduleB commit 1"

    echo -e "\nFirst push\n"

    git bzr-merge push --filter moduleB $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature
    check_ls_length 4
    check_bzr_log_length 5
    check_file_content moduleB/git_file.txt "moduleB text"
    check_bzr_last_log_content "git branch 'master' into bzr branch 'feature' with filter: 'moduleB'"

    echo -e "\nTest second push, after modif on git repo\n"

    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > moduleB/git_file.txt
    git commit -a -m "git moduleB commit 2"

    git bzr-merge push --remember --filter moduleB $TEST_FOLDER/bzr feature

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 7
    check_file_content moduleB/git_file.txt "text modified"

    echo -e "\nThird test, with remember option\n"

    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified 2" > moduleB/git_file.txt
    git commit -a -m "git moduleB commit 3"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 9
    check_file_content moduleB/git_file.txt "text modified 2"
}


@test "push with wildcard filter" {
    cd $TEST_FOLDER/git

    mkdir {moduleB,moduleC}
    echo "moduleB text" > moduleB/git_file.txt
    echo "moduleC text" > moduleC/git_file.txt
    git add module*
    git commit -m "git module* commit 1"

    echo -e "\nFirst push\n"

    git bzr-merge push $TEST_FOLDER/bzr feature --filter "module*" --remember

    cd $TEST_FOLDER/bzr/feature

    check_ls_length 5
    check_bzr_log_length 5
    check_file_content moduleB/git_file.txt "moduleB text"
    check_file_content moduleC/git_file.txt "moduleC text"
    check_bzr_last_log_content "git branch 'master' into bzr branch 'feature' with filter: 'module*'"

    echo -e "\nTest second push, after modif on git repo\n"

    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified" > moduleB/git_file.txt
    echo "text modified" > moduleC/git_file.txt
    git commit -a -m "git module* commit 2"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 7
    check_file_content moduleB/git_file.txt "text modified"
    check_file_content moduleC/git_file.txt "text modified"
}
