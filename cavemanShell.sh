set -e

echo "found $# args"

echo "FYI on 2.1.1, THIS SCRIPT ASSUMES SOLR IS RUNNING IT'LL FAIL OTHERWISE. ITS GOING TO STOP SOLR AND RUN. ON 2.3, change to ant restart"

echo "first argument should be kai-en-us directory"
echo "second argument should be annotation source to test"

if [ "$#" -gt 0 ]
then
	echo args found
	echo $1 "is the kai_en_us directory"
	kai_en_us=$1
else
	kai_en_us=/Users/davidwiner/documents/kai/apps/kai-en-us/
	echo "kai en us: " $kai_en_us
fi

if [ "$#" -gt 1 ]
then 
	echo $2 "is the annotation source name to train without"
	annotation_source=$2
else
	annotation_source=liv.annotation.12172018
	echo "annotation_source = liv.annotation.12172018"
fi

da_path_to_faq_gz=/conf/domain/lola/user/parser/grammar/apps/liv/languages/en_AE/
faq_gz=faq.xml.gz
faq_ending=faq.xml
caveman_ending=faq_caveman.xml

echo "first step is to del scopes and save as caveman.faq, using cavemanDelScopes.py"

python3 cavemanDelScopes.py --source $annotation_source

echo "now that faq_caveman.xml is created, we are saving original faq as faq.xml.precaveman"
echo "save this: " ${kai_en_us}${da_path_to_faq_gz}${faq_gz}
echo "as: " ${kai_en_us}${da_path_to_faq_gz}faq.xml_precaveman.gz
mv ${kai_en_us}${da_path_to_faq_gz}${faq_gz} ${kai_en_us}${da_path_to_faq_gz}faq.xml_precaveman.gz

echo "rename faq_caveman.xml into faq.xml"
mv ${kai_en_us}${da_path_to_faq_gz}${caveman_ending} ${kai_en_us}${da_path_to_faq_gz}${faq_ending}

echo "gzip faq.xml"
gzip ${kai_en_us}${da_path_to_faq_gz}${faq_ending}

echo "change directory to kai en us"
cd $kai_en_us

ant drop.db

solr_path=${kai_en_us}../../reporting/solr
echo "solr path: " $solr_path

# restart solr
cd $solr_path
ant stop
cd $kai_en_us

# TRAIN
ant stat.parser.trainer -DsubApp=liv -Ddomain_locale=en_AE
ant dynamic.intents.generate -DsubApp=liv -Ddomain_locale=en_AE

echo running liv in a new window
osascript -e 'tell application "Terminal" to activate' -e 'tell application "Terminal" to do script "cd '$kai_en_us'; ant run -DsubApp=liv -Ddomain_locale=en_AE" in selected tab of the front window'
sleep 145


cd $solr_path

ant clean run

cd $kai_en_us

test_path=${kai_en_us}../../tests/

echo "test_path: " ${test_path}

cd ${test_path}

ant unit.enbd-liv-en-ae-gold-take2