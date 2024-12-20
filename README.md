# Docker Compose Configuration for OpenMRS 2.6.9 Deployment
-
Project can be used to either run an 2.6.9 instance or upgrade an 2.3.x instance (it uses the OpenMRS platform 2.6.9 war file). In order to launch/run, one is required to provide an sql dump of desired OpenMRS instance. When first run, the openmrs database will be created and then populated with the data from the provided sql dump. The subsequent run however, will skip this step.

## Steps to run
1. Place the SQL dump of the database which has to be named _openmrs.sql_ in _**/database/scripts**_ directory.
2. While in the project's directory run the command `docker compose up -d`.

**Note:** Don't forget to provide the required SQL dump file.



# Docker Compose Configuration for OpenMRS 2.6.9 Deployment and dbsync
1. Place the SQL dump of the database which has to be named _openmrs.sql_ in _**/database/scripts**_ directory.
2. Make sure you follow the instruction in this guide to set dbsync properties
   
   [EIP README](./dbsync/README.md)
    
3. Start the project 

```
    docker compose -f docker compose dbdsync up -d

````




Follow the container logs using

```
docker logs --follow openmrs-eip-sender
```
