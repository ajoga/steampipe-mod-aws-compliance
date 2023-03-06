locals {
  conformance_pack_sqs_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/SQS"
  })
}

control "sqs_queue_policy_prohibit_public_access" {
  title       = "SQS queue policies should prohibit public access"
  description = "Manage access to resources in the AWS Cloud by ensuring AWS SQS queues cannot be publicly accessed."
  query       = query.sqs_queue_policy_prohibit_public_access

  tags = merge(local.conformance_pack_sns_common_tags, {
    other_checks = "true"
  })
}

control "sqs_queue_dead_letter_queue_configured" {
  title       = "SQS queues should be configured with a dead-letter queue."
  description = "Ensure SQS queue is configured with a dead-letter queue. Dead-letter queues are useful for debugging your application or messaging system because they let you isolate problematic messages to determine why their processing didn't succeed."
  query       = query.sqs_queue_dead_letter_queue_configured

  tags = merge(local.conformance_pack_sns_common_tags, {
    other_checks = "true"
  })
}

query "sqs_queue_policy_prohibit_public_access" {
  sql = <<-EOQ
    with wildcard_action_policies as (
      select
        queue_arn,
        count(*) as statements_num
      from
        aws_sqs_queue,
        jsonb_array_elements(policy_std -> 'Statement') as s
      where
        s ->> 'Effect' = 'Allow'
        and (
          ( s -> 'Principal' -> 'AWS') = '["*"]'
          or s ->> 'Principal' = '*'
        )
      group by
        queue_arn
    )
    select
      -- Required Columns
      q.queue_arn as resource,
      case
        when p.queue_arn is null then 'ok'
        else 'alarm'
      end as status,
      case
        when p.queue_arn is null then title || ' does not allow public access.'
        else title || ' contains ' || coalesce(p.statements_num,0) ||
        ' statements that allows public access.'
      end as reason
      -- Additional Dimensions
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "q.")}
    from
      aws_sqs_queue as q
      left join wildcard_action_policies as p on q.queue_arn = p.queue_arn;
  EOQ
}

query "sqs_queue_dead_letter_queue_configured" {
  sql = <<-EOQ
    select
      -- Required Columns
      queue_arn as resource,
      case
        when redrive_policy is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when redrive_policy is not null then title || ' configured with dead-letter queue.'
        else title || ' not configured with dead-letter queue.'
      end as reason
      -- Additional Dimensions
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_sqs_queue;
  EOQ
}