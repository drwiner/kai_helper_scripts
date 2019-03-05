import os
import re
import json
import argparse
from lxml import etree

IN_PATH = "/Users/davidwiner/documents/kai/Apps/kai-en-us/conf/domain/lola/user/parser/grammar/apps/"  ######
OUTPUT_PATH = "/Users/davidwiner/documents/kai/apps/kai-en-us/"  ######

args = {
    "in_faq": IN_PATH + "/%s/languages/%s/faq.xml.gz",
    "out_file": OUTPUT_PATH + "/faq.xml",
    "sub_app": "liv",
    "locale": "en_AE",
    "scopes_to_del": ["liv.annotation.12172018"]  ######
       }


def walk_tree(args):
    tree = etree.parse(args["in_faq"] % (args["sub_app"], args["locale"]))
    root = tree.getroot()

    intents = root.findall(".//intent")
    intent_parent = root.find(".//intents")

    for intent in intents[:]:
        intent_name = intent.attrib["name"].strip()
        qas = intent.findall(".//qa")

        for qa in qas[:]:
            qa_label = qa.attrib["label"].strip()
            questions = qa.findall(".//question")

            for ques in questions[:]:
                if ques.attrib["source"].strip() in args["scopes_to_del"]:
                    print("removed " + str(ques))
                    qa.remove(ques)

            if len(qa.findall(".//question")) == 0:
                intent.remove(qa)

    tree.write(args["out_file"], encoding="utf-8", xml_declaration=True)


def main():
    walk_tree(args)


if __name__ == "__main__":
    main()
