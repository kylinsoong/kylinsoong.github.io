#!/bin/bash

DIRNAME=`dirname "$0"`

function bash_print {
    echo "-----------------------------------------------------------------------------"
    echo $1  
    echo "-----------------------------------------------------------------------------"
    echo ""
}

count=1
Results[$count]="Results:"

function bash_print_success {
    echo "-----------------------------------------------------------------------------"
    echo $1 'Success'
    echo "-----------------------------------------------------------------------------"
    echo ""
    count=`expr $count + 1`
    Results[$count]="$1  -  Success"
}

function bash_pause {
    read -n1 -r -p "Press any key to continue..." key
}

function bash_creat_application_user {
    $TEIID_SERVER_HOME/bin/add-user.sh -a -u $1 -p $2 -g $3
    bash_print_success "Create application user($1/$2) with groups $3"
}

function bash_creat_management_user {
    $TEIID_SERVER_HOME/bin/add-user.sh $1 $2
    bash_print_success "Create management user($1/$2)"
}

function execute {
    $1
}

function execute_mvn {
    cd "$TEIID_QUICKSTART_DIR/simpleclient"; mvn exec:java -Dvdb="$1" -Dsql="$2"
}

bash_print "Run Quick Start against a Running Teiid Server"

if [ -r "$1" ]; then
    TEIID_SERVER_HOME=`cd "$1"; pwd`
else
    TEIID_SERVER_HOME=`cd "$DIRNAME"; pwd`
fi

bash_print "TEIID_SERVER_HOME: $TEIID_SERVER_HOME"


if [ -r "$TEIID_SERVER_HOME/teiid-quickstarts" ]; then
    TEIID_QUICKSTART_DIR=`cd "$TEIID_SERVER_HOME/teiid-quickstarts"; pwd`
else
    cd "$TEIID_SERVER_HOME"; git clone https://github.com/teiid/teiid-quickstarts.git
    TEIID_QUICKSTART_DIR=`cd "$DIRNAME/teiid-quickstarts"; pwd`
fi

bash_print "TEIID_QUICKSTART_DIR: $TEIID_QUICKSTART_DIR"

bash_creat_application_user dashboardAdmin password1! admin
bash_creat_application_user teiidUser password1! user 
bash_creat_application_user restUser password1! rest
bash_creat_application_user odataUser password1! odata

bash_creat_management_user admin password1!

$TEIID_SERVER_HOME/bin/standalone.sh > console.log &
sleep 10s
bash_print_success "Start Teiid Server"

# Build client
cd "$TEIID_QUICKSTART_DIR/simpleclient"; mvn clean install
bash_print_success "Build Simple Java Client"

#Run vdb-datafederation
execute "cp -r $TEIID_QUICKSTART_DIR/vdb-datafederation/src/teiidfiles/ $TEIID_SERVER_HOME"
execute "$TEIID_SERVER_HOME/bin/jboss-cli.sh --connect --file=$TEIID_QUICKSTART_DIR/vdb-datafederation/src/scripts/setup.cli"
execute "cp $TEIID_QUICKSTART_DIR/vdb-datafederation/src/vdb/portfolio-vdb.xml* $TEIID_SERVER_HOME/standalone/deployments"
sleep 3s
execute_mvn "Portfolio" "select * from product"
execute_mvn "Portfolio" "select stock.* from (call MarketData.getTextFiles('*.txt')) f, TEXTTABLE(f.file COLUMNS symbol string, price bigdecimal HEADER) stock"
execute_mvn "Portfolio" "select * from StockPrices"
execute_mvn "Portfolio" "select product.symbol, stock.price, company_name from product, (call MarketData.getTextFiles('*.txt')) f, TEXTTABLE(f.file COLUMNS symbol string, price bigdecimal HEADER) stock where product.symbol=stock.symbol"
execute_mvn "Portfolio" "select * from Stock"
execute_mvn "Portfolio" "SELECT x.* FROM (call native('select Shares_Count, MONTHNAME(Purchase_Date) from Holdings')) w, ARRAYTABLE(w.tuple COLUMNS "Shares_Count" integer, "MonthPurchased" string ) AS x"
bash_print_success "Run vdb-datafederation"

# run vdb-materialization
execute "cp $TEIID_QUICKSTART_DIR/vdb-materialization/src/vdb/portfolio-mat-vdb.xml* $TEIID_SERVER_HOME/standalone/deployments"
execute "cp $TEIID_QUICKSTART_DIR/vdb-materialization/src/vdb/portfolio-intermat-vdb.xml* $TEIID_SERVER_HOME/standalone/deployments"
sleep 3s
execute_mvn "PortfolioMaterialize" "select * from StocksMatModel.stockPricesMatView"
execute_mvn "PortfolioInterMaterialize" "select * from StocksMatModel.stockPricesInterMatView"
execute_mvn "PortfolioMaterialize" "select * from StocksMatModel.stockPricesMatView"
execute_mvn "PortfolioMaterialize" "INSERT INTO PRODUCT (ID,SYMBOL,COMPANY_NAME) VALUES(2000,'RHT','Red Hat Inc')"
execute_mvn "PortfolioMaterialize" "EXEC SYSADMIN.loadMatView('StocksMatModel', 'stockPricesMatView')"
execute_mvn "PortfolioMaterialize" "select * from StocksMatModel.stockPricesMatView"
execute_mvn "PortfolioMaterialize" "select * from StocksMatModel.stockPricesMatView option nocache"
execute_mvn "PortfolioMaterialize" "EXEC SYSADMIN.matViewStatus('StocksMatModel', 'stockPricesMatView')"
execute_mvn "PortfolioInterMaterialize" "EXEC SYSADMIN.matViewStatus('StocksMatModel', 'stockPricesInterMatView')"
execute_mvn "PortfolioMaterialize" "EXEC SYSADMIN.loadMatView('StocksMatModel', 'stockPricesMatView')"
execute_mvn "PortfolioInterMaterialize" "EXEC SYSADMIN.loadMatView('StocksMatModel', 'stockPricesInterMatView')"
bash_print_success "Run vdb-materialization"

# vdb-restservice
execute "cp $TEIID_QUICKSTART_DIR/vdb-restservice/src/vdb/portfolio-rest-vdb.xml* $TEIID_SERVER_HOME/standalone/deployments"
sleep 3s
echo "Open a broswer, adress the following api"
echo "    http://localhost:8080/PortfolioRest_1/Rest/foo/1"
echo "    http://localhost:8080/PortfolioRest_1/Rest/getAllStocks"
echo "    http://localhost:8080/PortfolioRest_1/Rest/getAllStockById/1007"
echo "    http://localhost:8080/PortfolioRest_1/Rest/getAllStockBySymbol/IBM"
echo "    http://localhost:8080/PortfolioRest_1/api"
bash_pause
cd "$TEIID_QUICKSTART_DIR/vdb-restservice/http-client"; mvn package exec:java
cd "$TEIID_QUICKSTART_DIR/vdb-restservice/resteasy-client"; mvn package exec:java
cd "$TEIID_QUICKSTART_DIR/vdb-restservice/cxf-client"; mvn package exec:java
bash_print_success "Run vdb-restservice"

bash_print "Run Quick Start Results"

#tput bold   # Bold print

for index in 1 2 3 4 5 6 7 8 9 10 11 12
do
  printf "     %s\n" "${Results[index]}"
done

#tput sgr0   # Reset terminal.

bash_print "Exit"

exit 0
