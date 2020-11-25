#!/bin/sh

set -e

application='platform'

SOURCE_DIR=`pwd`

case ${5} in
  amazon)
    IMAGE=$(aws --profile ${2} --region ${4} ec2 describe-images --owners 137112412989 --filters 'Name=name,Values=Amazon Linux 2 AMI*' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
  ;;
  centos)
    IMAGE=$(aws --profile ${2} --region ${4} ec2 describe-images --owners 679593333241 --filters 'Name=name,Values=CentOS Linux 7 x86_64 HVM EBS ENA*' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
  ;;
  redhat)
    IMAGE=$(aws --profile ${2} --region ${4} ec2 describe-images --owners 309956199498 --filters 'Name=name,Values=RHEL-7.7_HVM_GA*' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
  ;;
esac

AWS_PROFILE=${2} packer ${1} -var-file=${SOURCE_DIR}/${3}-${5}-${4}.json -var "image=${IMAGE}" -var "base=${5}" -var "region=${4}" -var "source_dir=${SOURCE_DIR}" -var "application=${application}" ${SOURCE_DIR}/packer.json
