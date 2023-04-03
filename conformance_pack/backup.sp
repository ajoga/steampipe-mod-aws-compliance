locals {
  conformance_pack_backup_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/Backup"
  })
}

control "backup_recovery_point_manual_deletion_disabled" {
  title       = "Backup recovery points manual deletion should be disabled"
  description = "Checks if a backup vault has an attached resource-based policy which prevents deletion of recovery points. The rule is non compliant if the Backup Vault does not have resource-based policies or has policies without a suitable 'Deny' statement."
  query       = query.backup_recovery_point_manual_deletion_disabled

  tags = merge(local.conformance_pack_backup_common_tags, {
    cisa_cyber_essentials    = "true"
    ffiec                    = "true"
    gxp_eu_annex_11          = "true"
    hipaa_security_rule_2003 = "true"
    nist_800_171_rev_2       = "true"
    nist_csf                 = "true"
    pci_dss_v321             = "true"
    soc_2                    = "true"
  })
}

control "backup_plan_min_retention_35_days" {
  title       = "Backup plan min frequency and min retention check"
  description = "Checks if a backup plan has a backup rule that satisfies the required frequency and retention period(35 Days). The rule is non compliant if recovery points are not created at least as often as the specified frequency or expire before the specified period."
  query       = query.backup_plan_min_retention_35_days

  tags = merge(local.conformance_pack_backup_common_tags, {
    cisa_cyber_essentials    = "true"
    fedramp_low_rev_4        = "true"
    fedramp_moderate_rev_4   = "true"
    ffiec                    = "true"
    gxp_eu_annex_11          = "true"
    hipaa_security_rule_2003 = "true"
    nist_800_171_rev_2       = "true"
    nist_csf                 = "true"
    pci_dss_v321             = "true"
    soc_2                    = "true"
  })
}

control "backup_recovery_point_encryption_enabled" {
  title       = "Backup recovery points should be encrypted"
  description = "Ensure if a recovery point is encrypted. The rule is non compliant if the recovery point is not encrypted."
  query       = query.backup_recovery_point_encryption_enabled

  tags = merge(local.conformance_pack_backup_common_tags, {
    cisa_cyber_essentials    = "true"
    ffiec                    = "true"
    gxp_eu_annex_11          = "true"
    hipaa_security_rule_2003 = "true"
    nist_800_171_rev_2       = "true"
    nist_csf                 = "true"
    pci_dss_v321             = "true"
    soc_2                    = "true"
  })
}

control "backup_recovery_point_min_retention_35_days" {
  title       = "Backup recovery points should not expire before retention period"
  description = "Ensure a recovery point expires no earlier than after the specified period. The rule is non-compliant if the recovery point has a retention point less than 35 days."
  query       = query.backup_recovery_point_min_retention_35_days

  tags = merge(local.conformance_pack_backup_common_tags, {
    cisa_cyber_essentials    = "true"
    ffiec                    = "true"
    gxp_eu_annex_11          = "true"
    hipaa_security_rule_2003 = "true"
    nist_800_171_rev_2       = "true"
    pci_dss_v321             = "true"
  })
}

query "backup_recovery_point_manual_deletion_disabled" {
  sql = <<-EOQ
    with recovery_point_manual_deletion_disabled as (
      select
        arn
      from
        aws_backup_vault,
        jsonb_array_elements(policy -> 'Statement') as s
      where
        s ->> 'Effect' = 'Deny' and
        s -> 'Action' @> '["backup:DeleteRecoveryPoint","backup:UpdateRecoveryPointLifecycle","backup:PutBackupVaultAccessPolicy"]'
        and s ->> 'Resource' = '*'
      group by
        arn
    )
    select
      v.arn as resource,
      case
        when d.arn is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when d.arn is not null then v.title || ' recovery point manual deletion disabled.'
        else v.title || ' recovery point manual deletion not disabled.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
    from
      aws_backup_vault as v
      left join recovery_point_manual_deletion_disabled as d on v.arn = d.arn;
  EOQ
}

query "backup_plan_min_retention_35_days" {
  sql = <<-EOQ
    with all_plans as (
      select
        arn,
        r as Rules,
        title,
        region,
        account_id,
        _ctx
      from
        aws_backup_plan,
        jsonb_array_elements(backup_plan -> 'Rules') as r
    )
    select
      -- The resource ARN can be duplicate as we are checking all the associated rules to the backup-plan
      -- Backup plans are composed of one or more backup rules.
      -- https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html
      r.arn as resource,
      case
        when r.Rules is null then 'alarm'
        when r.Rules ->> 'Lifecycle' is null then 'ok'
        when (r.Rules -> 'Lifecycle' ->> 'DeleteAfterDays')::int >= 35 then 'ok'
        else 'alarm'
      end as status,
      case
        when r.Rules is null then r.title || ' retention period not set.'
        when r.Rules ->> 'Lifecycle' is null then (r.Rules ->> 'RuleName') || ' retention period set to never expire.'
        else (r.Rules ->> 'RuleName') || ' retention period set to ' || (r.Rules -> 'Lifecycle' ->> 'DeleteAfterDays') || ' days.'
      end as reason
      ${local.common_dimensions_sql}
    from
      all_plans as r;
  EOQ
}

query "backup_recovery_point_encryption_enabled" {
  sql = <<-EOQ
    select
      recovery_point_arn as resource,
      case
        when is_encrypted then 'ok'
        else 'alarm'
      end as status,
      case
        when is_encrypted then recovery_point_arn || ' encryption enabled.'
        else recovery_point_arn || ' encryption disabled.'
      end as reason
      ${local.common_dimensions_sql}
    from
      aws_backup_recovery_point;
  EOQ
}

query "backup_recovery_point_min_retention_35_days" {
  sql = <<-EOQ
    select
      recovery_point_arn as resource,
      case
        when (lifecycle -> 'DeleteAfterDays') is null then 'ok'
        when (lifecycle -> 'DeleteAfterDays')::int >= 35 then 'ok'
        else 'alarm'
      end as status,
      case
        when (lifecycle -> 'DeleteAfterDays') is null then split_part(recovery_point_arn, ':', -1) || ' retention period set to never expire.'
        else split_part(recovery_point_arn, ':', -1) || ' recovery point has a retention period of ' || (lifecycle -> 'DeleteAfterDays')::int || ' days.'
      end as reason
      ${local.common_dimensions_sql}
    from
      aws_backup_recovery_point;
  EOQ
}
