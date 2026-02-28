# Cleanup old TaskRuns and PipelineRuns

Here is how users can clean up old TaskRuns and PipelineRuns.

The general method is to use a CronJob to trigger a Task that deletes all but the `n` most recent PipelineRuns and `2*n` most recent TaskRuns.

## Prerequisites

* A Kubernetes cluster with Tekton Pipelines installed
* Several old TaskRuns and/or PipelineRuns you wish to delete

## Scheduling the cleanup job

You'll need to install all the files in this directory to run the cleanup task.

* [serviceaccount.yaml](serviceaccount.yaml): this creates the service account needed to run the job, along with the associated ClusterRole and Rolebinding.

* [cleanup-template.yaml](cleanup-template.yaml): this creates the TriggerTemplate that spawns the TaskRun that does the deleting. It uses the `tkn` CLI to do the deleting.

* [binding.yaml](binding.yaml): this creates the TriggerBinding that is used to pass parameters to the TaskRun.

* [eventlistener.yaml](eventlistener.yaml): this creates the sink that receives the incoming event that triggers the creation of the cleanup job.

* [cronjob.yaml](cronjob.yaml): this is used to run the cleanup job on a schedule. There are two environmental variables that need to be set in the job: `NAMESPACE` for the namespace you wish to clean up, and `CLEANUP_KEEP` for the number of PipelineRuns to keep (the job will keep twice as many TaskRuns as this number). The schedule for the job running can be set in the `.spec.schedule` field using [crontab format](https://crontab.guru/)
