#!/usr/bin/env python
# coding: utf-8

import json
# import numpy
from neo4j import GraphDatabase


# Here substitute with your uri, user and pwd, if necessary
URI = "bolt://127.0.0.1:7687"
USER = "neo4j"
PASSWORD = "neo4j"

# Here change filename if necessary
FILENAME = "dataset.json"


def execute(driver, query):
    """Execute a query."""
    with driver.session() as session:
        if len(query) > 0:
            result = session.run(query)
            return result


def load_data():
    """Load the dataset from json."""
    driver = GraphDatabase.driver(
        URI, auth=(USER, PASSWORD))

    clean_query = "MATCH (n) DETACH DELETE n"
    execute(driver, clean_query)

    with open(FILENAME, "r+") as f:
        json_data = json.load(f)

    nodes_to_remove = []

    # If the dataset is too large and everything is slow, uncomment the following code,
    # it will remove N (by default 700) random nodes from the data)
    # (do not forget to uncomment 'import numpy' on the top)
    # N = 700 # number of nodes to remove
    # nodes_to_remove = numpy.random.choice(
    #     [n["id"] for n in json_data["graph"]["nodes"]], N, replace=False)

    # Create nodes
    for n in json_data["graph"]["nodes"]:
        if n["id"] not in nodes_to_remove:
            query = (
                "CREATE (n:{}) \n".format(json_data["node_labels"][n["id"]]) +
                "SET n.id = toString({}) \n".format(n["id"])
            )
            for k, v in n["attrs"].items():
                query += "SET n.{} = \"{}\"\n".format(k, v["data"][0])
            execute(driver, query)

    # Create relationships
    for e in json_data["graph"]["edges"]:
        query = (
            "MATCH (s:{} {{id: \"{}\"}}), (t:{} {{id: \"{}\"}}) \n".format(
                json_data["node_labels"][e["from"]], e["from"],
                json_data["node_labels"][e["to"]], e["to"]) +
            "MERGE (s)-[r:{}]->(t)\n".format(e["label"])
        )
        for k, v in e["attrs"].items():
            query += "SET r.{} = \"{}\"\n".format(k, v["data"][0])
        execute(driver, query)


if __name__ == '__main__':
    load_data()
