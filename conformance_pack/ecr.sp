locals {
  conformance_pack_ecr_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/ECR"
  })
}

control "ecr_repository_image_scan_on_push_enabled" {
  title       = "ECR repositories image scan on push should be enabled"
  description = "Ensure if a Amazon Elastic Container Registry (ECR) repositories has image scanning enabled. The rule is non compliant if image scanning is not enabled for the private ECR repository."
  sql         = query.ecr_repository_image_scan_on_push_enabled.sql

  tags = merge(local.conformance_pack_ecr_common_tags, {
    other_checks = "true"
  })
}

control "ecr_repository_prohibit_public_access" {
  title       = "ECR repositories should prohibit public access"
  description = "Ensure there are no ECR repositories set as public."
  sql         = query.ecr_repository_prohibit_public_access.sql

  tags = merge(local.conformance_pack_ecr_common_tags, {
    other_checks = "true"
  })
}

