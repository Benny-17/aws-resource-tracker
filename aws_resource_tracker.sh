#!/bin/bash

LOG_FILE="aws_resource_log.txt"
> $LOG_FILE

list_ec2_instances() {
    echo "Fetching EC2 instances..." >> $LOG_FILE
    for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
        echo "Region: $region" >> $LOG_FILE
        aws ec2 describe-instances --region "$region" --query "Reservations[].Instances[].[InstanceId,State.Name]" --output table >> $LOG_FILE
        echo "-----------------------------" >> $LOG_FILE
    done
}

list_s3_buckets() {
    echo "Fetching S3 buckets..." >> $LOG_FILE
    aws s3api list-buckets --query "Buckets[].Name" --output table >> $LOG_FILE
    echo "-----------------------------" >> $LOG_FILE
}

list_lambda_functions() {
    echo "Fetching Lambda functions..." >> $LOG_FILE
    for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
        echo "Region: $region" >> $LOG_FILE
        aws lambda list-functions --region "$region" --query "Functions[].FunctionName" --output table >> $LOG_FILE
        echo "-----------------------------" >> $LOG_FILE
    done
}

list_rds_instances() {
    echo "Fetching RDS instances..." >> $LOG_FILE
    for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
        echo "Region: $region" >> $LOG_FILE
        aws rds describe-db-instances --region "$region" --query "DBInstances[].DBInstanceIdentifier" --output table >> $LOG_FILE
        echo "-----------------------------" >> $LOG_FILE
    done
}

main() {
    echo "AWS Resource Tracker" > $LOG_FILE
    echo "Generated on: $(date)" >> $LOG_FILE
    echo "=============================" >> $LOG_FILE

    list_ec2_instances
    list_s3_buckets
    list_lambda_functions
    list_rds_instances

    echo "Resource tracking complete. Log saved to $LOG_FILE"
}

main

