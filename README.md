# packer-templates

## Requirements
Install packer from Hashicorp
* https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/docker-get-started

Install KVM / libvirt on Linux
* https://github.com/dcmikki/vagrant_automation/blob/main/README.md

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
packer build centos7.9_virtualbox.json
packer build centos7.9_vmware.json
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

#### Get python package info

```
$ vagrant-metadata -h
usage: vagrant-metadata [-h] [-d DESCRIPTION] [-f] [-n NAME] [-u BASEURL] [-a]

optional arguments:
  -h, --help            show this help message and exit
  -d DESCRIPTION, --description DESCRIPTION
  -f, --force
  -n NAME, --name NAME
  -u BASEURL, --baseurl BASEURL
  -a, --append

```

#### Generate `metadata.json` first time:

```
$ cd centos7

$ vagrant-metadata \
	--name="diego/centos7" \
	--baseurl="http://local.nfs.home/vagrant/boxes" \
	--description="Diego's CentOS 7 packer boxes"
```

and see  `metadata.json` generated:

```
$ cat metadata.json

{
  "name": "diego/centos7",
  "description": "Diego's CentOS 7 packer boxes",
  "baseurl": "http://local.nfs.home/vagrant/boxes",
  "versions": [
    {
      "version": "1.0.0",
      "providers": [
        {
          "name": "libvirt",
          "checksum_type": "sha1",
          "checksum": "b8f8a1308a626edb72514e232a379a041d62dd65",
          "url": "http://local.nfs.home/vagrant/boxes/centos7/1.0.0/libvirt/centos7.9.2009.box"
        },
        {
          "name": "virtualbox",
          "checksum_type": "sha1",
          "checksum": "ada5dcec9a55db52ff6ccea49b56fd73cfcdac0a",
          "url": "http://local.nfs.home/vagrant/boxes/centos7/1.0.0/virtualbox/centos7.9.2009.box"
        }
      ]
    }
  ]
}
```

#### How to use this box with Vagrant

Minimal installation in the `Vagrantfile`

```
Vagrant.configure("2") do |config|
  config.vm.box = "diego/centos7"
  config.vm.box_url = "http://local.nfs.home/vagrant/boxes/centos7/metadata.json"
end
```