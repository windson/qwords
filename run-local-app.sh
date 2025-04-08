#!/bin/bash

# Default Java version if no argument is provided
JAVA_VERSION=${1:-8}

# Function to check if Maven is installed
check_maven() {
    if ! command -v mvn 2>&1 > /dev/null; then
        echo "Maven is not installed or not in PATH"
        exit 1
    fi
}

# Function to check Java version and set JAVA_HOME
set_java() {
    case "$(uname)" in
        "Darwin")
            # macOS
            if [ "$JAVA_VERSION" = "8" ]; then
                export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
            elif [ "$JAVA_VERSION" = "17" ]; then
                export JAVA_HOME=$(/usr/libexec/java_home -v 17)
            else
                echo "Unsupported Java version. Please use 8 or 17"
                exit 1
            fi
            ;;
        "Linux")
            # Linux/Ubuntu
            if [ "$JAVA_VERSION" = "8" ]; then
                if [ -d "/usr/lib/jvm/java-8-openjdk-amd64" ]; then
                    export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
                elif [ -d "/usr/lib/jvm/java-1.8.0-openjdk-amd64" ]; then
                    export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"
                else
                    echo "Java 8 not found"
                    exit 1
                fi
            elif [ "$JAVA_VERSION" = "17" ]; then
                if [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
                    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
                else
                    echo "Java 17 not found"
                    exit 1
                fi
            else
                echo "Unsupported Java version. Please use 8 or 17"
                exit 1
            fi
            ;;
        "MINGW"*|"MSYS"*|"CYGWIN"*)
            # Windows
            if [ "$JAVA_VERSION" = "8" ]; then
                export JAVA_HOME="$(dirname "$(dirname "$(realpath "$(which javac || which java)")")")"
            elif [ "$JAVA_VERSION" = "17" ]; then
                export JAVA_HOME="$(dirname "$(dirname "$(realpath "$(which javac || which java)")")")"
            else
                echo "Unsupported Java version. Please use 8 or 17"
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system"
            exit 1
            ;;
    esac

    # Verify Java version
    if ! java -version 2>&1 | grep -q "version \"$([[ $JAVA_VERSION == "8" ]] && echo "1.8" || echo "17")"; then
        echo "Failed to set Java $JAVA_VERSION"
        exit 1
    fi
}

# Check if Maven is installed
check_maven

# Set Java version
set_java

echo "Using Java version $JAVA_VERSION"
echo "JAVA_HOME set to: $JAVA_HOME"

# Run the Maven command
mvn spring-boot:run -Dspring-boot.run.profiles=local
