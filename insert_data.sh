#! /bin/bash

if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE games, teams"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINGOALS OPGOALS; do
  LASTW=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  LASTOP=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  if [[ -z $LASTW && $WINNER != winner ]]; then
    INSERT_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
  fi
  if [[ -z $LASTOP && $OPPONENT != opponent ]]; then
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
  fi

  LASTW=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  LASTOP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ $YEAR != year && $ROUND != round && $WINGOALS != winner_goals && $OPGOALS != opponent_goals ]]; then
    $PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR, '$ROUND', $LASTW, $LASTOP, $WINGOALS, $OPGOALS)"
  fi

done
