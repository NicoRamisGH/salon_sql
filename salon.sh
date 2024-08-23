#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?" 

MAIN_MENU() {

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  HAVE_PHONE=$($PSQL "SELECT phone, name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $HAVE_PHONE ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")   
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUST_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  


}

SERVICE_LIST(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT service_id, name FROM services")

  echo "$SERVICES" | while read SERVICE_ID BAR CUSTOMER_NAME

  do
    echo "$SERVICE_ID) $CUSTOMER_NAME"
  done

  read SERVICE_ID_SELECTED
  HAVE_SERVICE=$($PSQL "SELECT service_id, name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

  if [[ -z $HAVE_SERVICE ]]
  then
    SERVICE_LIST "I could not find that service. What would you like today?"
  else
   MAIN_MENU
  fi
}

SERVICE_LIST