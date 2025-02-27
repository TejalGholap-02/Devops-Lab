# Use the Amazon Linux base image
FROM amazonlinux:2

# Update the system and install necessary packages
RUN yum update -y && \
    yum install -y git tar wget telent unzip python3 python3-pip && \
    amazon-linux-extras install java-openjdk11 -y && \
    yum clean all

# Set up Maven
RUN cd /opt && \
    wget https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz && \
    tar xvf apache-maven-3.9.4-bin.tar.gz && \
    rm apache-maven-3.9.4-bin.tar.gz && \
    echo "export M2_HOME=/opt/apache-maven-3.9.4" >> /root/.bashrc && \
    echo "export M2=\$M2_HOME/bin" >> /root/.bashrc && \
    echo "export PATH=\$M2:\$PATH" >> /root/.bashrc

# Install Terraform
RUN cd /opt && \
    wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip && \
    unzip terraform_1.0.7_linux_amd64.zip && \
    rm terraform_1.0.7_linux_amd64.zip && \
    mv terraform /usr/local/bin/

# Install kubectl
RUN cd /usr/local/bin && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl


# Set environment variables for the current shell session
ENV M2_HOME=/opt/apache-maven-3.9.4
ENV M2=$M2_HOME/bin
ENV PATH=$M2:/usr/local/bin:$PATH

# Use the Amazon Linux base image
FROM amazonlinux:2

# Update the system and install necessary packages
RUN yum update -y && \
    yum install -y git tar wget unzip python3 python3-pip && \
    yum clean all

# Install Java 21 (Oracle JDK)
RUN cd /opt && \
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz && \
    tar xzf jdk-21_linux-x64_bin.tar.gz && \
    rm jdk-21_linux-x64_bin.tar.gz && \
    mv jdk-21* /usr/local/java21 && \
    echo "export JAVA_HOME=/usr/local/java21" >> /etc/profile && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

# Set JAVA environment variables
ENV JAVA_HOME=/usr/local/java21
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Maven (3.9.9)
RUN cd /opt && \
    wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar xvf apache-maven-3.9.9-bin.tar.gz && \
    rm apache-maven-3.9.9-bin.tar.gz && \
    echo "export M2_HOME=/opt/apache-maven-3.9.9" >> /etc/profile && \
    echo "export M2=\$M2_HOME/bin" >> /etc/profile && \
    echo "export PATH=\$M2:\$PATH" >> /etc/profile

# Install the latest Terraform
RUN cd /opt && \
    LATEST_TERRAFORM=$(curl -s https://releases.hashicorp.com/terraform/ | grep '<a href="/terraform/' | head -n 1 | awk -F'/' '{print $3}') && \
    wget https://releases.hashicorp.com/terraform/$LATEST_TERRAFORM/terraform_${LATEST_TERRAFORM}_linux_amd64.zip && \
    unzip terraform_${LATEST_TERRAFORM}_linux_amd64.zip && \
    rm terraform_${LATEST_TERRAFORM}_linux_amd64.zip && \
    mv terraform /usr/local/bin/

# Install kubectl
RUN cd /usr/local/bin && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

# Final environment setup
ENV M2_HOME=/opt/apache-maven-3.9.9
ENV M2=$M2_HOME/bin
ENV PATH=$M2:$PATH
