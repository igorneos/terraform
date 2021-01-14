# Elastic Cloud
Branch to deploy elastic cloud cluster as a code with terraform, let´s go!

### Installing provider via official git
```bash
mkdir -p ~/development; cd ~/development
git clone https://github.com/elastic/terraform-provider-ec
cd terraform-provider-ec
make install
```
### Generating an Elasticsearch Service API Key

To generate an API key, follow these steps:

1.  Navigate to  [https://cloud.elastic.co/login](https://cloud.elastic.co/login)  with your browser
2.  Log in with your Email and Password.
3.  Click on  [Elasticsearch Service](https://cloud.elastic.co/deployments).
4.  Navigate to  [Account > API Keys](https://cloud.elastic.co/account/keys)  and click on  **Generate API Key**.
5.  Once you Re-Authenticate, you'll have to chose a name for your API key.
6.  Copy your API key somewhere safe.

### Go to examples folder and choose the one you want for example: examples/[deployment_with_init](https://github.com/igorneos/terraform/tree/main/elastic_cloud/examples/deployment_with_init)
```
cd examples/deployment_with_init
```

### Modify provider and deployment name
Change $API_KEY value to API_KEY generated at setp 6 at "Generating an Elasticsearch Service API Key":
```bash
$ cat provider.tf

terraform {
  required_version = ">= 0.12"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.1.0-beta"
    }
  }
}

provider "ec" {
  apikey = "$API_KEY"
}

```
Set a deployment name:
```bash
cat deployment.tf

# Create an Elastic Cloud deployment
resource "ec_deployment" "example_minimal" {
  # Optional name.
  name = "my_example_deployment"

  # Mandatory fields
  region                 = "us-east-1"
  version                = "7.10.1"
  deployment_template_id = "aws-io-optimized-v2"
  traffic_filter         = [ec_deployment_traffic_filter.allow_all.id]
  elasticsearch {
    topology {
      size = "2g"
    }
  }

  kibana {
    topology {
      size = "1g"
    }
  }
}

resource "ec_deployment_traffic_filter" "allow_all" {
  name   = "Allow all ip addresses"
  region = "us-east-1"
  type   = "ip"

  rule {
    source = "0.0.0.0/0"
  }
}

output "elasticsearch_https_endpoint" {
  value = ec_deployment.example_minimal.elasticsearch[0].https_endpoint
}

output "elasticsearch_username" {
  value = ec_deployment.example_minimal.elasticsearch_username
}

output "elasticsearch_password" {
  value = ec_deployment.example_minimal.elasticsearch_password
}

output "elasticsearch_cloud_id" {
  value = ec_deployment.example_minimal.elasticsearch[0].cloud_id
}

```
### Initialize terraform and apply!
```bash
terraform init
terraform apply
```

### Result
![imagen_resultado](https://github.com/igorneos/terraform/blob/main/elastic_cloud/deploy.png)