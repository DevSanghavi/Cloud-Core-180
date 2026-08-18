# Day 62: EC2 User Data & Bootstrap Scripts

## What is this day?
This day marks the transition from manual infrastructure configuration to automated, programmatic server orchestration using shell scripts passed during server provisioning.

## What is this topic called?
This topic is called **EC2 User Data and Cloud-Init Bootstrapping**.

## Why did we do this?
We performed this lab to practice launching completely hands-off infrastructure. By injecting configuration parameters at runtime, we eliminate the need for manual operations teams to log into instances post-creation to configure standard applications.

## What happened by doing this?
- An EC2 server was created using an Ubuntu operating system base image.
- A background process called `cloud-init` read an encoded configuration file, raised user privileges to root, updated package states, installed an Nginx web application hosting service, and modified the web home page index file.
- The web application immediately became accessible over the public internet without any manual SSH configuration lines entered by an administrator.

## Why is it necessary to learn this topic?
- **High-Scale Operations:** If you need to deploy 50 identical servers for an application cluster, manually logging into every machine with an SSH configuration tool is impossible.
- **Auto-Scaling Compatibility:** When traffic surges, AWS Auto-Scaling groups launch new server capacity automatically. These new servers rely on User Data scripts to install your code dynamically without human intervention.
- **Infrastructure Consistency:** Standardizing configurations inside a single file eliminates configuration drift errors across corporate deployment pipelines.
