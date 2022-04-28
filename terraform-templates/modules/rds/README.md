### Overview

Modules that create Database for the PMS application. 

`NOTE: DO NOT STORE THE DB CREDENTIALS IN TERRAFORM SCRIPTS.`

### Directories

| Filename          | Description                                                                                           |
|-------------------|-------------------------------------------------------------------------------------------------------|
| `main.tf`         | Terraform modules to create RDS MySQL DB.                                                               |
| `outputs.tf`      | Holds the output variables which can be used by other modules throughout the infrastructure.          |
| `variables.tf`    | Holds the variables which will be passed to main.tf.                                                  |
|---------------------------------------------------------------------------------------------------------------------------|
