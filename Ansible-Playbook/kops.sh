#!/bin/bash


aws s3 ls &> /dev/null
if [[ $? -eq 255 ]];then
 echo "aws creds is not set"
 exit 1
fi

function bucket_config_input(){
    read -p "Bucket name: " bucket_name
    read -p "Region : " region 
}


bucket_config_input



function cluster_config_input(){
    read -p "Cluster name : " cluster_name
    read -p "Availability Zone : " zone
    read -p "Master size : " master_size
    read -p "Node size" node_size
    read -p "Count: " node_count
}

function create_bucket(){
    # creating bucket 
    aws s3api create-bucket \
    --bucket ${1} \
    --region ${2} \
    --create-bucket-configuration \
    LocationConstraint=${2}
    # enable versioning bucket
    aws s3api put-bucket-versioning \
    --bucket ${1} \
    --region ${2} \
    --versioning-configuration Status=Enabled
}

function create_cluster(){
    # create cluster

    kops create cluster \
    --name ${1} \
    --zones ${2} \
    --master-size ${3} \
    --node-size ${4} \
    --node-count ${5}
    # deploy cluster 
    kops update cluster \
    --name ${1} --yes --admin
    
    kops validate cluster --wait 10m 
}

read -p "Do you want to create a bucket?: y/n " ask_to_create_bucket
if [[ $ask_to_create_bucket == "y" ]];
then
    echo "Default region Singapore"
    create_bucket $bucket_name $region "ap-southeast-1"
fi


export KOPS_STATE_STORE=s3://${bucket_name} 
read -p "Do you want to create a cluster?: y/n " ask_to_create_cluster
if [[ $ask_to_create_cluster == "y" ]];
    then
    cluster_config_input

    create_cluster $cluster_name \
    $zones "ap-southeast-1a","ap-southeast-1b","ap-southeast-1c" \
    $master_size "t3.medium" \
    $node_size "t3.medium" \
    $node_count 1
fi

