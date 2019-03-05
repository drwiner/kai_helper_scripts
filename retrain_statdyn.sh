set -e

echo "found $# args"

cd /Users/davidwiner/documents/kai/apps/kai-en-us/

ant drop.db

# ZIP it
if [ "$#" -gt 0 ]
then
	echo args found
	if [ "$1" = "gzip" ]
	then
		echo "Gzipping faq.xml"
		gzip /Users/davidwiner/documents/kai/apps/kai-en-us/conf/domain/lola/user/parser/grammar/apps/liv/languages/en_AE/faq.xml
	fi
fi




# restart solr
cd /Users/davidwiner/documents/kai/reporting/solr
ant stop
cd /Users/davidwiner/documents/kai/apps/kai-en-us/

# TRAIN
ant stat.parser.trainer.tensorflow -DsubApp=liv -Ddomain_locale=en_AE
ant dynamic.intents.generate -DsubApp=liv -Ddomain_locale=en_AE

if [ "$#" -gt 1 ]
then
	if [ "$1" = "run" ]
	then
		echo running liv
		osascript -e 'tell application "Terminal" to activate' -e 'tell application "Terminal" to do script "run_liv" in selected tab of the front window'
		sleep 145
	fi
elif [ "$#" -gt 2 ]
then
	if [ "$2" = "run" ]
	then
		echo "running liv"
		osascript -e 'tell application "Terminal" to activate' -e 'tell application "Terminal" to do script "run_liv" in selected tab of the front window'
		sleep 145
	fi	
fi

cd /Users/davidwiner/documents/kai/reporting/solr

ant clean run

sleep 135

cd /Users/davidwiner/documents/kai/apps/kai-en-us/

if [ "$#" -gt 2 ]
then
	if [ "$3" = "test" ]
	then
		./run_tests.sh
	fi
elif [ "$#" -gt 1 ]
then
	if [ "$2" = "test" ]
	then
		./run_tests.sh
	fi
elif [ "$#" -gt 0 ]
then
	if [ "$1" = "test" ]
	then
		./run_tests.sh
	fi
fi
