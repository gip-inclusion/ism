# ISM GIP Plateforme de l'inclusion

Proof of Concept for an up to date information system map based on [neo4j](https://neo4j.com/)

> *"At a time when cyberattacks are growing in number and complexity, it is necessary for organizations to develop a general risk management strategy. As part of an overall approach, mapping is a key tool in keeping control over the information system. It provides insight into all of the information system’s components and a clearer picture of the IS by presenting it from different angles."* [**French Cybersecurity Agency**](https://cyber.gouv.fr/publications/mapping-information-system)

## Objectives

### 1. Knowledge

Knowing public and private resources and having a list of every physical and numeric component in our information system is a key tool to build up our cybersecurity strategy.

The aim is to have a list of these entities and their relations:

- **Organizations** and their people related to our information system
- **Offices** and their **networks**
- **Collaborators** and **partners** and their access to tools and resources (computers, SaaS tooling, servers, etc.)
- Production and development **infrastructures**, their providers, integrations and accesses
- **Tooling** used by teams, its accesses and integrations

### 2. Maintainability

The main issue is to maintain this map up to date.

The main idea is to publish it with a proper access management with:

- A browser client to easily rw data
- A CLI with prepared queries to facilitate CRUD operations
- A proper strong versioning and backup system

### 3. Incident response

The overall goal beyond strategic decisions is to provide incident responders a quick and clean data in case of cyber crisis to facilitate their work:

- Having prepared queries for quickly fetch infected resource relations (by resource type, relation type, etc.)
- Export in expandable formats (to be define)
- Emergency deployment without personal data for responder quick access if needed

## Composition

Clear text files:

- **Documentation, licence and dotfiles**
- `scripts/encryption_manager.sh`: encrypt/decrypt data sources

Encrypted files:

- `data.enc`: encrypted data sources

## Usage

### Deploy

- Clone repository:

```sh
git clone git@github.com:gip-inclusion/ism.git
cd ism
chmod +x scripts/encryption_manager.sh
```

- Encryption:

```sh
# Requires ISM_ENCRYPTION_KEY in the environment. It can be in a .env file
./scripts/encryption_manager.sh -e
```

- Decryption:

```sh
# Requires ISM_ENCRYPTION_KEY in the environment. It can be in a .env file
./scripts/encryption_manager.sh -d
```

- Run:

```sh
# Binds a volume with local ./database to persist database
docker compose up -d

# deploys a neo4j browser available at 127.0.0.1:7474
# default credentials are neo4j:password but can be overwritten with NEO4J_USERNAME NEO4J_PASSWORD
```

- Migrate:

```sh
docker exec <container id/name> cypher-shell -f /tmp/data/database.cypher -u "$NEO4J_USERNAME" -p "$NEO4J_PASSWORD"
```

### Versioning

A precommit git hook is defined to encrypt last `data` folder changes

### Querying database

- Fetch all data: `MATCH (n)-[r]->(m), RETURN n,r,m`
- Delete all data: `MATCH (n) DETACH DELETE n`
