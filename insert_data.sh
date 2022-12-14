#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != "year" ]]
  then
    #check existing winner team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ $WINNER_ID == "" ]]
    then
      TEAMS=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')");
      if [[ $TEAMS == "INSERT 0 1" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo -e "...Inserted new team:$WINNER with id=$WINNER_ID"
      fi
    else
      echo -e "Team already exists with id=$WINNER_ID..."
    fi
    #check existing opponent team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ $OPPONENT_ID == "" ]]
    then
      TEAMS=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')");
      if [[ $TEAMS == "INSERT 0 1" ]]
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo -e "...Inserted new team:$OPPONENT with id=$OPPONENT_ID"
      fi
    else
      echo -e "Team already exists with id=$OPPONENT_ID..."
    fi
    #insert game
    GAME_ID=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $GAME_ID == "INSERT 0 1" ]]
    then
      echo -e "\n\tGame inserted\n"
    fi
  fi
done
