#!/bin/bash
set -ev

saveGitCredentials() {
    cat >$HOME/.netrc <<EOL
machine github.com
login ${GITHUB_USERNAME}
password ${GITHUB_TOKEN}

machine api.github.com
login ${GITHUB_USERNAME}
password ${GITHUB_TOKEN}
EOL
    chmod 600 $HOME/.netrc
}

if [ "${TRAVIS_PULL_REQUEST}" = "false" ] && [ "${TRAVIS_BRANCH}" = "master" ] && [ "${RELEASE}" = "true" ]; then
    echo "Deploying release to Bintray"
    saveGitCredentials
    git checkout -f ${TRAVIS_BRANCH}
    ./gradlew clean assemble -Prelease.useAutomaticVersion=true && ./gradlew check --info
else
    echo "Verify"
    ./gradlew clean assemble && ./gradlew check --info
fi
