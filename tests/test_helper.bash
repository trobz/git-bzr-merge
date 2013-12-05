TEST_FOLDER="/tmp/git-bzr-merge-tests/"

test_dependencies() {
    # check if dependencies are installed
    cmd=`whereis bzr | awk '{ print $2}'`
    if [ "$cmd" == "" ]
    then
        echo 'error: bzr command is not installed' >/dev/stderr
        exit 1
    fi

    bzr_version=`bzr --version`
    bzr_version=`echo $bzr_version | awk '{print $3}'`
    IFS='.' read -ra bzr_numbers <<< "$bzr_version"
    if [[ ${bzr_numbers[0]} -lt 2 || ${bzr_numbers[1]} -lt 6 ]]
    then
        echo "error: bzr is too old, need >= 2.6.0, current: $bzr_version" >/dev/stderr
        exit 1
    fi

    cmd=`whereis git | awk '{ print $2}'`
    if [ "$cmd" == "" ]
    then
        echo 'error: git command is not installed' >/dev/stderr
        exit 1
    fi

    cmd=`whereis git-bzr-merge | awk '{ print $2}'`
    if [ "$cmd" == "" ]
    then
        echo 'error: git-bzr-merge command is not installed' >/dev/stderr
        exit 1
    fi

    cmd=`whereis git-remote-bzr | awk '{ print $2}'`
    if [ "$cmd" == "" ]
    then
        echo 'error: git-remote-bzr command is not installed' >/dev/stderr
        exit 1
    fi
}


setup() {
    test_dependencies

    # ensure test folder is clean
    rm -rf $TEST_FOLDER

    # setup bzr and git repositories in $TEST_FOLDER folder
    mkdir -p $TEST_FOLDER
    cd $TEST_FOLDER

    # setup bzr test repos
    bzr init-repo bzr
    cd bzr
    bzr init trunk

    cd trunk
    echo "bzr trunk file" > bzr_trunk_file.txt
    bzr add bzr_trunk_file.txt
    bzr commit -m "bzr trunk commit 1"
    cd ..

    bzr branch trunk feature
    cd feature
    echo "bzr feature file" > bzr_feature_file.txt
    bzr add bzr_feature_file.txt
    bzr commit -m "bzr feature commit 1"
    mkdir moduleA
    echo "feature file" > moduleA/bzr_file.txt
    bzr add moduleA
    bzr commit -m "feature moduleA commit 1"

    cd $TEST_FOLDER


    # setup git test repos
    mkdir git
    cd git
    git init
    echo "git master file" > git_master_file.txt
    git add git_master_file.txt
    git commit -m "git master commit 1"

    cd $TEST_FOLDER
}


setup_bzr_bis() {
    cd $TEST_FOLDER

    # setup bzr test repos
    bzr init-repo bzr-bis
    cd bzr-bis
    bzr init trunk

    cd trunk
    echo "bzr bis trunk file" > bzr_bis_trunk_file.txt
    bzr add bzr_bis_trunk_file.txt
    bzr commit -m "bzr bis trunk commit 1"

    cd $TEST_FOLDER
}

teardown() {
    # remove all test data
    rm -rf $TEST_FOLDER
}


check_ls_length() {
    length=`ls | wc | awk '{ print $1 }'`
    if [[ $length -ne $1 ]]
    then
        echo -e "wrong file count\n\tget: $length\n\texpected: $1"
        exit 1
    fi
}

check_file_content() {
    content=`cat $1`
    if [[ $content != "$2" ]]
    then
        echo -e "wrong file content\n\tget: $content\n\texpected: $1"
        exit 1
    fi
}

check_git_has_commit() {
    if [ "`git log --all --grep="$1"`" == "" ]
    then
        echo -e "cannot found git log message: $1"
        exit 1
    fi
}

check_bzr_log_length() {
    length=`bzr log --include-merged --line | wc | awk '{ print $1 }'`
    if [[ $length -ne $1 ]]
    then
        echo -e "wrong bzr log count\n\tget: $length\n\texpected: $1"
        exit 1
    fi
}

check_bzr_last_log_content() {
    log=`bzr log -r-1 --line`
    if [[ "$log" != *"$1"* ]]
    then
        echo -e "last bzr log doesn't match\n\tget: $log\n\texpected: $1"
        exit 1
    fi
}

check_failed() {

    eval $1 | true
    code=${PIPESTATUS[0]}

    if [[ $code -eq 0 ]]
    then
        echo -e "command '$1' should have failed"
        exit 1
    fi

}