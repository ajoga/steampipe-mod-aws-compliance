locals {
  audit_manager_pci_v321_requirement_3_common_tags = merge(local.audit_manager_pci_v321_common_tags, {
    control_set = "pci_v321_requirement_3"
  })
}

benchmark "audit_manager_pci_v321_requirement_3" {
  title       = "Requirement 3: Protect stored cardholder data"
  description = ""

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_1,
    benchmark.audit_manager_pci_v321_requirement_3_2,
    benchmark.audit_manager_pci_v321_requirement_3_4,
    benchmark.audit_manager_pci_v321_requirement_3_5
  ]

  tags = local.audit_manager_pci_v321_requirement_3_common_tags
}

benchmark "audit_manager_pci_v321_requirement_3_1" {
  title       = "3.1 Keep cardholder data storage to a minimum by implementing data retention and disposal policies, procedures and processes that include at least the following for all cardholder data (CHD) storage: • Limiting data storage amount and retention time to that which is required for legal, regulatory, and/or business requirements • Specific retention requirements for cardholder data • Processes for secure deletion of data when no longer needed • A quarterly process for identifying and securely deleting stored cardholder data that exceeds defined retention"
  description = "Identifying and deleting stored data that has exceeded its specified retention period prevents unnecessary retention of data that is no longer needed. This process may be automated or manual or a combination of both. For example, a programmatic procedure (automatic or manual) to locate and remove data and/or a manual review of data storage areas could be performed. Implementing secure deletion methods ensure that the data cannot be retrieved when it is no longer needed. Remember, if you don't need it, don't store it!"

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_1_a,
    benchmark.audit_manager_pci_v321_requirement_3_1_c,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.1"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_1_a" {
  title       = "3.1.a Examine the data retention and disposal policies, procedures and processes to verify they include the following for all cardholder data (CHD) storage: • Limiting data storage amount and retention time to that which is required for legal, regulatory, and/or business requirements. • Specific requirements for retention of cardholder data (for example, cardholder data needs to be held for X period for Y business reasons). • Processes for secure deletion of cardholder data when no longer needed for legal, regulatory, or business reasons. • A quarterly process for identifying and securely deleting stored cardholder data that exceeds defined retention requirements"
  description = "Identifying and deleting stored data that has exceeded its specified retention period prevents unnecessary retention of data that is no longer needed. This process may be automated or manual or a combination of both. For example, a programmatic procedure (automatic or manual) to locate and remove data and/or a manual review of data storage areas could be performed. Implementing secure deletion methods ensure that the data cannot be retrieved when it is no longer needed. Remember, if you don't need it, don't store it!"

  children = [
    control.s3_bucket_lifecycle_policy_enabled
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.1.a"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_1_c" {
  title       = "3.1.c For a sample of system components that store cardholder data: • Examine files and system records to verify that the data stored does not exceed the requirements defined in the data retention policy • Observe the deletion mechanism to verify data is deleted securely"
  description = "Identifying and deleting stored data that has exceeded its specified retention period prevents unnecessary retention of data that is no longer needed. This process may be automated or manual or a combination of both. For example, a programmatic procedure (automatic or manual) to locate and remove data and/or a manual review of data storage areas could be performed. Implementing secure deletion methods ensure that the data cannot be retrieved when it is no longer needed. Remember, if you don't need it, don't store it!"

  children = [
    control.backup_plan_min_retention_35_days,
    control.backup_recovery_point_encryption_enabled,
    control.backup_recovery_point_manual_deletion_disabled,
    control.backup_recovery_point_min_retention_35_days,
    control.dynamodb_table_in_backup_plan,
    control.dynamodb_table_point_in_time_recovery_enabled,
    control.dynamodb_table_protected_by_backup_plan,
    control.ebs_volume_in_backup_plan,
    control.ebs_volume_protected_by_backup_plan,
    control.ec2_instance_ebs_optimized,
    control.ec2_instance_protected_by_backup_plan,
    control.efs_file_system_in_backup_plan,
    control.efs_file_system_protected_by_backup_plan,
    control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    control.fsx_file_system_protected_by_backup_plan,
    control.rds_db_cluster_aurora_protected_by_backup_plan,
    control.rds_db_instance_backup_enabled,
    control.rds_db_instance_in_backup_plan,
    control.rds_db_instance_protected_by_backup_plan,
    control.redshift_cluster_automatic_snapshots_min_7_days,
    control.s3_bucket_cross_region_replication_enabled,
    control.s3_bucket_versioning_enabled,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.1.a"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_2" {
  title       = "3.2 Do not store sensitive authentication data after authorization (even if encrypted). If sensitive authentication data is received, render all data unrecoverable upon completion of the authorization process. It is permissible for issuers and companies that support issuing services to store sensitive authentication data if: • There is a business justification and • The data is stored securely. Sensitive authentication data includes the data as cited in the following Requirements 3.2.1 through 3.2.3"
  description = "Sensitive authentication data consists of full track data, card validation code or value, and PIN data. Storage of sensitive authentication data after authorization is prohibited! This data is very valuable to malicious individuals as it allows them to generate counterfeit payment cards and create fraudulent transactions. Entities that issue payment cards or that perform or support issuing services will often create and control sensitive authentication data as part of the issuing function. It is allowable for companies that perform, facilitate, or support issuing services to store sensitive authentication data ONLY IF they have a legitimate business need to store such data. It should be noted that all PCI DSS requirements apply to issuers, and the only exception for issuers and issuer processors is that sensitive authentication data may be retained if there is a legitimate reason to do so. A legitimate reason is one that is necessary for the performance of the function being provided for the issuer and not one of convenience. Any such data must be stored securely and in accordance with all PCI DSS and specific payment brand requirements."

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_2_3,
    benchmark.audit_manager_pci_v321_requirement_3_2_c,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.2"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_2_3" {
  title       = "3.2.3 Do not store the personal identification number (PIN) or the encrypted PIN block after authorization"
  description = "These values should be known only to the card owner or bank that issued the card. If this data is stolen, malicious individuals can execute fraudulent PIN-based debit transactions (for example, ATM withdrawals). For a sample of system components, examine data sources, including but not limited to the following and verify that PINs and encrypted PIN blocks are not stored after authorization: • Incoming transaction data • All logs (for example, transaction, history, debugging, error) • History files • Trace files • Several database schemas • Database contents"

  children = [
    control.apigateway_stage_logging_enabled,
    control.cloudtrail_multi_region_trail_enabled,
    control.cloudtrail_trail_enabled,
    control.cloudtrail_trail_integrated_with_logs,
    control.elb_application_classic_lb_logging_enabled,
    control.rds_db_instance_logging_enabled,
    control.waf_web_acl_logging_enabled,
    control.wafv2_web_acl_logging_enabled,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.2.3"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_2_c" {
  title       = "3.2.c For all other entities, if sensitive authentication data is received, review policies and procedures, and examine system configurations to verify the data is not retained after authorization"
  description = "Sensitive authentication data consists of full track data, card validation code or value, and PIN data. Storage of sensitive authentication data after authorization is prohibited! This data is very valuable to malicious individuals as it allows them to generate counterfeit payment cards and create fraudulent transactions. Entities that issue payment cards or that perform or support issuing services will often create and control sensitive authentication data as part of the issuing function. It is allowable for companies that perform, facilitate, or support issuing services to store sensitive authentication data ONLY IF they have a legitimate business need to store such data. It should be noted that all PCI DSS requirements apply to issuers, and the only exception for issuers and issuer processors is that sensitive authentication data may be retained if there is a legitimate reason to do so. A legitimate reason is one that is necessary for the performance of the function being provided for the issuer and not one of convenience. Any such data must be stored securely and in accordance with all PCI DSS and specific payment brand requirements."

  children = [
    control.s3_bucket_lifecycle_policy_enabled
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.2.c"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4" {
  title       = "3.4 Render PAN unreadable anywhere it is stored (including on portable digital media, backup media, and in logs) by using any of the following approaches: • One-way hashes based on strong cryptography, (hash must be of the entire PAN) • Truncation (hashing cannot be used to replace the truncated segment of PAN) • Index tokens and pads (pads must be securely stored) • Strong cryptography with associated key-management processes and procedures. Note: It is a relatively trivial effort for a malicious individual to reconstruct original PAN data if they have access to both the truncated and hashed version of a PAN. Where hashed and truncated versions of the same PAN are present in an entity's environment, additional controls must be in place to ensure that the hashed and truncated versions cannot be correlated to reconstruct the original PAN"
  description = "PANs stored in primary storage (databases, or flat files such as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception or troubleshooting logs) must all be protected. One-way hash functions based on strong cryptography can be used to render cardholder data unreadable. Hash functions are appropriate when there is no need to retrieve the original number (one-way hashes are irreversible). It is recommended, but not currently a requirement, that an additional, random input value be added to the cardholder data prior to hashing to reduce the feasibility of an attacker comparing the data against (and deriving the PAN from) tables of pre- computed hash values. The intent of truncation is to permanently remove a segment of PAN data so that only a portion (generally not to exceed the first six and last four digits) of the PAN is stored. An index token is a cryptographic token that replaces the PAN based on a given index for an unpredictable value. A one-time pad is a system in which a randomly generated private key is used only once to encrypt a message that is then decrypted using a matching one-time pad and key. The intent of strong cryptography (as defined in the PCI DSS and PA-DSS Glossary of Terms, Abbreviations, and Acronyms) is that the encryption be based on an industry-tested and accepted algorithm (not a proprietary or `home- grown` algorithm) with strong cryptographic keys. By correlating hashed and truncated versions of a given PAN, a malicious individual may easily derive the original PAN value. Controls that prevent the correlation of this data will help ensure that the original PAN remains unreadable."

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_4_1,
    benchmark.audit_manager_pci_v321_requirement_3_4_a,
    benchmark.audit_manager_pci_v321_requirement_3_4_b,
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_1" {
  title       = "3.4.1 If disk encryption is used (rather than file- or column-level database encryption), logical access must be managed separately and independently of native operating system authentication and access control mechanisms (for example, by not using local user account databases or general network login credentials). Decryption keys must not be associated with user accounts. Note: This requirement applies in addition to all other PCI DSS encryption and key- management requirements"
  description = "PANs stored in primary storage (databases, or flat files such as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception or troubleshooting logs) must all be protected. One-way hash functions based on strong cryptography can be used to render cardholder data unreadable. Hash functions are appropriate when there is no need to retrieve the original number (one-way hashes are irreversible). It is recommended, but not currently a requirement, that an additional, random input value be added to the cardholder data prior to hashing to reduce the feasibility of an attacker comparing the data against (and deriving the PAN from) tables of pre- computed hash values. The intent of truncation is to permanently remove a segment of PAN data so that only a portion (generally not to exceed the first six and last four digits) of the PAN is stored. An index token is a cryptographic token that replaces the PAN based on a given index for an unpredictable value. A one-time pad is a system in which a randomly generated private key is used only once to encrypt a message that is then decrypted using a matching one-time pad and key. The intent of strong cryptography (as defined in the PCI DSS and PA-DSS Glossary of Terms, Abbreviations, and Acronyms) is that the encryption be based on an industry-tested and accepted algorithm (not a proprietary or `home-grown` algorithm) with strong cryptographic keys. By correlating hashed and truncated versions of a given PAN, a malicious individual may easily derive the original PAN value. Controls that prevent the correlation of this data will help ensure that the original PAN remains unreadable."

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_4_1_a,
    benchmark.audit_manager_pci_v321_requirement_3_4_1_c,
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.1"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_1_a" {
  title       = "3.4.1.a If disk encryption is used, inspect the configuration and observe the authentication process to verify that logical access to encrypted file systems is implemented via a mechanism that is separate from the native operating system's authentication mechanism (for example, not using local user account databases or general network login credentials)"
  description = "The intent of this requirement is to address the acceptability of disk-level encryption for rendering cardholder data unreadable. Disk-level encryption encrypts the entire disk/partition on a computer and automatically decrypts the information when an authorized user requests it. Many disk- encryption solutions intercept operating system read/write operations and carry out the appropriate cryptographic transformations without any special action by the user other than supplying a password or pass phrase upon system startup or at the beginning of a session. Based on these characteristics of disk-level encryption, to be compliant with this requirement, the method cannot: 1) Use the same user account authenticator as the operating system, or 2) Use a decryption key that is associated with or derived from the system's local user account database or general network login credentials. Full disk encryption helps to protect data in the event of physical loss of a disk and therefore may be appropriate for portable devices that store cardholder data."

  children = [
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.1.a"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_1_c" {
  title       = "3.4.1.c Examine the configurations and observe the processes to verify that cardholder data on removable media is encrypted wherever stored. Note: If disk encryption is not used to encrypt removable media, the data stored on this media will need to be rendered unreadable through some other method"
  description = "The intent of this requirement is to address the acceptability of disk-level encryption for rendering cardholder data unreadable. Disk-level encryption encrypts the entire disk/partition on a computer and automatically decrypts the information when an authorized user requests it. Many disk- encryption solutions intercept operating system read/write operations and carry out the appropriate cryptographic transformations without any special action by the user other than supplying a password or pass phrase upon system startup or at the beginning of a session. Based on these characteristics of disk-level encryption, to be compliant with this requirement, the method cannot: 1) Use the same user account authenticator as the operating system, or 2) Use a decryption key that is associated with or derived from the system’s local user account database or general network login credentials. Full disk encryption helps to protect data in the event of physical loss of a disk and therefore may be appropriate for portable devices that store cardholder data."

  children = [
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.1.c"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_a" {
  title       = "3.4.a Examine documentation about the system used to protect the PAN, including the vendor, type of system/process, and the encryption algorithms (if applicable) to verify that the PAN is rendered unreadable using any of the following methods: • One-way hashes based on strong cryptography, • Truncation • Index tokens and pads, with the pads being securely stored • Strong cryptography, with associated key-management processes and procedures"
  description = "PANs stored in primary storage (databases, or flat files such as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception or troubleshooting logs) must all be protected. One-way hash functions based on strong cryptography can be used to render cardholder data unreadable. Hash functions are appropriate when there is no need to retrieve the original number (one-way hashes are irreversible). It is recommended, but not currently a requirement, that an additional, random input value be added to the cardholder data prior to hashing to reduce the feasibility of an attacker comparing the data against (and deriving the PAN from) tables of pre- computed hash values. The intent of truncation is to permanently remove a segment of PAN data so that only a portion (generally not to exceed the first six and last four digits) of the PAN is stored. An index token is a cryptographic token that replaces the PAN based on a given index for an unpredictable value. A one-time pad is a system in which a randomly generated private key is used only once to encrypt a message that is then decrypted using a matching one-time pad and key. The intent of strong cryptography (as defined in the PCI DSS and PA-DSS Glossary of Terms, Abbreviations, and Acronyms) is that the encryption be based on an industry-tested and accepted algorithm (not a proprietary or `home-grown` algorithm) with strong cryptographic keys. By correlating hashed and truncated versions of a given PAN, a malicious individual may easily derive the original PAN value. Controls that prevent the correlation of this data will help ensure that the original PAN remains unreadable."

  children = [
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.backup_recovery_point_encryption_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.opensearch_domain_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.a"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_b" {
  title       = "3.4.b Examine several tables or files from a sample of data repositories to verify the PAN is rendered unreadable (that is, not stored in plain-text)"
  description = "PANs stored in primary storage (databases, or flat files such as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception or troubleshooting logs) must all be protected. One-way hash functions based on strong cryptography can be used to render cardholder data unreadable. Hash functions are appropriate when there is no need to retrieve the original number (one-way hashes are irreversible). It is recommended, but not currently a requirement, that an additional, random input value be added to the cardholder data prior to hashing to reduce the feasibility of an attacker comparing the data against (and deriving the PAN from) tables of pre- computed hash values. The intent of truncation is to permanently remove a segment of PAN data so that only a portion (generally not to exceed the first six and last four digits) of the PAN is stored. An index token is a cryptographic token that replaces the PAN based on a given index for an unpredictable value. A one-time pad is a system in which a randomly generated private key is used only once to encrypt a message that is then decrypted using a matching one-time pad and key. The intent of strong cryptography (as defined in the PCI DSS and PA-DSS Glossary of Terms, Abbreviations, and Acronyms) is that the encryption be based on an industry-tested and accepted algorithm (not a proprietary or `home- grown` algorithm) with strong cryptographic keys. By correlating hashed and truncated versions of a given PAN, a malicious individual may easily derive the original PAN value. Controls that prevent the correlation of this data will help ensure that the original PAN remains unreadable."

  children = [
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.backup_recovery_point_encryption_enabled,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.dax_cluster_encryption_at_rest_enabled,
    control.dynamodb_table_encrypted_with_kms,
    control.dynamodb_table_encryption_enabled,
    control.ebs_attached_volume_encryption_enabled,
    control.ec2_ebs_default_encryption_enabled,
    control.efs_file_system_encrypted_with_cmk,
    control.eks_cluster_secrets_encrypted,
    control.es_domain_encryption_at_rest_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.opensearch_domain_encryption_at_rest_enabled,
    control.rds_db_instance_encryption_at_rest_enabled,
    control.rds_db_snapshot_encrypted_at_rest,
    control.redshift_cluster_encryption_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.sagemaker_endpoint_configuration_encryption_at_rest_enabled,
    control.sagemaker_notebook_instance_encryption_at_rest_enabled,
    control.sns_topic_encrypted_at_rest,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.b"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_4_d" {
  title       = "3.4.d Examine a sample of audit logs, including payment application logs, to confirm that PAN is rendered unreadable or is not present in the logs"
  description = "PANs stored in primary storage (databases, or flat files such as text files spreadsheets) as well as non-primary storage (backup, audit logs, exception or troubleshooting logs) must all be protected. One-way hash functions based on strong cryptography can be used to render cardholder data unreadable. Hash functions are appropriate when there is no need to retrieve the original number (one-way hashes are irreversible). It is recommended, but not currently a requirement, that an additional, random input value be added to the cardholder data prior to hashing to reduce the feasibility of an attacker comparing the data against (and deriving the PAN from) tables of pre- computed hash values. The intent of truncation is to permanently remove a segment of PAN data so that only a portion (generally not to exceed the first six and last four digits) of the PAN is stored. An index token is a cryptographic token that replaces the PAN based on a given index for an unpredictable value. A one-time pad is a system in which a randomly generated private key is used only once to encrypt a message that is then decrypted using a matching one-time pad and key. The intent of strong cryptography (as defined in the PCI DSS and PA-DSS Glossary of Terms, Abbreviations, and Acronyms) is that the encryption be based on an industry-tested and accepted algorithm (not a proprietary or 'home-grown` algorithm) with strong cryptographic keys. By correlating hashed and truncated versions of a given PAN, a malicious individual may easily derive the original PAN value. Controls that prevent the correlation of this data will help ensure that the original PAN remains unreadable."

  children = [
    control.apigateway_stage_cache_encryption_at_rest_enabled,
    control.cloudtrail_multi_region_trail_enabled,
    control.cloudtrail_trail_enabled,
    control.cloudtrail_trail_integrated_with_logs,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.elb_application_classic_lb_logging_enabled,
    control.log_group_encryption_at_rest_enabled,
    control.rds_db_instance_logging_enabled,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.waf_web_acl_logging_enabled,
    control.wafv2_web_acl_logging_enabled,
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.4.d"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_5" {
  title       = "3.5 Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse: Note: This requirement applies to keys used to encrypt stored cardholder data, and also applies to key-encrypting keys used to protect data-encrypting keys—such key- encrypting keys must be at least as strong as the data-encrypting key"
  description = "Cryptographic keys must be strongly protected because those who obtain access will be able to decrypt data. Key-encrypting keys, if used, must be at least as strong as the data-encrypting key in order to ensure proper protection of the key that encrypts the data as well as the data encrypted with that key. The requirement to protect keys from disclosure and misuse applies to both data-encrypting keys and key-encrypting keys. Because one key- encrypting key may grant access to many data- encrypting keys, the key-encrypting keys require strong protection measures."

  children = [
    benchmark.audit_manager_pci_v321_requirement_3_5_2
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.5"
  })
}

benchmark "audit_manager_pci_v321_requirement_3_5_2" {
  title       = "3.5 Document and implement procedures to protect keys used to secure stored cardholder data against disclosure and misuse: Note: This requirement applies to keys used to encrypt stored cardholder data, and also applies to key-encrypting keys used to protect data-encrypting keys—such key- encrypting keys must be at least as strong as the data-encrypting key"
  description = "Cryptographic keys must be strongly protected because those who obtain access will be able to decrypt data. Key-encrypting keys, if used, must be at least as strong as the data-encrypting key in order to ensure proper protection of the key that encrypts the data as well as the data encrypted with that key. The requirement to protect keys from disclosure and misuse applies to both data-encrypting keys and key-encrypting keys. Because one key- encrypting key may grant access to many data- encrypting keys, the key-encrypting keys require strong protection measures."

  children = [
    control.iam_policy_inline_no_blocked_kms_actions,
    control.iam_policy_custom_no_blocked_kms_actions
  ]
  tags = merge(local.audit_manager_pci_v321_requirement_3_common_tags, {
    audit_manager_pci_v321_item_id = "3.5.2"
  })
}