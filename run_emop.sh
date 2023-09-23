#!/bin/bash

PLUGIN='\<plugin\>\
\<groupId\>edu.illinois\<\/groupId\>\
\<artifactId\>starts-maven-plugin\<\/artifactId\>\
\<version\>1.4-SNAPSHOT\<\/version\>\
\<\/plugin\>\
\<plugin\>\
\<artifactId\>emop-maven-plugin\<\/artifactId\>\
\<groupId\>edu.cornell\<\/groupId\>\
\<version\>1.0-SNAPSHOT\<\/version\>\
\<\/plugin\> \
\<plugin\>\
\<groupId\>org.apache.maven.plugins\<\/groupId\>\
\<artifactId\>maven-surefire-plugin\<\/artifactId\>\
\<version\>2.20\<\/version\>\
\<configuration\>\
\<argLine\>\
-javaagent:${settings.localRepository}\/javamop-agent\/javamop-agent\/1.0\/javamop-agent-1.0.jar\<\/argLine\>\
\<\/configuration\>\
\<\/plugin\>'

mkdir results/

# for commit in $commit1 $commit2 $commit3 $commit4 $commit5
# Read the CSV file line by line
while IFS=',' read -r repo commit1 commit2 commit3 commit4 commit5
# while IFS=',' read -r repo commit1 commit2
do
    # Clone the project
    author=$(echo $repo | cut -d '/' -f 1)
    project=$(echo $repo | cut -d '/' -f 2)
    
    git clone https://github.com/$repo.git $project
    mkdir -p results/$project/
    cd $project
    
    # for granularity in "hrps" "mrps" "rps"
    for granularity in "hrps"
    do
        rm -rf ../.starts/
        mkdir ../.starts/
        # Checkout and run checkstyle for each commit
        for commit in $commit1 
        do
            git checkout $commit -f
            mvn clean
            rm -rf .starts/
            cp -r ../.starts/ ./.starts/
            sed -i "/<\/plugins>/i\\$PLUGIN" pom.xml
            mvn emop:$granularity | tee -a ../results/$project/$granularity.txt
            echo "=====" >> ../results/$project/$granularity.txt
            rm -fr ../.starts/
            cp -rf ./.starts/ ../.starts/
            rm -fr ./.starts/
        done
        
        # Go back to the parent directory for the next project
    done
    cd ..
done < $1
