# Make executable with chmod +x <<filename.sh>>

CURRENTDIR=${pwd}

GITHUB_API_TOKEN=`token.sh get github`

if [[ $? -ne 0 ]]
then
	echo "No token 'github' found"
	exit 0
fi

# step 1: name of the remote repo. Enter a SINGLE WORD ..or...separate with hyphens
echo "What name do you want to give your remote repo?"
read REPO_NAME

echo "Enter a repo description: "
read DESCRIPTION

echo "What is your github username?"
read USERNAME

# step 2: initialise the repo locally, create blank README if it doesn't exist, add and commit
git init
if [-f "README.md"]; then
	echo "README found, not creating..."
else
	touch README.md
fi
git add *
git commit -m 'initial commit -setup with .sh script'

# step 3: use github API to create the repo
curl \
-X POST \
-H "X-GitHub-Api-Version: 2022-11-28" \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token ${GITHUB_API_TOKEN}" \
https://api.github.com/user/repos \
-d '{"name":"'"${REPO_NAME}"'", "description": "'"${DESCRIPTION}"'", "private":"true"}' | jq '{id,name,created_at}'

#  step 4 add the remote github repo to local repo and push
git remote add origin https://github.com/${USERNAME}/${REPO_NAME}.git
git push --set-upstream origin main

echo "Done. Go to https://github.com/$USERNAME/$REPO_NAME to see." 
