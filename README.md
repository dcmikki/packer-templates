# packer-templates

## Requirements
Install packer from Hashicorp
* https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/docker-get-started


#### Check version
```
$ packer --version
1.8.2                                                                 
```

#### Validate templates
```
$ packer validate centos7.9_qemu.json
The configuration is valid.                            

$ packer validate centos7.9_qemu.json.pkr.hcl
The configuration is valid.                          

```

#### Build box
```
packer build centos7.9_qemu.json
```
