# UseGalaxy.\* Shared Data [![Build Status](https://build.galaxyproject.eu/buildStatus/icon?job=usegalaxy-eu%2Fshared-data)](https://build.galaxyproject.eu/job/usegalaxy-eu/job/shared-data/)

The central repo for the data libraries that are shared across `usegalaxy.*`. This is automatically updated on a weekly basis.

## Design

- We create the GTN.yaml file from `bin/mergeyaml.py` in the training material.
- On our [build system](https://build.galaxyproject.eu/job/usegalaxy-eu/job/shared-data/), on a weekly basis:
  1. We decrypt the secrets:

     ```json
     {
       "eu": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
       "org": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
     }
     ```

  2. We loop over the servers in [`servers.json`](./servers.json), and run `setup-data-libraries` for each one.
  3. At the end of the loop we update the permissions on each dataset to be public, if it wasn't already.

## Joining

Please [email us](mailto:security@usegalaxy.eu) with:

1. An API key of a non-admin user
2. The library ID for an already created data library

   Please create it with:

   Field       | Value
   ---         | ---
   Name        | `GTN - Material`
   Synopsis    | `Galaxy Training Network Material`
   Description | `Galaxy Training Network Material. See https://training.galaxyproject.org`

3. Your server's URL

And we can add you to this automation, and you'll always be ready to run trainings.

## Updating

Run `./build.sh`
