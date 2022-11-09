#!/bin/bash

echo "Acessando a pasta .git"
cd .git/hooks

echo "Removendo prepare-commit-msg.sample"
rm prepare-commit-msg.sample

echo "Criando prepare-commit-msg"
touch prepare-commit-msg

echo "Setando permissões para o arquivo prepare-commit-msg"
chmod 755 prepare-commit-msg

echo "Escrevendo o arquivo prepare-commit-msg"
cat > prepare-commit-msg << 'EOM'
#!/bin/bash
# This way you can customize which branches should be skipped when
# prepending commit message.
 
if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master develop test)
fi
 
BRANCH_NAME=$(git symbolic-ref --short HEAD)
BRANCH_EXCLUDED=$(printf "%s\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")
BRANCH_IN_COMMIT=$(grep -c "\[$BRANCH_NAME\]" $1)

US_NUMBER=$(echo $BRANCH_NAME| cut -d'/' -f 2)

TYPE=$(echo $BRANCH_NAME| cut -d'/' -f 3)
TYPE=${TYPE^^}
NTYPE=$(echo $BRANCH_NAME| cut -d'/' -f 4)

BRANCH_NAME='us/'$US_NUMBER'] '$TYPE'-'$NTYPE' - '
 
if [ -n "$BRANCH_NAME" ] && ! [[ $BRANCH_EXCLUDED -eq 1 ]] && ! [[ $BRANCH_IN_COMMIT -ge 1 ]]; then
  echo '['"$BRANCH_NAME"' '$(cat "$1") > "$1"
fi
EOM
