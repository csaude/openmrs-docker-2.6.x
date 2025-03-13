FROM mysql:8.4.2
COPY run.sh /run.sh
COPY openmrs_indexes.sql /openmrs_indexes.sql
EXPOSE 3306
CMD ["/run.sh"]
