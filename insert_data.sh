#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then 
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$WINNER'")
    echo TEAM_ID="$TEAM_ID"
    if [[ -z $TEAM_ID ]]
    then
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then 
            echo Inserted Team ,$WINNER
        fi
    fi    
    #TEAM_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$WINNER'")
  fi 
  #to check opponent is present or not else insert
  if [[ $OPPONENT != "opponent" ]]
  then 
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM TEAMS WHERE name='$OPPONENT'")
    echo TEAM_ID="$TEAM_ID"
    if [[ -z $TEAM_ID ]]
    then
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
        then 
            echo Inserted Team ,$OPPONENT
        fi
    fi    
  fi
  # TO insert data in games table 
  if [[ $YEAR != 'year' ]]
  then 
    #Get winners team id from teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #Get opponents team id from teams table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
        echo Inserted Game, $WINNER vs $OPPONENT
    fi
  fi    
done 
