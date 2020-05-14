# GGIRCS Technical Documentation and Style Guide

The technical stack is a composed of a backend made with a PostgreSQL database and an Express server with a PostGraphile API, and a frontend made with Next.js, React, Relay and TypeScript.

This document defines the interactions between the elements of the stack, and the various style conventions used across the code base.

## Stack Overview

### PostgreSQL

#### Why PostgreSQL?

- Extensions (PostGIS, XML)
- Scale across multiple nodes with Citus
- Access to other databases using foreign data wrappers
- Unit testing with pgtap
- Support for functions written in various programming languages

### Database change management

We reviewed several tools which would allow us to handle database migrations. The following features were considered required for the tool:

- The tool should support migration scripts should written in SQL and PL/PGSQL
- The tool should allow us to define releases following semantic versioning
- The tool should be able to handle failing migrations, and deploy migrations in a transaction

The two tools we analyzed in depth are sqitch ([https://sqitch.org/](https://sqitch.org/)) and Flyway ([https://flywaydb.org/](https://flywaydb.org/)).

#### Migrations and releases

In database change management tools, a migration is a set of SQL commands creating, deleting or altering a set of database object. In both sqitch and flyway, migrations can be stored in SQL files. Additionally, flyway supports writing migrations in Java files, for more complex processes.

The mechanism used to define the migrations order is different for both tools.

- Sqitch uses a &quot;plan&quot; file, listing the migrations names in the order in which they should be deployed, and their dependencies. The sqitch tag command allows to cut releases
- Flyway uses version numbers, stored in the file name, e.g. _V1.44.23.76\_\_migration\_description.sql_ for &quot;versioned migrations&quot; and supports &quot;repeatable migrations&quot; (filename starting with &quot;R\_\_&quot;), which are executed after all the versioned migrations are deployed, in order of their descriptions (e.g. _R\_\_0001\_viewA.sql_, then _R\_\_0002\_viewB.sql_)

#### Reverting migrations

In development and test environments, reverting migrations is required to start from a clean database. In production, this can be needed to undo a &quot;bad&quot; release.

- For both use cases, sqitch requires the developer to write a &quot;revert&quot; migration for each &quot;deploy&quot; migration they write (a sqitch &quot;change&quot; has as _deploy_, a _revert_, and a _verify_ file)
- For dev/test environments, Flyway has a &quot;clean&quot; command that deletes all the objects in the schemas managed by Flyway. For production reverts, the &quot;pro&quot; version of Flyway supports &quot;undo&quot; migrations, but this could be accomplished by deploying another release with migrations that undo the changes.

#### Handling Errors in Migrations

Errors occurring during the migrations are common in dev and test environments, due to bugs in the migration files. They can also occur in production if, for instance, there are issues connecting to the database.

Flyway handles errors by wrapping each migration in a transaction. Optionally, the entire set of migrations being deployed can be wrapped in a single transaction by setting the _group_ property to _true_.

Sqitch makes use of the verify scripts to ensure that a migration is deployed. If a migration fails, it will revert the previous migrations that were deployed in the current run, using the revert script. Sqitch does not wrap migrations in transactions, requiring the developer to add begin and commit/rollback statements to each script. Additionally, sqitch does not support wrapping the entire set of migrations in a single transaction. Furthermore, it does not reuse the connection to the database, making it very sensitive to DNS issues. Such issues have even led to the database and the sqitch changelog to be in inconsistent state, requiring manual fixes, because executing a migration and adding it to the database changelog is not done in a transaction.

#### Other tools

Other tools such as alembic ([https://alembic.sqlalchemy.org/](https://alembic.sqlalchemy.org/)) and liquibase ([https://www.liquibase.org/](https://www.liquibase.org/)) were reviewed but were not selected as

- Alembic does not use plain SQL files for migrations (uses python files)
- Liquibase has a very verbose format for the changelog, plain SQL files are supported but are not the default, and documentation is lacking.

### Express + PostGraphile

### Next.js (incl. React)

✨ magic ✨

### Relay

🐉 Here be dragons 🐉 ⛵

### Typescript

❤️❤️❤️❤️

### Yarn

### Authentication and Authorization

## Documentation

### Writing to the database using Relay mutations

#### Mutation Chains

- Individual mutations can be chained on the front-end, but this approach does not effectively cover transactionality.
- To make all actions transactional (succeed as one block or fail as one block), Whenever a mutation has cascading effect we have written some custom mutation chains in the database
- For example: creating a new application in the ggircs\_portal schema also requires (among other. things) the creation of a row in the application\_status table.
- The creation of the row in the application table and the row in the application\_status table is completed in one transactional block in a custom defined mutation chain function written in sql, which can then be used in place of the front-end chained mutations.
- Be careful to define the proper return type for any custom functions as an incorrect function return can cause the mutation to fail.

#### Optimistic Updates

#### Debouncing Mutations

### Dealing with unknown types generated by Relay

### Database Views and PostGraphile

Smart comments

### Custom search functions

### Json schema forms

## Style Guide

###

### Database naming conventions

Snake case. Don&#39;t use reserved words (c.f. style test)

### Front-end naming conventions

### \*status properties

Use an enum, keep status rows immutables, add a status computed field

### Organize next.js pages according to roles

### Use Guard Clauses

# Testing

### Linting

### Database unit tests

### Components unit tests

### Integration tests

### End-to-end testing

End-to-end tests run the entire stack, from the UI to the database, in a production build, to ensure that the flow of the deployed application performs well from start to finish.

Our end-to-end tests are written using Cypress, which allows us to interact with the browser and test that the expected elements are being displayed. The Cypress tests and configurations are located in the app/cypress directory. Reading through the cypress core concepts guide is strongly recommended before starting to write tests ([https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Cypress-Can-Be-Simple-Sometimes](https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Cypress-Can-Be-Simple-Sometimes))

#### Tools

- Cypress (https://www.cypress.io/)
- io (https://percy.io/)

#### Login flow and environment variables

Cypress allows developers to write custom commands (defined in app/cypress/support/commands.js). Two such commands that we implemented are cy.login(username, password) and cy.logout() . They allow us to log in the application using the Keycloak single-sign-on server deployed on Pathfinder. We created three test accounts on the realm used in this application, one for each user role.

A `cypress.env.json` file is available on the CAS Scrum team SharePoint (TODO: Should be moved to OpenShift). This file should be downloaded into the project&#39;s `app` folder. This file defines the username and passwords for the test users in environment variables, which can be retrieved using the cy.env(&#39;VAR\_NAME&#39;) function.

#### Running end-to-end tests

- Start the database
- Deploy the development data using `.bin/deploy-data.sh -p -dev`
- Start the application using your favorite command. On CI, it will run it in production mode, with auth enabled. While developing, however, you can run `yarn dev NO_AUTH` in most cases
- The feature flags `yarn dev NO_PDF` and `yarn dev NO_MATHJAX` are available for running Cypress tests
- These flags block the rendering of long asynchronous PDF and mathjax components that often cause a false failed response from the e2e tests.
- Run `yarn cypress` to open the Cypress UI

#### Visual testing with Percy

Percy allow us to record screenshots of the application, using the `cy.percySnapshot()` method. Unless the tests are run using Percy, with `yarn test:e2e-snapshots`, which requires the PERCY\_TOKEN environment variable to be defined (see the project settings here: [https://percy.io/bcgov-cas/cas-ciip-portal/settings](https://percy.io/bcgov-cas/cas-ciip-portal/settings)). Percy will be run on the CI server, once the end-to-end tests are successful, so you do not need to run them locally. Until the Percy GitHub integration is added in the bcgov org, our pull request review process will include a manual approval (see the Version Control, Mandatory peer review section).

#### Alternatives to Percy

We explored two alternatives to Percy:

- Using `cypress-plugin-snapshots` ([https://github.com/meinaart/cypress-plugin-snapshots](https://github.com/meinaart/cypress-plugin-snapshots)) and storing the files using Git LFS. The advantage is that developers can run snapshot tests and comparison locally. However, GitHub does not display the differences in the files stored with LFS in pull requests, which would make the review process difficult. Moreover, the LFS quota is for the entire organization.
- Applitools eyes ([https://applitools.com/](https://applitools.com/)) provides functionalities like Percy. However, its user interface isn&#39;t as intuitive, its API requires more configuration, and the GitHub integration isn&#39;t available with the free plan.

#### What to test with cypress

TODO

#### Data setup and teardown

TODO

## Version Control

### Submodules

### GPG-signing

### Pre-commit

### Commit message templates &amp; changelog generation (conventional-changelog)

### Branching (trunk pattern)

### Branch protection rules

### Merging (rebase short-lived branches)

### Mandatory peer review

- Manual check on the Percy app before accepting a PR

### Issue/PR templates (coming soon to a repo near you)

### PR reviewing process

## Design

sudo Hamza --do-this -f