SalesTaxes
==========

Software requirements
RVM should be installed
Bundle gem should be installed


*Setup*

CD in the project directoty and RVM should pick .version.conf and
* try to sed the right ruby version
* create the specific gemset for the project
* run bundle


*Tests*

To run the integration tests
NO_COV=true rspec --tag integration

To run unit tests
rspec