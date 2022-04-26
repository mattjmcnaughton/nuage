resource "aws_emr_cluster" "cluster" {
  name = "${local.name_prefix}-emr"
  release_label = "emr-5.28.0"
  applications = ["Spark"]

  termination_profection = false
  keep_job_flow_alive_when_no_steps = true
}
