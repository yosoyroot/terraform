## To figure out

- how to use multple var-file and not overwrite the existing EC2 created.
  - if you run the apply command without the var file it will use the default, however if you rerun it again with the var file it takes the new data and recreates EC2, might need to explore to use for_each instead of count to make sure it doesn't recreate.

## TODO

- update to use load balancer
- update to use elastic IP


## Observations

- When you change the ami on the config files, it will not recreate the VMs with the new OS, find out why.
    - I know why, it was taking the value from the tfvars file, find out more how to use tfvars files.