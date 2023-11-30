# SalesEnablement-Satellite-L3-Sales
IBM Cloud Satellite L3 for Sales

This repo contains the content for the IBM Technology Sales Enablement's IBM Cloud Satellite Level 3 learning plan.  The learning plan is available to both IBM and business partner sellers and technical sellers. 


**ITZ Collection:** https://techzone.ibm.com/collection/ibm-cloud-satellite-level-3

**ITZ Environment:** https://techzone.ibm.com/my/reservations/create/647f301a17fe470017596255

**ITZ gitops pattern:** https://github.ibm.com/dte2-0/ccp-gitops-patterns/tree/main/ibm-satellite-se-l3-v2

**ITZ account:** ITZ-Satellite

## Summary of environment and automation

The lab consists of many click-thru demonstrations, two pre-provisioned Satellite location, and several pre-provisoned ROKS clusters.

In the ITZ automation:

- Users are added to the above ITZ account.
- Users are added to the *satellite-users* IAM access group - **Note:** unlike some of the other L3s we have, the *satellite-users* group is used by other ITZ environments so it will very likely contain other users beyond those with an active reservation for this specific environment.
- A user specific access group is created and the user is assigned to it. Specific IAM roles and policies are added to the group so they can access a namespace in the ROKS clusters that are also created for the user.
- Two Satellite Configurations are also created for the user.

## Maintenance

**To perform the maintenance steps below, you must have admin access in the ITZ IBM Cloud account: ITZ-Satellite.**

1. Verify the following resources are available:

**Satellite Locations:** yl-l3-vmware, yl-l3-empty-location
**Cluster Groups:** yl-vmware-roks-1, yl-l3-ibm-roks-2
**OpenShift Clusters:** yl-l3-vmware-roks-1, yl-l3-ibm-roks-2

2. The yl-l3-empty-location location should have a state of "Action required".  This is expected and is just used as an example in the demonstration guide.

3. The yl-l3-vmware location and the OpenShift clusters should all be in a *Normal* and/or *healthy* state. If they are not, you need to figure out why and resolve.

4. The 2 **Satellite Configurations** created automatically for the users of this L3 environment have the suffix *-se-l3*. For example:

- 2700039nft-gitconfig-se-l3
- 2700039nft-se-l3

View all the active configurations using the IBM Cloud portal (https://cloud.ibm.com/satellite/configuration). Enter "se-l3" in the search field for the table of configurations. If there are configs that are more than a few weeks old (longer than an ITZ reservation for this environment can exist), they can probably be removed. You will first need to remove any active subscriptions and then the configuration can be removed. The first part of the config name (e.g. from above *2700039nft*) is the users IBM ID that is associated with their cloud account. You may want to look at the existing users in the account and remove those accounts. The following script will list all the users in the account along with their IBM ID so they can easily be managed. I did not add the delete capability to this script since this environment doesn't tend to leave user IDs around.

```
wget -O listAllUsers.perl https://raw.githubusercontent.com/IBM/SalesEnablement-Satellite-L3-Sales/main/tools/listAllUsers.perl

perl listAllUsers.perl
```

