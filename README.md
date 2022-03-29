# Generate Developer Certificate for ASP.Net Core on Linux

## Problem
To develop ASP.Net Core Web Apps on Linux you need to generate self-signed
developer certificates. This works fine under Windows and Mac OSX with 'dotnet
dev-certs https --trust', but not under Linux operating systems. You will get
SSL Connection errors if two Wep Apps need to communicate with each other or you
want to access it via browser.

## Solution
You need to generate self-signed certificates with OpenSSL to successfully use
them. To be fully compatible with Firefox and Chrome, you need to setup a local
trust chain. To simplify the process of generating these certificates for
developers this script was created.

Tested with:
* Ubuntu 20.04 and .NET 5.0
* Centos 7.9 and .NET 5.0
* Arch Linux (5.12.14-arch1-1) and .NET 5.0

## What will it do?
1. Create a self-signed Root CA certificate.
2. Add the Developer Root CA certificate to the trust store.
3. Add the certificate to the browser's trust store (certutil).
4. Create a self-signed server certificate to use in dotnet development.
5. Add the generated certificate to aspnet environment 'dotnet dev-certs https
   --trust' to use it **without** any custom configuration of Kestrel in e.g.
   appsettings.json

<h1>Debian Distros (Debian, Ubuntu, etc)</h1>

Clone or download this git repository and make the script corresponding to your system executable.

```shell
chmod +x ./setup_dev_certs_debian.sh
```
Execute the script
```shell
./setup_dev_certs_debian.sh
```

You will also be asked to enter your sudo password, as adding the certificate to the trust store requires
elevated privileges.

## Debian Dependencies
- libnss3-tools (script will ask you to install if not found on your system)
- dotnet SDK (you should already have this)


<h1>RHEL Distros (Centos, Fedora, Oracle Linux, etc..)</h1>

Clone or download this git repository and make the script corresponding to your system executable.

```shell
chmod +x ./setup_dev_certs_rhel.sh
```
Execute the script
```shell
./setup_dev_certs_rhel.sh
```

You will also be asked to enter your sudo password, as adding the certificate to the trust store requires
elevated privileges.

## RHEL Dependencies
- nss-tools (script will ask you to install if not found on your system)
- dotnet SDK (you should already have this)


<h1>ARCH Distros (Manjaro, ArcoLinux, EndeavourOS, etc..)</h1>

Clone or download this git repository and make the script corresponding to your system executable.

```shell
chmod +x ./setup_dev_certs_arch.sh
```
Execute the script
```shell
./setup_dev_certs_arch.sh
```

You will also be asked to enter your sudo password, as adding the certificate to the trust store requires
elevated privileges.

## ARCH Dependencies
- nss (script will ask you to install if not found on your system)
- dotnet SDK (you should already have this)

# References
[Github: daretoIT/generate-dotnet-dev-certificate](https://github.com/daretoIT/generate-dotnet-dev-certificate)