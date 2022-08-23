#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n ~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n" 

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) SERVICE_MENU ;;
    2) SERVICE_MENU ;;
    3) SERVICE_MENU ;;
    4) SERVICE_MENU ;;
    5) SERVICE_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE_MENU() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read  CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    # get new customers name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read  CUSTOMER_NAME
    # insert new customer into customers table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # get customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  # get time
  echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  
  # insert records
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
}


MAIN_MENU