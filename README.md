# Ubuntu_LDAP 

LDAP, the Lightweight Directory Access Protocol, is a mature, flexible, and well supported standards-based mechanism for interacting with directory servers. It’s often used for **authentication** and **storing information about users, groups, and applications**, but an LDAP directory server is a fairly general-purpose data store and can be used in a wide variety of applications (https://ldap.com/).

Ubuntu_LDAP (Docker) is minial version for linux with LDAP (Lightweight Directory Access Protocol) authentication. Here, we use LDAP as centralized authentication system. JumpCloud(jumpcloud.com) is considered as LDAP server. 

**Step 1. Prepare accounts**

Prepare accounts (users list) from JumpCloud (jumpcloud.com). First, register as administrator, then add members.  

**Step 2. Prepare env-file for the LDAP docker**

Copy env-file.example to env-file, and then edit it properly by using the information from JumpCloud. In the env-file, ADMIN_USER_ID means the administrator's id or the user id enabled as Admin/Sudo on all system associations. ORGANIZATION_CODE is given by the JumpCloud. 

**Step 3. Run Docker**

```
./Ubuntu_LDAP.sh update 

or 

nohub ./Ubuntu_LDAP.sh update 
```

With Ubuntu_LDAP, Linux system administrators can maintain user account more efficiently with centralized way. So, this docker can be installed in all Linux system. 

Best, 

J. 
