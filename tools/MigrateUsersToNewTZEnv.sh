#!/bin/bash


export aws_cluster=cajmcb3w0omsgg4vtq60
export ibm_cluster=ca1ttn8w0tjjga091nl0



# find all access groups for our lab
# ^satellite-.*-ag$

# get all the namespaces created for our TZ environment
allConfigs=`ibmcloud sat config ls | grep "\-ns" | grep -v "\-nh\-ns"|cut -f1 -d '-'` 


ibmcloud iam ags| grep satellite.*ag|grep -v banking | while read accessGroupName junk
do
	namespace=""
	# echo accessGroupName = $accessGroupName
	namespace=`echo $accessGroupName | cut -d'-' -f 2`
	
	# need to see if the namespace is in the list of allConfigs
	export processMe=1
	for conf in $allConfigs
	do
		# echo "looking for $conf in $accessGroupName"
		echo $accessGroupName|grep $conf && {
			# echo we need to do this one
			processMe=0
			break
			}
	done
	
	
	if [ $processMe -eq 0 ]
	then


		namespace=${namespace}-ns
		echo "processing $accessGroupName"

		# new razee policies:
		echo	ibmcloud iam access-group-policy-create $accessGroupName --roles Writer,Operator --service-name containers-kubernetes --attributes serviceInstance=$aws_cluster,namespace=razeedeploy
 
 
		echo	ibmcloud iam access-group-policy-create $accessGroupName --roles Writer,Operator --service-name containers-kubernetes --attributes serviceInstance=$ibm_cluster,namespace=razeedeploy

		# new namespace policies:

		echo	ibmcloud iam access-group-policy-create $accessGroupName --roles Administrator,Manager --service-name containers-kubernetes --attributes serviceInstance=$aws_cluster,namespace=$namespace
 
 
		echo	ibmcloud iam access-group-policy-create $accessGroupName --roles Administrator,Manager --service-name containers-kubernetes --attributes serviceInstance=$ibm_cluster,namespace=$namespace
		
		# Update the subscription
		
	 	echo adding new cluster groups to subscription
		echo ibmcloud sat subscription update --subscription ${namespace}-sub -g food-delivery-development-clusters -g food-delivery-production-clusters -g yl-food-delivery-production -g yl-food-delivery-development -f
		
     else
	     echo
	     echo "skipping $accessGroupName"
	     echo
	 fi

done



# new razee policies:

# ibmcloud iam access-group-policy-create satellite-2700039nft-9rm46a6y-ag --roles Writer,Operator --service-name containers-kubernetes --attributes serviceInstance=$aws_cluster,namespace=razeedeploy
 
 
# ibmcloud iam access-group-policy-create satellite-2700039nft-9rm46a6y-ag --roles Writer,Operator --service-name containers-kubernetes --attributes serviceInstance=$ibm_cluster,namespace=razeedeploy
 
# andy accessgroup
# satellite-2700039nft-9rm46a6y-ag

# Roles: Writer, Operator
# Resources: 
#   Service Name: containers-kubernetes
#   Service Instance: $aws_cluster
#   namespace: razeedeploy
   
# Roles: Writer, Operator
# Resources: 
#   Service Name: containers-kubernetes
#   Service Instance: $ibm_cluster
#   namespace: razeedeploy   