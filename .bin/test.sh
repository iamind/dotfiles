#!/bin/zsh


echo '----------seq----------'
for i in `seq 10 15`
do
	echo $i
done
echo '--------------------'



echo 'who are you?'
read username
echo "Hello, $username!"
