# Audit Findings Log

## Engagement framing
A cost-optimization audit on a simulated small-SaaS AWS environment, deliberately
seeded with common waste. Methodology, Terraform diff (baseline/ vs optimized/),
and Cost Explorer screenshots are real. NOTE: account is an AWS Free Plan account
(instance types restricted to free-tier-eligible), so the hero finding is
NAT-gateway elimination + governance waste, not compute downsizing.

## Day 0 — 2026-06-11, us-east-1
- Instances: i-090e33e201f0ca5f3, i-05e73cbde9f8399ef (t3.micro, Online via SSM)
- NAT gateway: nat-0f061c357ec316161  (the hero cost finding)
- RDS: costcase-mysql (db.t3.micro)
- S3: costcase-data-20260611090610871100000002 (no lifecycle policy)

## Findings & fixes (baseline -> optimized)

### F1 — NAT gateway for endpoint-eligible traffic  [HERO]
- Before: 1x NAT gateway, ~$33/mo ($0.045/hr x 730h + data).
- Insight: egress is S3/DynamoDB-bound; Amazon Linux 2023 package repos are
  S3-hosted, so even OS updates don't need a NAT.
- Fix: delete NAT + EIP; add free S3 + DynamoDB gateway endpoints.
- Saving: ~$33/mo.
- Honest tradeoff: SSM remote mgmt needs general egress; a prod box needing it
  would add 3 SSM interface endpoints (~$22/mo), partially offsetting. Full
  elimination holds for S3/DynamoDB-bound workloads.

### F2 — Idle Elastic IPs
- Before: 2x unassociated EIP, ~$7.30/mo. Fix: release. Saving: ~$7.30/mo.

### F3 — Unattached EBS + gp2
- Before: 2x 50GB gp2 unattached (~$10/mo); RDS storage on gp2.
- Fix: delete orphans; RDS gp2 -> gp3 (~20% cheaper, better IOPS).
- Saving: ~$10/mo + ~20% on RDS storage.

### F4 — S3 no lifecycle  [governance/prevention]
- Fix: Standard -> Standard-IA @30d -> Glacier @90d -> expire @365d.
- Saving: ~$0 now (empty bucket); on a real account with TBs in Standard this is
  frequently the single biggest line item.

### F5 — CloudWatch logs never expire  [governance]
- Fix: retention_in_days = 30. Caps unbounded log-storage growth.

### F6 — No tagging governance
- Fix: enforce full tag set via provider default_tags (Owner, CostCenter, Project,
  Environment). Recommend AWS Config required-tags rule for ongoing enforcement.

### F7 — Always-on compute  [MODELED, not built]
- Free-tier t3.micro here = $0 benefit, so documented not implemented.
- Model: EventBridge Scheduler + Lambda stop/start off-hours (8pm-7am + weekends).
- Math: a t3.large run 12h x 5d (60h/wk) vs 24x7 (168h/wk) = ~64% compute saving.
- On a real always-on dev/staging fleet this is typically the largest single win.

## Before / After (simulated environment, monthly, billable waste)

| Item          | Before $/mo | After $/mo | Saving |
|---------------|------------:|-----------:|-------:|
| NAT gateway   |       33.00 |       0.00 |  33.00 |
| Idle EIPs (2) |        7.30 |       0.00 |   7.30 |
| Orphaned EBS  |       10.00 |       0.00 |  10.00 |
| RDS storage   |        2.00 |       1.60 |   0.40 |
| Total         |       52.30 |       1.60 |  50.70 |

Simulated billable waste eliminated: ~$50/mo (~$600/yr).

HONEST CALIBRATION: this environment was deliberately waste-heavy and its compute
is free-tier, so the % reduction is very high (~97% of eliminable spend). On real
production accounts, where compute dominates and is not free, this same audit
methodology typically yields 25-45% total-bill reduction.

## Evidence (measured, this account)
- Account type: AWS Free Plan -> actual billing $0. Savings are AWS published
  on-demand pricing applied to MEASURED usage, not a hypothetical.
- Before (baseline, ~24h): NatGateway-Hours 15, NatGateway-Bytes 0.15GB,
  PublicIPv4 IdleAddress 29.8 addr-hrs (2 idle EIPs), EBS gp2 1.94 GB-mo, RDS +
  EC2 live. Raw: docs/before-usage-and-cost.json
- After (optimized): NAT/EIP/EBS resources do not exist. Instances boot and install
  nginx from S3-hosted AL2023 repos via the S3 gateway endpoint, no NAT in path.
  Proof: docs/after-boot-log.txt ("nginx ... Complete!", cloud-init finished).
