# 🚀 Jenkins Distributed Build Setup Guide

This guide explains how to set up a *Jenkins Master* with two *Agent Nodes*, one for compilation and one for testing, using a simple Maven-based project.

---

## 🪶 Step 1: Verify Jenkins is Running

Open your browser and go to:

👉 [http://localhost:8080](http://localhost:8080)

NOTE: Use Jenkins.msi to install Jenkins instead using it from Docker.

https://www.jenkins.io/download/

You should see the *Jenkins Dashboard*.

---

## 🪶 Step 2: Create Agent Folders

In *Command Prompt*, run:

```
mkdir C:\jenkins-agent1
mkdir C:\jenkins-agent2
```

These folders will act as the work directories for your Jenkins agents.

---

## 🪶 Step 3: Connect the First Agent (Compile Node)

1. Go to *Manage Jenkins → Nodes → New Node*
2. Enter the name *compile-node*
3. Select *Permanent Agent* → click *OK*
4. Fill the fields as follows:

   
   Remote root directory: C:\jenkins-agent1
   
   Labels: compile-node
   
   Usage: Use this node as much as possible
   

5. Click *Save*

Now Jenkins shows a launch command under  
*“Launch agent via Java Web Start”*.  
It looks like this:

```
curl.exe -sO http://localhost:8080/jnlpJars/agent.jar & java -jar agent.jar -url http://localhost:8080/ -secret <SECRET> -name "compile-node" -webSocket -workDir "C:\jenkins-agent1"
```

Run it in *Command Prompt*:

```
cd C:\jenkins-agent1
<PASTE THE COMMAND HERE>
```

✅ If successful, you’ll see:


INFO: WebSocket connection open
INFO: Connected


Now your first agent is connected!

---

## 🪶 Step 4: Add the Second Agent (Test Node)

Repeat the same process:

1. Go to *Manage Jenkins → Nodes → New Node*
2. Name it *test-node*
3. Fill:

   Remote root directory: C:\jenkins-agent2
   
   Labels: test-node
   
4. Click *Save*

Copy the new *launch command* Jenkins gives and run it in CMD:

```
cd C:\jenkins-agent2
<PASTE THE COMMAND HERE>
```

✅ You’ll see:


INFO: WebSocket connection open
INFO: Connected


Now both agents are active and ready.

---

## 🪶 Step 5: Create the Jenkinsfile

Inside `C:\jenkins-agent1` make a new file `Jenkinsfile`


Paste this content inside the file:

```
pipeline {
    agent none

    stages {
        stage('Compile') {
            agent { label 'compile-node' }
            steps {
                echo '🔧 Compiling project on compile-node...'
                git branch: 'Exp4', url: 'https://github.com/Abhishek-2502/DevOps_Lab.git'
                bat 'cd demo && mvn clean compile'
            }
        }

        stage('Test') {
            agent { label 'test-node' }
            steps {
                echo '🧪 Running tests on test-node...'
                git branch: 'Exp4', url: 'https://github.com/Abhishek-2502/DevOps_Lab.git'
                bat 'cd demo1 && mvn test'
            }
        }
    }

    post {
        success {
            echo '✅ Build and test stages completed successfully!'
        }
        failure {
            echo '❌ Build or test failed. Please check logs.'
        }
    }
}
```

---

## 🪶 Step 6: Create a Pipeline Job in Jenkins

1. Go to the *Jenkins Dashboard*
2. Click *New Item*
3. Enter job name: *Distributed-Build*
4. Choose *Pipeline* → click *OK*
5. Scroll down to the *Pipeline* section
6. Select *Pipeline script*
7. Paste the same *Jenkinsfile* content
8. Click *Save*

---

## 🪶 Step 7: Run the Pipeline

Click *Build Now ▶️*

You’ll see in the console logs:


🔧 Compiling project on compile-node...
🧪 Running tests on test-node...
✅ Build and test stages completed successfully!


That means:

- *Compile stage* ran on → C:\jenkins-agent1
- *Test stage* ran on → C:\jenkins-agent2

---

## 🎯 Result

You’ve successfully set up a *Distributed Jenkins Pipeline* with:

- 🖥️ Master (Jenkins)
- 🧩 Agent 1 → compile-node
- 🧪 Agent 2 → test-node

Each stage runs on its assigned node — enabling parallel, scalable, and efficient CI/CD workflows!
