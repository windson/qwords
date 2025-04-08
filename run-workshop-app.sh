#!/usr/bin/env bash

# Default Java version is 8 if no argument is provided
JAVA_VERSION=${1:-8}
WORKSHOP_MODE=true

# Function to check if Maven is installed
check_maven() {
    if ! command -v mvn 2>&1 > /dev/null; then
        echo "Maven is not installed or not in PATH"
        exit 1
    fi
}

echo "Looking for JAVA VERSION $JAVA_VERSION"

# Function to check Java version and set JAVA_HOME
set_java() {
    # Linux/Ubuntu
    if [ "$JAVA_VERSION" = "8" ]; then
        if [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ]; then
            export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
        elif [ -d "/usr/lib/jvm/java-1.8.0-openjdk-amd64" ]; then
            export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
        elif [ -d "/usr/lib/jvm/java-1.8.0-amazon-corretto" ]; then
            export JAVA_HOME="/usr/lib/jvm/java-1.8.0-amazon-corretto"
        else
            echo "Java 8 not found"
            exit 1
        fi
    elif [ "$JAVA_VERSION" = "17" ]; then
        if [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
            export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
        elif [ -d "/usr/lib/jvm/java-17-amazon-corretto" ]; then
            export JAVA_HOME="/usr/lib/jvm/java-17-amazon-corretto"
        else
            echo "Java 17 not found"
            exit 1
        fi
    else
        echo "Unsupported Java version. Please use 8 or 17"
        exit 1
    fi
    
    # Verify Java version
    if [ "$JAVA_VERSION" = "8" ]; then
        EXPECTED_VERSION="1.8"
    else
        EXPECTED_VERSION="17"
    fi
    
    # Check Maven's Java version
    MVN_JAVA_VERSION=$(mvn -v | grep "Java version" | awk '{print $3}' | cut -d'.' -f1,2)
    
    if [ "$JAVA_VERSION" = "8" ]; then
        if [ "$MVN_JAVA_VERSION" != "1.8" ]; then
            echo "Maven is using Java $MVN_JAVA_VERSION, but Java 8 (1.8) is required"
            exit 1
        fi
    elif [ "$JAVA_VERSION" = "17" ]; then
        if [ "$MVN_JAVA_VERSION" != "17.0" ]; then
            echo "Maven is using Java $MVN_JAVA_VERSION, but Java 17 is required"
            exit 1
        fi
    fi
    
    echo "Maven is using correct Java version: $MVN_JAVA_VERSION"
}

# Check if Maven is installed
check_maven

# Set Java version
set_java

echo "Using Java version $JAVA_VERSION"
echo "JAVA_HOME set to: $JAVA_HOME"

# Run the Maven command
mvn clean verify
mvn spring-boot:run
