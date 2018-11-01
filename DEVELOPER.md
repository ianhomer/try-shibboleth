# Release Procedure

Build pipeline builds releases and deploys to package repository for tagged 
releases. This can be triggered with :

    mvn release:prepare && mvn release:clean    

# Check for dependency and plugin updates

    mvn versions:display-dependency-updates
    mvn versions:display-plugin-updates
    