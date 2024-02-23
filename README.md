# Longhorn Release

This repository is for automating Longhorn releases through GitHub actions, including regular releases, preview releases, and sprint releases.
Additionally, it also supports some extra repository and CI operations.

* [Release Process](#release-process)
* [Create a Release](#create-a-release)

## Release Process

To create a release, run a release workflow. The common steps for each workflow are outlined below, though they may vary slightly for different release types.
For the precise steps, please refer to the workflow file for each release type.

1. Set up the git environment.
2. Clone this repository.
3. Retrieve branch, tag, and milestone parameters of the planned release.
4. Update the version file in each branch-based repository.
5. Create and merge a release pull request for longhorn/longhorn and longhorn/chart repositories separately.
6. Gather artifacts, including charts.tar.gz and longhorn-images.txt.
7. Create a tag for each branch-based repository.
8. Generate a changelog.
9. Create a draft release on longhorn/longhorn until branch-based images are successfully built.

*__How to do if a failure happens during the release?__*

If any step fails, rerun the process after resolving the failure.
For step 7, the tag of each repository branch will be recreated automatically,
eliminating the need for manual intervention before rerunning the workflow, except for deleting the already created draft release on longhorn/longhorn.

If any image build fails on https://drone-publish.longhorn.io/,
which is our build service for creating and publishing Longhorn container images to Docker Hub, resolve the issue or rerun the failed build if it's flaky.
Additionally, create a ticket for the flaky issue and share it with the team.

*__What is the next after the workflow is complete?__*

After the workflow is completed, the draft release is ready. Update it if necessary, and publish it as a preview or regular release if it's generally available.

## Create a Release

### Regular release

Run the `Release` workflow by providing the following parameters.

| Parameter                         | Example                           |
| --------------------------------- | --------------------------------- |
| Branch:Tag:Milestone:PreviousTag  | `v1.6.x:v1.6.0-rc1:v1.6.0:v1.5.0` |

Check [the workflow file](.github/workflows/release.yml) to understand the detailed steps.

### Preview release

Run the `Release - Preview` workflow by providing the following parameters.

| Parameter                         | Example                           |
| --------------------------------- | --------------------------------- |
| Branch:Tag:Milestone:PreviousTag  | `v1.6.x:v1.6.0-rc1:v1.6.0:v1.5.0` |

Check [the workflow file](.github/workflows/release-preview.yml) to understand the detailed steps.

### Sprint release

Run the `Release - Sprint` workflow by providing the following parameters. This will be set to automatically run on a (bi)weekly cadence.

Check [the workflow file](.github/workflows/release-sprint.yml) to understand the detailed steps.
