#!/bin/bash
# profile and vector index
# sudo -u opc /home/opc/sqlcl/bin/sql -cloudconfig /home/opc/demo/wallet.zip admin/WelCome123##@myatp_medium @/home/opc/demo/sql/create_profile_vectoridx.sql
sudo -i -u opc bash --rcfile /home/opc/.bashrc -c "sql -cloudconfig /home/opc/demo/wallet.zip admin/WelCome123##@myatp_medium @/home/opc/demo/sql/create_profile_vectoridx.sql"

# springboot
cd /home/opc/demo/springboot-selectai-api
sudo -i -u opc bash --rcfile /home/opc/.bashrc -c "mvn spring-boot:run"

# reactjs
cd /home/opc/demo/react-selectairag-chatapp
npm run build
pc node server.js