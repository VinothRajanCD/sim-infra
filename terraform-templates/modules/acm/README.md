### Overview

Modules that create HTTPS SSL certificates for application. Wildcard certificates are used for both frontend and backend domains.

### Directories

| Filename          | Description                                                                                           |
|-------------------|-------------------------------------------------------------------------------------------------------|
| `main.tf`         | Terraform modules Generate and validate an HTTPS certificate.                                         |
| `outputs.tf`      | Holds the output variables which can be used by other modules throughout the infrastructure.          |
| `variables.tf`    | Holds the variables which will be passed to main.tf.                                                  |
|---------------------------------------------------------------------------------------------------------------------------|
