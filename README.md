# Olas SDK Starter

Example of minimum configuration files needed in order to deploy an autonomous agent built with any framework. These instructions allow the agent blueprint and AI agent to be registered on {{ autonolas_protocol_registry_dapp }} and executed through Olas Quickstart.

## System requirements

- Python `>=3.10`
- [Pipenv](https://pipenv.pypa.io/en/latest/installation/) `>=2021.x.xx`

## Prepare the environment

Clone the repository:

      git clone git@github.com:valory-xyz/olas-sdk-starter.git

Create development environment:

      make new_env

Enter virtual environment:
      
      pipenv shell

## Configure your agent

To execute your agent through Olas Quickstart you will need to build a docker image with your agent code and push it to [Docker Hub](https://hub.docker.com/) into a public repository, the docker image of your agent will need to follow a specific naming convention. 

The steps to configure your agent will dictate where Olas Quickstart will look for your docker image, the docker namespace where this image will be hosted is your agent blueprint author, the image name will be the agent blueprint name (prefixed with `oar-`) and the tag will be the hash of your agent blueprint package. Follow the steps below to adjust configuration files with your agent blueprint's information:

### Adjust your agent blueprint configuration
On [packages/valory/agents/olas_hello_world/aea-config.yaml](packages/valory/agents/olas_hello_world/aea-config.yaml) adjust the fields:
      
- `agent_name` - The name of your agent blueprint, this will be the name of your agent blueprint image in [Docker Hub](https://hub.docker.com/).
      
- `author` - The name of your [Docker Hub](https://hub.docker.com/) namespace.

- `description` - The description of your agent blueprint

### Adjust your AI agent configuration

On [packages/valory/services/olas_hello_world/service.yaml](packages/valory/services/olas_hello_world/service.yaml) adjust the fields:
- `name` - Use the same name as your agent blueprint

- `author` - Use the same author as your agent blueprint

- `agent` - Update this value with your agent blueprint information, you can leave the default hash value as it will be auto-generated later: <your_agent_blueprint_author>/<your_agent_blueprint_name>:0.1.0:<your_agent_blueprint_ipfs_hash>

- `configs`: Under the configs field of the last section with public_id "valory/configs:0.1.0" configure the environment variables that need to be present in your agent blueprint, the variables you define here will be setup when executing your agent blueprint instance through Olas Quickstart but they will contain the prefix `CONNECTION_CONFIGS_CONFIG_` in their names, like `CONNECTION_CONFIGS_CONFIG_STORE_PATH`.

### Adjust folders
Rename the packages folders by the values defined above:

      
      mv packages/valory/agents/olas_hello_world packages/valory/agents/<agent_blueprint_name>
      mv packages/valory/services/olas_hello_world packages/valory/services/<ai_agent_name>
      mv packages/valory packages/<author_name>            
      

Configure the Open Autonomy CLI:

      autonomy init --reset --author <author_name> --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"

## Publish your agent blueprint

After configuring your agent blueprint and AI agent, you need to generate their package hashes and push them to IPFS, this will allow you to mint your agent blueprint at https://marketplace.olas.network/ and execute it through Olas Quickstart.

Sync all the packages:

      autonomy packages sync --update-packages

Generate packages hashes:

      autonomy packages lock

The command above will detect your agent blueprint and AI agent folder and ask what type of packages they are, answer `dev`. Once this is completed the file `packages/packages.json` should have been populated with your agent blueprint and AI agent packages.

Push the packages to IPFS

      autonomy push-all
