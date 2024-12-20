Build instructions:

1. cd into the desired build directory.

2. Build the image:
   - docker build . -t hub.csaude.org.mz/sesp/mysql:8.4.2
   - docker build . -t hub.csaude.org.mz/sesp/tomcat:9.0.91 

Opcional when confirmed to be the latest version:
   - docker build . -t hub.csaude.org.mz/sesp/mysql:8.4.2 -t hub.csaude.org.mz/sesp/mysql:latest
   - docker build . -t hub.csaude.org.mz/sesp/tomcat:9.0.91 hub.csaude.org.mz/sesp/tomcat:latest

3. Push the image to the C-Saúde container repository.
   - docker push hub.csaude.org.mz/sesp/tomcat:9.0.91
   - docker push hub.csaude.org.mz/sesp/tomcat:latest

