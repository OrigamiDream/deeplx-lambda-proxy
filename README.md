# DeepLX Lambda Proxy

Introducing DeepLX Proxy with multiple AWS Lambda.

## Usage

Create `vars.tfvars` file in `./infra` directory, and define:
```
lambda_size = 15
```

Create Lambda deployments and dependencies (I recommend you to use `virtualenv`).
```
sh archive-lambda-deps.sh
```
The script generates `deps.zip` and `lambda.zip`

Run Terraform
```
cd infra
terraform init
terraform plan
terraform apply
```

## Request via HTTP

In the example below, `<alb_dns_name>` can be fetched from `terraform output`, 
 and the `<index>` is the index of the deployed lambda function.

```http request
POST http://<alb_dns_name>/v{index}/commit
Content-Type: application/json

{
  "url": "https://api.deeplx.org/translate",
  "http_method": "POST",
  "timeout_secs": 5,
  "commitments": [
    {
      "unique_id": "1",
      "headers": {
        "Content-Type": "application/json"
      },
      "body": {
        "text": "Hello World!",
        "source_lang": "EN",
        "target_lang": "KO"
      }
    },
    {
      "unique_id": "2",
      "headers": {
        "Content-Type": "application/json"
      },
      "body": {
        "text": "This is James.",
        "source_lang": "EN",
        "target_lang": "KO"
      }
    }
  ]
}
```

## License

Licensed under the [MIT license](https://github.com/OrigamiDream/deeplx-lambda-proxy/blob/main/LICENSE).