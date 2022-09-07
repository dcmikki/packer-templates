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

#### Format template with extension pkr.hcl

```
packer fmt centos7.9_qemu.json.pkr.hc
```


#### Build box
```
packer build centos7.9_qemu.json
```


## Vagrant Boxes Metadata

Create and updat3 Vagrant boxes metadata files `metadata.json` using a python package
* [Vagrant-metadata](https://pypi.org/project/vagrant-metadata/)

The documentation explains how to use and update vagrant boxes metadata in private servers

### Example
My local server for centos7 images

```
$ tree
.
└── centos7
    ├── 1.0.0
    │	├── libvirt
    │	│	└── centos7.9.2009.box
    │	└── virtualbox
    │		└── centos7.9.2009.box
    └── metadata.json

```