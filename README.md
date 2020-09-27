# aws-assume-role-mfa
This setup will help you to automatically sign into a root/security account and then role switch to another account

You can also switch between 

# Pre-Requisites 

    aws-cli installed and configured
    aws profiles added (as detailed below)
    oath-toolkit (brew install oath-toolkit)
    your MFA secret stored (as detailed below)

# AWS Profiles

Make sure you have your AWS profiles setup in ~/.aws/credentials as below:

```
[myCompany]
aws_access_key_id = XXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
region=eu-west-2
output=json

[myCompany-dev]
role_arn = arn:aws:iam::111111111111:role/myCompany-dev-admin
source_profile = myCompany

[myCompany-staging]
role_arn = arn:aws:iam::222222222222:role/myCompany-staging-admin
source_profile = myCompany

[myCompany-prod]
role_arn = arn:aws:iam::333333333333:role/myCompany-prod-admin
source_profile = myCompany
```

# MFA secret

To store your MFA secret using oath-toolkit:

Add a Virtual MFA token to your AWS account:
- (https://console.aws.amazon.com/iam/home#security_credential)
- Assign MFA device
- Virtual MFA device
- Show secret key (copy it) 
- Add secret key to keychain
```
security add-generic-password -a "myCompany" -s "myCompany" -w "mysecretMFAkey"
```
- Fetch an MFA and fill in :MFA code 1"
```
oathtool --base32 --totp $(security find-generic-password -ga "ovyo" 2>&1 >/dev/null | cut -d'"' -f2) 
```
- Wait until the next minute and then Fetch an MFA and fill in :MFA code 2"
```
oathtool --base32 --totp $(security find-generic-password -ga "ovyo" 2>&1 >/dev/null | cut -d'"' -f2) 
```

# Running the script

```
source assume_role.sh myCompany-dev
```

# Alias'

Add an alias to your environment such as :
```
alias role='source /path/to/script/assume_role.sh'
role myCompany-dev
```