data "aws_iam_policy" "cwagent" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_iam_policy" "cwlogs_full" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

locals {
  node_role_arn_parts = split("/", module.eks.eks_managed_node_groups["default"].iam_role_arn)
  node_role_name      = element(local.node_role_arn_parts, length(local.node_role_arn_parts) - 1)
}

resource "aws_iam_role_policy_attachment" "nodes_cwagent" {
  role       = local.node_role_name
  policy_arn = data.aws_iam_policy.cwagent.arn
}

resource "aws_iam_role_policy_attachment" "nodes_cwlogs" {
  role       = local.node_role_name
  policy_arn = data.aws_iam_policy.cwlogs_full.arn
}
