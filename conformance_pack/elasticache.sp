locals {
  conformance_pack_elasticache_common_tags = merge(local.aws_compliance_common_tags, {
    service = "AWS/ElastiCache"
  })
}

control "elasticache_redis_cluster_automatic_backup_retention_15_days" {
  title       = "ElastiCache Redis cluster automatic backup should be enabled with retention period of 15 days or greater"
  description = "When automatic backups are enabled, Amazon ElastiCache creates a backup of the cluster on a daily basis. The backup can be retained for a number of days as specified by your organization. Automatic backups can help guard against data loss."
  query       = query.elasticache_redis_cluster_automatic_backup_retention_15_days

  tags = merge(local.conformance_pack_elasticache_common_tags, {
    cis_controls_v8_ig1                    = "true"
    cisa_cyber_essentials                  = "true"
    fedramp_low_rev_4                      = "true"
    fedramp_moderate_rev_4                 = "true"
    ffiec                                  = "true"
    gxp_21_cfr_part_11                     = "true"
    gxp_eu_annex_11                        = "true"
    hipaa_final_omnibus_security_rule_2013 = "true"
    hipaa_security_rule_2003               = "true"
    nist_800_53_rev_4                      = "true"
    nist_800_53_rev_5                      = "true"
    nist_csf                               = "true"
    pci_dss_v321                           = "true"
    rbi_cyber_security                     = "true"
    soc_2                                  = "true"
  })
}

query "elasticache_redis_cluster_automatic_backup_retention_15_days" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when snapshot_retention_limit < 15 then 'alarm'
        else 'ok'
      end as status,
      case
        when snapshot_retention_limit = 0 then title || ' automatic backups not enabled.'
        when snapshot_retention_limit < 15 then title || ' automatic backup retention period is less than 15 days.'
        else title || ' automatic backup retention period is more than 15 days.'
      end as reason
      ${local.common_dimensions_sql}
    from
      aws_elasticache_replication_group;
  EOQ
}

query "elasticache_subnet_group_check" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when cache_subnet_group_name = 'default' then 'alarm'
        else 'ok'
      end as status,
      case
        when cache_subnet_group_name = 'default' then title || ' not configured with a custom subnet group.'
        else title || ' configured with a custom subnet group.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_elasticache_cluster;
  EOQ
}

query "elasticache_replication_group_redis_auth_enabled" {
  sql = <<-EOQ
    with elasticache_cluster_node_version as (
      select
        distinct replication_group_id,
        engine_version
      from
        aws_elasticache_cluster
    )
    select
      arn,
      case 
        when regexp_split_to_array(v.engine_version, '\.')::int[] < regexp_split_to_array('6.0', '\.')::int[] and eg.auth_token_enabled is false then 'alarm'
        when regexp_split_to_array(v.engine_version, '\.')::int[] >= regexp_split_to_array('6.0', '\.')::int[] then 'skip'
        else 'ok'
      end as status,
      case
        when regexp_split_to_array(v.engine_version, '\.')::int[] < regexp_split_to_array('6.0', '\.')::int[] and eg.auth_token_enabled is false then eg.title || ' have Redis AUTH disabled.'
        when regexp_split_to_array(v.engine_version, '\.')::int[] >= regexp_split_to_array('6.0', '\.')::int[] then eg.title || ' RBAC is supported since version of its nodes is higher than 6.0.'
        else eg.title || ' have Redis AUTH enabled.'
      end as reason
    from
      aws_elasticache_replication_group as eg
      left join elasticache_cluster_node_version as v on eg.replication_group_id = v.replication_group_id;
  EOQ
}

query "elasticache_replication_group_encrypted_at_rest" {
  sql = <<-EOQ
    select
      arn,
      case 
        when at_rest_encryption_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when at_rest_encryption_enabled then title || ' encrypted at rest.'
        else title || ' not  encrypted at rest.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_elasticache_replication_group;
  EOQ
}

query "elasticache_replication_group_encrypted_in_transit" {
  sql = <<-EOQ
    select
      arn,
      case 
        when transit_encryption_enabled then 'ok'
        else 'alarm'
      end as status,
      case
        when transit_encryption_enabled then title || ' transit encryption enabled.'
        else title || ' transit encryption disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_elasticache_replication_group;
  EOQ
}

query "elasticache_replication_group_auto_failover_enabled" {
  sql = <<-EOQ
    select
      arn,
      case 
        when automatic_failover = 'enabled' then 'ok'
        else 'alarm'
      end as status,
      case
        when automatic_failover = 'enabled' then title || ' automatic failover enabled.'
        else title || ' automatic failover disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_elasticache_replication_group;
  EOQ
}

query "elasticache_auto_minor_version_upgrade_check" {
  sql = <<-EOQ
    select
      arn,
      case 
        when auto_minor_version_upgrade then 'ok'
        else 'alarm'
      end as status,
      case
        when auto_minor_version_upgrade then title || ' automatic minor version upgrades enabled.'
        else title || ' automatic minor version upgrades disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      aws_elasticache_cluster;
  EOQ
}