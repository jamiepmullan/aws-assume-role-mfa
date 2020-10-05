# aws-assume-role-mfa
This setup will help you to automatically sign into a root/security account and then role switch to another account

# Pre-Requisites 

    aws-cli installed and configured
    aws profiles added (as detailed below)
    your MFA secret stored (in authenticator app)

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

# Running the script

```
source assume_role.sh myCompany-dev
```

## MFA Entry
The app will prompt you for your MFA code (for example from Google Authenticate)

# Alias'

Add an alias to your environment such as :
```
alias role='source /path/to/script/assume_role.sh'
role myCompany-dev
```