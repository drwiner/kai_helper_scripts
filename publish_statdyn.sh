set -e

python3 publishKeys.py
ant stat.parser.publish -DsubApp=liv -Ddomain_locale=en_AE
ant statparams.publish -DsubApp=liv -Ddomain_locale=en_AE