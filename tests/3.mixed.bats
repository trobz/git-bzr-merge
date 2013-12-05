load test_helper


@test "pull/push" {

    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember $TEST_FOLDER/bzr feature

    check_ls_length 4
    check_file_content moduleA/bzr_file.txt "feature file"
    check_git_has_commit "bzr branch 'feature' into git branch 'master'"

    # then push some changes
    git checkout master
    echo "text modified by git" > git_master_file.txt
    git commit -a -m "git commit 2"

    git bzr-merge push

    cd $TEST_FOLDER/bzr/feature
    check_bzr_log_length 6
    check_file_content git_master_file.txt "text modified by git"

    # previous pull has generated a path conflict, just resolve it... seems due to git-remote-bzr
    bzr resolve --action=done

    # then do changes on both side
    cd $TEST_FOLDER/bzr/feature
    echo "text modified by bzr" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 1"
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified by git 2" > git_master_file.txt
    git commit -a -m "git commit 3"

    git checkout master
    git bzr-merge pull
    git bzr-merge push

    cd $TEST_FOLDER/git
    check_file_content git_master_file.txt "text modified by git 2"
    check_file_content moduleA/bzr_file.txt "text modified by bzr"
    check_git_has_commit "feature moduleA commit 1"
    cd $TEST_FOLDER/bzr/feature
    check_file_content git_master_file.txt "text modified by git 2"
    check_file_content moduleA/bzr_file.txt "text modified by bzr"
    check_bzr_log_length 9
    check_bzr_last_log_content "bzr branch 'feature' into git branch 'master'"

    # check file conflict
    cd $TEST_FOLDER/bzr/feature
    echo "text modified by bzr" > git_master_file.txt
    bzr commit -m "bzr modify git file, should have a conflict"
    cd $TEST_FOLDER/git
    git checkout master
    echo "text modified by git too" > git_master_file.txt
    git commit -a -m "git commit 4"

    git checkout master
    check_failed "git bzr-merge push"
}

@test "bzr repositories" {

    setup_bzr_bis

    # test pull
    cd $TEST_FOLDER/git
    git bzr-merge pull --remember $TEST_FOLDER/bzr feature

    check_ls_length 4
    check_file_content moduleA/bzr_file.txt "feature file"
    check_git_has_commit "bzr branch 'feature' into git branch 'master'"

    git bzr-merge pull --remember $TEST_FOLDER/bzr-bis trunk --remote-name bis

    check_ls_length 5
    check_file_content bzr_bis_trunk_file.txt "bzr bis trunk file"
    check_git_has_commit "bzr bis trunk commit 1"

    # then do changes on both side
    cd $TEST_FOLDER/bzr/feature
    echo "text modified by bzr" > moduleA/bzr_file.txt
    bzr commit -m "feature moduleA commit 2"
    cd $TEST_FOLDER/git

    git bzr-merge pull

    check_file_content moduleA/bzr_file.txt "text modified by bzr"
    check_git_has_commit "feature moduleA commit 2"

    # then do changes on both side
    cd $TEST_FOLDER/bzr-bis/trunk
    echo "bzr bis changes" > bzr_bis_trunk_file.txt
    bzr commit -m "bzr bis trunk commit 2"
    cd $TEST_FOLDER/git

    git bzr-merge pull --remote-name bis

    check_file_content bzr_bis_trunk_file.txt "bzr bis changes"
    check_git_has_commit "bzr bis trunk commit 2"
}