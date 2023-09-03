{
  "authentication": {
    "ldap": {
      "enabled": false,
      "hostname": "ldap.domain.com",
      "port": 389,
      "baseDn": "dc=company,dc=com",
      "searchUserDn": "cn=reposilite,ou=admins,dc=domain,dc=com",
      "searchUserPassword": "reposilite-admin-secret",
      "typeAttribute": "person",
      "userAttribute": "cn",
      "userFilter": "(&(objectClass=person)(ou=Maven Users))",
      "userType": "PERSISTENT"
    }
  },
  "statistics": {
    "enabled": true,
    "resolvedRequestsInterval": "MONTHLY"
  },
  "frontend": {
    "id": "reposilite-repository",
    "title": "Reposilite Repository",
    "description": "Public Maven repository hosted through the Reposilite",
    "organizationWebsite": "https://reposilite.com",
    "organizationLogo": "https://avatars.githubusercontent.com/u/88636591",
    "icpLicense": ""
  },
  "web": {
    "forwardedIp": "X-Forwarded-For"
  },
  "maven": {
    "repositories": [
      {
        "id": "releases",
        "visibility": "PUBLIC",
        "storageProvider": {
          "type": "fs",
          "quota": "100%",
          "mount": ""
        },
        "redeployment": false,
        "preserveSnapshots": false,
        "proxied": []
      },
      {
        "id": "snapshots",
        "visibility": "PUBLIC",
        "storageProvider": {
          "type": "fs",
          "quota": "100%",
          "mount": ""
        },
        "redeployment": false,
        "preserveSnapshots": false,
        "proxied": []
      },
      {
        "id": "private",
        "visibility": "PRIVATE",
        "storageProvider": {
          "type": "fs",
          "quota": "100%",
          "mount": ""
        },
        "redeployment": false,
        "preserveSnapshots": false,
        "proxied": []
      }
    ]
  }
}